# Mobius
---

	This nvim plugin displays a watermark logo of the respective file type opened in NeoVim. 
    Uses the Kitty Graphics Protocol. Written in Rust with a
	Lua injection layer.

	Inspired by the language symbols in Starship prompt.

	
---

## Requirements

- **Kitty terminal** (or WezTerm / Ghostty — any terminal supporting the
  [Kitty Graphics Protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/))
- Neovim 0.10+
- The `mobius` binary on your PATH or at a known location
	
## Installation
#### 1. Download the binary
Grab the latest binary from the [releases page](#) and place it somewhere:

```bash
# example — place in ~/.local/bin
curl -Lo ~/.local/bin/mobius 
chmod +x ~/.local/bin/mobius
```

Or build from source:

```bash
git clone https://github.com/mirerakepha/mobius
cd mobius
cargo build --release
cp target/release/mobius ~/.local/bin/mobius
```

### 2. Download the assets

```bash
mkdir -p ~/.local/share/mobius/assets
# copy the tinted_*.png files from the repo's assets/ folder
# into ~/.local/share/mobius/assets/
```

### 3. Install the Neovim plugin

With **lazy.nvim**:

```lua
{
  dir = "/path/to/mobius",   -- local clone
  -- or use:
  -- "mirerakepha/mobius",
  name = "mobius",
  config = function()
    require("mobius").setup()
  end,
}
```

### 4. Configure to your liking (optional)

Mobius looks for a config file at `~/.config/mobius/mobius.toml`.
If it doesn't exist, sensible defaults are used.

```toml
[tint]
# RGB color for the watermark (0–255 each)
# Default is a pink/maroon <idk that color too>
r = 255
g = 100
b = 140

# Opacity (0.0 = invisible, 1.0 = fully opaque)
opacity = 0.65

[position]
# Distance from edges in terminal cells
pad_right  = 10
pad_bottom = 4
```

After editing the config, regenerate the tinted assets:

```bash
cd ~/.local/share/mobius/assets
for f in *.png; do
  [[ "$f" == tinted_* ]] && continue
  mobius --png "$f" --out "tinted_$f" \
    --id 0 --col 0 --row 0 --cell-w 14 --cell-h 28
done
```

Then restart Neovim.

## Supported languages

| Filetype     | Logo        |
|--------------|-------------|
| `rust`       | Rust        |
| `c`          | C           |
| `cpp`        | C++         |
| `python`     | Python      |
| `javascript` | JavaScript  |
| `typescript` | TypeScript  |
| `go`         | Go          |
| `lua`        | Lua         |
| `zig`        | Zig         |
| `sh`/`bash`  | GNU Bash    |
| `css`        | CSS         |
| `html`       | HTML5       |
| `haskell`    | Haskell     |


---
<img width="1440" height="777" alt="Screenshot From 2026-06-25 07-46-08" src="https://github.com/user-attachments/assets/ae6d75ca-ebc0-49ce-beb8-2f5570d2c173" />
<img width="1440" height="777" alt="Screenshot From 2026-06-25 07-44-52" src="https://github.com/user-attachments/assets/3c5774b3-2e6d-4cdd-a46f-7f088014e23a" />
<img width="1440" height="777" alt="Screenshot From 2026-06-25 07-43-58" src="https://github.com/user-attachments/assets/5f597462-551d-4fb5-a6f4-9beac5b2989c" />


##### How it works

1. Neovim fires a `BufEnter` autocommand when you open a file
2. The Lua layer detects the filetype and resolves the matching tinted PNG
3. The PNG is base64-encoded and sent to the Kitty terminal via APC escape
 	sequences (`ESC_G...ESC\`) written directly to `/proc/self/fd/0`
4. Kitty renders the image at the computed bottom-right cell position
5. On `VimResized` the old image is deleted and redrawn at the new position
6. On `BufLeave` / `VimLeave` the image is deleted cleanly
 

## License

MIT
