local M = {}

local function load_config()
    local cfg_path = vim.fn.expand("~/.config/mobius/mobius.toml")
    local pad_right = 12
    local pad_bottom = 6

    if vim.fn.filereadable(cfg_path) == 1 then
        for line in io.lines(cfg_path) do
            local r = line:match("pad_right%s*=%s*(%d+)")
            local b = line:match("pad_bottom%s*=%s*(%d+)")
            if r then pad_right = tonumber(r) end
            if b then pad_bottom = tonumber(b) end
        end
    end
    
    return pad_right, pad_bottom
end

-- local kitty = require("mobius.kitty")

local LOGO_COLS = 6
local LOGO_ROWS = 3
local win_id = nil
local buf_id = nil

function M.get_position()
    local pad_right, pad_bottom = load_config()
    local ui = vim.api.nvim_list_uis()[1]

    -- bottom right corner minus padding
    local col = ui.width - LOGO_COLS - pad_right
    local row = ui.height - LOGO_ROWS - pad_bottom

    return col, row
end

function M.claim_cells()
    local col, row = M.get_position()

    if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
        buf_id = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { "      ", "      ", "      ", "      " })
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
        vim.wo[win_id].winblend = 100 -- invisible
    end
end

function M.close()
    if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
        win_id = nil
    end
end

return M
