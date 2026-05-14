--local assets = vim.fn.stdpath("data") .. "/mobius/assets/"
local assets = vim.fn.expand("~/RustProjects/mobius/assets/")

local map = {
    rust        = assets .. "rust.png",
    c           = assets .. "c.png",
    cpp         = assets .. "cplusplus.png",   
    python      = assets .. "python.png",
    javascript  = assets .. "javascript.png",  
    typescript  = assets .. "typescript.png",  
    go          = assets .. "go.png",
    lua         = assets .. "lua.png",
    zig         = assets .. "zig.png",
    sh          = assets .. "gnubash.png",
    bash        = assets .. "gnubash.png",
    css         = assets .. "css.png",
    html        = assets .. "html5.png",
    haskell     = assets .. "haskell.png",
}

return {
    get_png = function(ft) return map[ft] end
}
