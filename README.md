# figuya

A warm, high-contrast theme built on Figuya's brand palette — newsprint cream
and inked cocoa, accented with Figuya Orange. Ports for editors, terminals, and
CLI tools, all generated from a single source of truth.

The accent hues are **never hand-tuned for contrast**. The generator re-derives
every colour's contrast against the background it actually sits on, to a WCAG
floor (accents ≥ 4.5:1, body text ≥ 7:1), holding the hue and moving only
lightness. "High contrast" is a property the theme *computes*, in both variants.

## Palette

| Role | Anchor | Light bg `#fff6e9` | Dark bg `#251d1b` |
|------|--------|--------------------|-------------------|
| primary (Figuya Orange) | `#f76707` | `#bf4f05` | `#f76707` |
| secondary (Convention Violet) | `#7950f2` | `#7950f2` | `#906ef4` |
| tertiary (Marker Magenta) | `#d6336c` | `#d03269` | `#dd5685` |
| info (Backorder Blue) | `#1c7ed6` | `#1a74c6` | `#3089da` |
| success (Stocked Green) | `#2f9e44` | `#278238` | `#2f9e44` |
| warning (Caution Amber) | `#f59f00` | `#9e6600` | `#f59f00` |
| error (Sale Error Red) | `#f03e3e` | `#d33636` | `#f14747` |
| text | — | `#2d2220` | `#f5ece0` |

*Anchor* is the brand identity; the per-variant columns are the floored values
the generator emits. Run `python3 generate.py --preview` to see a live swatch.

## Supported ports

Everything lands under [`dist/`](dist/), with a light and dark variant unless noted.

**Editors** — [Neovim](dist/nvim/) · [Helix](dist/helix/) · [VS Code](dist/vscode/)
**Terminals** — [Alacritty](dist/alacritty/) · [Kitty](dist/kitty/) · [WezTerm](dist/wezterm/) · [foot](dist/foot/) · [Ghostty](dist/ghostty/)
**CLI** — [bat](dist/bat/) · [delta](dist/delta/) · [fzf](dist/fzf/) · [tmux](dist/tmux/) · [zellij](dist/zellij/)

## Install

Pick your variant (`-dark` / `-light`) where it applies.

### Neovim
```sh
cp dist/nvim/colors/figuya.lua ~/.config/nvim/colors/
```
```lua
vim.o.background = "dark"   -- or "light"
vim.cmd.colorscheme("figuya")
```

### Helix
```sh
cp dist/helix/figuya-dark.toml ~/.config/helix/themes/figuya.toml
```
```toml
# ~/.config/helix/config.toml
theme = "figuya"
```

### VS Code
Copy `dist/vscode/` into `~/.vscode/extensions/figuya-1.0.0/`, reload, then pick
**Figuya Dark** / **Figuya Light** in the theme picker. (Or `vsce package` it.)

### Alacritty
```toml
# alacritty.toml
[general]
import = ["~/.config/alacritty/figuya-dark.toml"]
```

### Kitty
```conf
# kitty.conf
include figuya-dark.conf
```

### WezTerm
```lua
config.color_scheme_dirs = { "/path/to/figuya/dist/wezterm" }
config.color_scheme = "figuya-dark"   -- file basename
```

### foot
```ini
# foot.ini
include=~/.config/foot/figuya-dark.ini
```

### Ghostty
```
# ghostty config
theme = dark:figuya-dark,light:figuya-light
```
(Copy both files into `~/.config/ghostty/themes/`.)

### bat
```sh
mkdir -p "$(bat --config-dir)/themes"
cp dist/bat/figuya-dark.tmTheme "$(bat --config-dir)/themes/"
bat cache --build
export BAT_THEME="figuya-dark"
```

### delta
```sh
git config --global include.path /path/to/figuya/dist/delta/figuya.gitconfig
git config --global delta.features figuya-dark
```

### fzf
```sh
source dist/fzf/figuya-dark.sh   # appends to FZF_DEFAULT_OPTS
```

### tmux
```conf
# tmux.conf
source-file ~/.config/tmux/figuya-dark.conf
```

### zellij
```sh
cp dist/zellij/figuya.kdl ~/.config/zellij/themes/
```
```kdl
theme "figuya-dark"
```

## Regenerating / customizing

[`palette.toml`](palette.toml) is the only file you edit — brand hues, the WCAG
floors, and the light/dark structural tones. Then:

```sh
python3 generate.py            # rewrites dist/
python3 generate.py --preview  # + an ANSI swatch of both variants
```

`generate.py` has no dependencies beyond the Python 3.11+ standard library
(`tomllib`). Re-point a hue once and every port updates.

## Adding a port

Each port is a small `emit_*` function in `generate.py` that takes a resolved
palette dict (`p["primary"]`, `p["bg"]`, …, plus `p["ansi_*"]` for terminals)
and calls `write("<port>/<file>", body)`. Add one and register it in `main()`.

## License

[MIT](LICENSE).
