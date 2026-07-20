#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# sketchybar PALETTE — resolved from the ACTIVE theme (~/.config/theme). Provides
# ROLE_* colors (0xAARRGGBB) plus the semantic sketchybar variables the items
# and plugins consume. Theme-DEPENDENT: everything here changes on theme switch.
# Sourced via themes/current.sh.
#
# Fast path: read the cache written by `theme reapply`. If it's missing (e.g.
# first boot before any switch), resolve live once and populate it.
# ─────────────────────────────────────────────────────────────────────────────

THEME_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/theme"
THEME_CACHE="$THEME_STATE/sketchybar-palette.env"

if [ ! -s "$THEME_CACHE" ]; then
  mkdir -p "$THEME_STATE"
  bash "$HOME/.config/theme/lib/resolve.sh" roles-argb > "$THEME_CACHE" 2>/dev/null || true
fi
# shellcheck disable=SC1090
source "$THEME_CACHE" 2>/dev/null || true

# Hard fallbacks (tokyonight-storm) so the bar never renders with empty colors.
: "${ROLE_BG:=0xff1a1b26}"
: "${ROLE_SURFACE:=0xff24283b}"
: "${ROLE_FG:=0xffa9b1d6}"
: "${ROLE_MUTED:=0xff565f89}"
: "${ROLE_ACCENT:=0xff7aa2f7}"
: "${ROLE_ACCENT2:=0xffbb9af7}"
: "${ROLE_OK:=0xff9ece6a}"
: "${ROLE_WARN:=0xffe0af68}"
: "${ROLE_URGENT:=0xfff7768e}"
: "${ROLE_INFO:=0xff7dcfff}"

# Semantic sketchybar variables (map roles → what items/plugins reference)
BACKGROUND_COLOR="$ROLE_BG"
BACKGROUND_BORDER_COLOR="$ROLE_ACCENT"
LABEL_COLOR="$ROLE_ACCENT"
LABEL_HIGHLIGHT_COLOR="$ROLE_URGENT"
ICON_COLOR="$ROLE_ACCENT"
