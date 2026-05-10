local assets = vim.fn.stdpath("data") .. "/mobius/assets/"

local map = {
    rust       = assets .. "rust.png",
    c          = assets .. "c.png",
    cpp        = assets .. "cpp.png",
    python     = assets .. "python.png",
    javascript = assets .. "js.png",
    typescript = assets .. "ts.png",
    go         = assets .. "go.png",
    lua        = assets .. "lua.png",
    zig        = assets .. "zig.png",
}

return {
    get_png = function(ft) return map[ft] end
}
