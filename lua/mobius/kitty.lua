local M = {}

-- query terminal for cell px size
function M.get_cell_size()

    -- size of one cell -> from terminal
    io.write("\x1b[16t")
    io.flush()

    -- read response
    local resp = ""
    local fd = io.open("/dev/tty", "r")

    if fd then
        resp = fd:read(32) or ""
        fd:close()
    end

    local h, w = resp:match("\x1b%[6;(%d+);(%d+)t")
    return tonumber(w) or 14, tonumber(h) or 28
end

-- delete prev image by id
function M.delete(image_id)
    io.write(string.format("\x1b_Ga=d,d=i,i=%d\x1b\\", image_id))
    io.flush()
end

return M
