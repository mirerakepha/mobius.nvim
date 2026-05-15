local M = {}
local kitty = require("mobius.kitty")

local LOGO_COLS = 6
local LOGO_ROWS = 3
local PAD_RIGHT = 12 -- from right edge
local PAD_BOTTOM = 6 -- from bottom edge

function M.get_position()
    local ui = vim.api.nvim_list_uis()[1]
    local term_cols = ui.width
    local term_rows = ui.height

    -- bottom right corner minus padding
    local col = term_cols - LOGO_COLS - PAD_RIGHT
    local row = term_rows - LOGO_ROWS - PAD_BOTTOM

    return col, row
end

local win_id = nil
local buf_id = nil

function M.claim_cells()
    local col, row = M.get_position()

    if not buf_id then
        buf_id = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { "      ", "      ", "      " })
    end



    local opts = {
        relative = "editor",
        col = col,
        row = row,
        width = LOGO_COLS,
        height = LOGO_ROWS,
        style = "minimal",
        focusable = false,
        zindex = 1

    }

    if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_set_config(win_id, opts)
    else
        win_id = vim.api.nvim_open_win(buf_id, false, opts)
        vim.api.nvim_win_set_option(win_id, "winblend", 100) -- invisible
    end
end

function M.close()
    if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
        win_id = nil
    end
end

return M
