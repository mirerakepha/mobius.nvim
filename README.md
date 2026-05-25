## Sulphate
---

	This tool displays a watermark logo of the respective file type opened in NeoVim,
	A Neovim plugin that renders a faint language watermark logo in the bottom-right
	corner of your editor using the Kitty Graphics Protocol. Written in Rust with a
	Lua injection layer.

	Inspired by the language symbols in Starship prompt.

	
---

## Requirements

- **Kitty terminal** (or WezTerm / Ghostty — any terminal supporting the
  [Kitty Graphics Protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/))
- Neovim 0.10+
- The `mobius` binary on your PATH or at a known location
	
- Install kitty terminal
``` sudo dnf install kitty```

---

##### How it works

1. Neovim fires a `BufEnter` autocommand when you open a file
2. The Lua layer detects the filetype and resolves the matching tinted PNG
3. The PNG is base64-encoded and sent to the Kitty terminal via APC escape
 	sequences (`ESC_G...ESC\`) written directly to `/proc/self/fd/0`
4. Kitty renders the image at the computed bottom-right cell position
5. On `VimResized` the old image is deleted and redrawn at the new position
6. On `BufLeave` / `VimLeave` the image is deleted cleanly
 
