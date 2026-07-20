#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# sketchybar THEME entrypoint. Sources layout (geometry, theme-independent) then
# the palette (colors, resolved from the active theme). Everything that used to
# `source "$THEME_DIR/tokyonight.sh"` now sources this instead.
# ─────────────────────────────────────────────────────────────────────────────
source "$THEME_DIR/layout.sh"
source "$THEME_DIR/palette.sh"
