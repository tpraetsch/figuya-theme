#!/bin/sh
# figuya — fetch the hyprlock wallpapers (third-party art, not bundled).
# Pulls the two firewatch-style backgrounds the figuya lock layout expects.
#
#   sh fetch-wallpapers.sh [TARGET_DIR]
#
# Default TARGET_DIR: ${XDG_DATA_HOME:-$HOME/.local/share}/figuya/hypr
# Source images (© their authors; not covered by figuya's MIT licence):
#   dark  / moon-night   https://wallhaven.cc/w/mdjrqy
#   light / sunrise-day  https://wallhaven.cc/w/9mq26d
set -eu
DEST="${1:-${XDG_DATA_HOME:-$HOME/.local/share}/figuya/hypr}"
mkdir -p "$DEST"
fetch() {  # <wallhaven-id> <outfile>
    sub=$(printf %s "$1" | cut -c1-2)
    url="https://w.wallhaven.cc/full/$sub/wallhaven-$1.jpg"
    echo "  $2  <-  $url"
    curl -fsSL "$url" -o "$DEST/$2"
}
fetch mdjrqy wallpaper-dark.png
fetch 9mq26d wallpaper-light.png
echo "figuya: lock wallpapers in $DEST"
