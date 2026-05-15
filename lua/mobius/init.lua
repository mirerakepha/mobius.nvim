local M = {}
    -- decode PNG to raw RGBA using the RS binary as a converter

local detect  = require("mobius.detect")
local overlay = require("mobius.overlay")
local kitty   = require("mobius.kitty")

local current_id = nil
local cell_w     = nil
local cell_h     = nil

local function show()
    local ft  = vim.bo.filetype
    local png = detect.get_png(ft)
    if not png or vim.fn.filereadable(png) == 0 then return end

    if current_id then kitty.delete(current_id) end
    overlay.close()

    if not cell_w then
        cell_w, cell_h = kitty.get_cell_size()
    end

    local col, row = overlay.get_position()
    current_id = math.random(1, 999999)

    overlay.claim_cells()

    -- small delay so nvim finishes drawing before we paint
    vim.defer_fn(function()
        kitty.send(png, col + 1, row + 1)
    end, 50)
end

local function hide()
    if current_id then
        kitty.delete(current_id)
        current_id = nil
    end
    overlay.close()
end

function M.setup()
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
