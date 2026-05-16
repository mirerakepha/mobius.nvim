--local assets = vim.fn.stdpath("data") .. "/mobius/assets/"
    -- decode PNG to raw RGBA using the RS binary as a converter
local assets = vim.fn.expand("~/RustProjects/mobius/assets/")

local map = {
    rust        = assets .. "tinted_rust.png",
    c           = assets .. "tinted_c.png",
    cpp         = assets .. "tinted_cplusplus.png",   
    python      = assets .. "tinted_python.png",
    javascript  = assets .. "tinted_javascript.png",  
    typescript  = assets .. "tinted_typescript.png",  
    go          = assets .. "tinted_go.png",
    lua         = assets .. "tinted_lua.png",
    zig         = assets .. "tinted_zig.png",
    sh          = assets .. "tinted_gnubash.png",
    bash        = assets .. "tinted_gnubash.png",
    css         = assets .. "tinted_css.png",
    html        = assets .. "tinted_html5.png",
    haskell     = assets .. "tinted_haskell.png",
}

return {
    get_png = function(ft) return map[ft] end
}

