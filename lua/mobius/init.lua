local detect = require("mobius.detect")
local overlay = require("mobius.overlay")
local kitty = require("mobius.kitty")

local binary = vim.fn.stdpath("data") .. "/mobius/bin/mobius"
local current_id = nil

local function show()
    local ft = vim.bo.filetype
    local png = detect.get_png(ft)
    if not png then return end

    -- clean up prev image
    if current_id then kitty.delete(current_id) end
    overlay.close()


    local col, row = overlay.get_position()
    local cell_w, cell_h = kitty.get_cell_size()
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
        "cell_w", tostring(cell_w),
        "cell_h", tostring(cell_h),
    }, {
        on_exit = function(_, code)
            if code ~= 0 then
                vim.notify("mobius: render failed", vim.logs.levels.WARN)
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

--autocommands
local grp = vim.api.nvim_create_augroup("mobius", {clear = true})
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    group = grp, callback = show
})
vim.api.nvim_create_autocmd("VimResized", {
    group = grp, callback = function() hide(); show() end,
})
vim.api.nvim_create_autocmd({"BufLeave", "VimLeave"}, {
    group = grp, callback = hide
})
