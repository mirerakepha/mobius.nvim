local M = {}

local function get_outer_tty()
    local pid = vim.fn.getpid()
    local path = vim.fn.system("readlink /proc/" .. pid .. "/fd/0"):gsub("%s+", "")
    return path
end

local function send_to_kitty(sequence)
    local tty_path = get_outer_tty()
    local f = io.open(tty_path, "wb")
    if not f then
        vim.notify("[mobius] cannot open tty: " .. tty_path, vim.log.levels.WARN)
        return
    end
    f:write(sequence)
    f:flush()
    f:close()
end

function M.get_cell_size()
    return 14, 28
end

function M.send(png_path, col, row)
    local f = io.open(png_path, "rb")
    if not f then return end
    local bytes = f:read("*a")
    f:close()

    local b64 = vim.base64.encode(bytes)
    local seq = string.format("\x1b[%d;%dH", row, col)

    local chunk_size = 4096
    local total = #b64
    local pos = 1
    local first = true

    while pos <= total do
        local chunk = b64:sub(pos, pos + chunk_size - 1)
        pos = pos + chunk_size
        local is_last = pos > total
        local m = is_last and 0 or 1

        if first then
            seq = seq .. string.format(
                "\x1b_Ga=T,f=100,C=1,q=2,m=%d;%s\x1b\\", m, chunk
            )
            first = false
        else
            seq = seq .. string.format("\x1b_Gm=%d;%s\x1b\\", m, chunk)
        end
    end

    send_to_kitty(seq)
end

function M.delete(image_id)
    send_to_kitty(string.format("\x1b_Ga=d,d=i,i=%d\x1b\\", image_id))
end

return M
