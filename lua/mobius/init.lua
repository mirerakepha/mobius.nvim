local M = {}

local detect = require("mobius.detect")
local overlay = require("mobius.overlay")
local kitty = require("mobius.kitty")

-- local BINARY = vim.fn.stdpath("data") .. "/mobius/bin/mobius"
local BINARY = vim.fn.expand("~/RustProjects/mobius/target/release/mobius")
local current_id = nil
local cell_w = nil
local cell_h = nil


local function show()
    if vim.fn.executable(BINARY) == 0 then return end

    local ft = vim.bo.filetype
    local png = detect.get_png(ft)
    if not png or vim.fn.filereadable(png) == 0 then return end

    -- clean up prev image
    if current_id then kitty.delete(current_id) end
    overlay.close()

    if not cell_w then
        cell_w, cell_h = kitty.get_cell_size()
    end

    local col, row = overlay.get_position()
    current_id = math.random(1, 999999)

    -- claim text area so nvim text doesnt bleed through
    overlay.claim_cells()

    -- spawn the binary
    vim.fn.jobstart({
        BINARY,
        "--png", png,
        "--id", tostring(current_id),
        "--col", tostring(col),
        "--row", tostring(row),
        "--cell-w", tostring(cell_w),
        "--cell-h", tostring(cell_h),
    }, {
        on_exit = function(_, code)
            if code ~= 0 then
                vim.notify("[mobius] render failed (exit " .. code .. ")", vim.log.levels.WARN)
            end
        end
    })

end

local function hide()
    if current_id then
        kitty.delete(current_id)
        current_id = nil
    end
    overlay.close()
end

function M.setup()
    if vim.fn.executable(BINARY) == 0 then
        vim.notify("[mobius] binary not found: " .. BINARY, vim.log.levels.WARN)
        return
    end

    local grp = vim.api.nvim_create_augroup("mobius", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        group    = grp,
        callback = show,
    })
    vim.api.nvim_create_autocmd("VimResized", {
        group    = grp,
        callback = function() cell_w = nil; hide(); show() end,
    })
    vim.api.nvim_create_autocmd({ "BufLeave", "VimLeave" }, {
        group    = grp,
        callback = hide,
    })
end

return M
