#!/bin/sh
# figuya — install the generated theme onto this machine.
#
# Regenerates dist/ from palette.toml, then places files where a darkman-style
# light/dark switcher and the apps expect them:
#
#   ~/.local/share/figuya/        per-mode files the darkman hooks symlink FROM
#   ~/.config/...                 files apps load directly (foot/ghostty/nvim/…)
#   ~/.local/share/themes/figuya  named GTK3 theme (nwg-look / gtk-theme-name)
#
# Idempotent — safe to re-run. This is exactly what the chezmoi run_onchange
# script invokes on `chezmoi apply` (approach A: regenerate locally).
#
#   sh install.sh            regenerate + install
#   sh install.sh --no-gen   install current dist/ without regenerating
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DIST="$HERE/dist"
SHARE="${XDG_DATA_HOME:-$HOME/.local/share}/figuya"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
THEMES="${XDG_DATA_HOME:-$HOME/.local/share}/themes"

if [ "${1:-}" != "--no-gen" ]; then
    python3 "$HERE/generate.py" >/dev/null
fi

# 1. Per-mode rice files → stable share dir (darkman hooks symlink to these).
for sub in waybar gtk mako hypr fuzzel; do
    mkdir -p "$SHARE/$sub"
    cp -f "$DIST/$sub/"*figuya* "$SHARE/$sub/" 2>/dev/null || true
done

# 2. Files apps read directly (no per-mode symlink needed).
mkdir -p "$CFG/nvim/colors" "$CFG/fish/conf.d" "$CFG/foot" \
         "$CFG/ghostty/themes" "$CFG/bat/themes"
cp -f "$DIST/nvim/colors/figuya.lua"   "$CFG/nvim/colors/figuya.lua"
cp -f "$DIST/fish/figuya-theme.fish"   "$CFG/fish/conf.d/figuya-theme.fish"
cp -f "$DIST/foot/figuya.ini"          "$CFG/foot/colors-figuya.ini"
cp -f "$DIST/ghostty/figuya-dark"      "$CFG/ghostty/themes/figuya-dark"
cp -f "$DIST/ghostty/figuya-light"     "$CFG/ghostty/themes/figuya-light"
cp -f "$DIST/bat/figuya-dark.tmTheme"  "$CFG/bat/themes/figuya-dark.tmTheme"
cp -f "$DIST/bat/figuya-light.tmTheme" "$CFG/bat/themes/figuya-light.tmTheme"

# 2b. hyprlock: full lock-screen layout (variant-agnostic — it sources the
# swapped colours + wallpaper). Unlike the colour fragments this IS the primary
# hyprlock.conf, so back up an existing hand-written one once before replacing.
mkdir -p "$CFG/hypr"
if [ -e "$CFG/hypr/hyprlock.conf" ] && [ ! -e "$CFG/hypr/hyprlock.conf.pre-figuya" ] \
   && ! grep -q "figuya — generated" "$CFG/hypr/hyprlock.conf" 2>/dev/null; then
    cp "$CFG/hypr/hyprlock.conf" "$CFG/hypr/hyprlock.conf.pre-figuya"
fi
cp -f "$DIST/hypr/hyprlock.conf" "$CFG/hypr/hyprlock.conf"
# Lock wallpapers are third-party art (not bundled): fetch into the share dir,
# where the darkman hooks symlink wallpaper.png → wallpaper-<mode>.png. Needs
# network; best-effort so an offline install still places everything else.
sh "$DIST/hypr/fetch-wallpapers.sh" "$SHARE/hypr" \
    || echo "  warn: wallpaper fetch failed (offline?) — rerun dist/hypr/fetch-wallpapers.sh later"

# 3. Named GTK3 theme.
mkdir -p "$THEMES/figuya/gtk-3.0"
cp -fr "$DIST/gtk/themes/figuya/." "$THEMES/figuya/"

# 4. Rebuild bat's theme cache so figuya-{light,dark} are selectable.
if command -v bat >/dev/null 2>&1; then
    bat cache --build >/dev/null 2>&1 || true
fi

echo "figuya installed:"
echo "  share:  $SHARE"
echo "  themes: $THEMES/figuya"
echo "  direct: nvim/colors, fish/conf.d, foot/colors-figuya.ini, ghostty/themes, bat/themes"
echo "  hypr:   hyprlock.conf installed; wallpapers in $SHARE/hypr (wire the darkman swap — see README)"
