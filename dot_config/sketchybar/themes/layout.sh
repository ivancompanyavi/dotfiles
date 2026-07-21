#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# sketchybar LAYOUT — geometry & typography only. Theme-INDEPENDENT: nothing in
# here changes when you switch themes. Colors live in palette.sh (resolved from
# the active theme). Sourced via themes/current.sh.
# ─────────────────────────────────────────────────────────────────────────────

# Bar
BAR_COLOR="0x00000000"          # fully transparent bar background
BAR_BORDER_COLOR="0x00000000"   # no visible bar border (width stays 0)
BAR_BLUR_RADIUS=0               # no frosted blur band — empty areas show the wallpaper
BAR_POSITION="top"
BAR_HEIGHT=40
# Inner padding between the bar's edge and its first/last item. The outer inset
# comes from BAR_MARGIN (below), so this stays small.
BAR_PADDING=10
BAR_Y_OFFSET=5
BAR_CORNER_RADIUS=12
Y_OFFSET=0

# Outer inset, mirroring AeroSpace's per-monitor outer gaps
# (~/.config/aerospace/aerospace.toml [gaps]): the built-in laptop panel stays
# compact, an external monitor (e.g. the Odyssey) gets the wide inset so the
# bar lines up with the window column. sketchybar's margin is a single global
# value, so we pick it from the connected displays and re-apply on
# display_change/system_woke (items/bar_margin.sh + plugins/bar_margin.sh).
BAR_MARGIN_BUILTIN=10
BAR_MARGIN_EXTERNAL=120
bar_margin_for_displays() {
  local externals
  externals=$(aerospace list-monitors 2>/dev/null | grep -civ 'built-in')
  if [ "${externals:-0}" -gt 0 ]; then printf '%s' "$BAR_MARGIN_EXTERNAL"; else printf '%s' "$BAR_MARGIN_BUILTIN"; fi
}
BAR_MARGIN="$(bar_margin_for_displays)"

# Item defaults — geometry & typography
LABEL_ALIGN="center"
ITEM_SPACING=10
BACKGROUND_BORDER_WIDTH=0
BACKGROUND_CORNER_RADIUS=4
BACKGROUND_HEIGHT=24
LABEL_Y_OFFSET=1
LABEL_PADDING=6
BRACKET_BACKGROUND_BORDER_WIDTH=2
BRACKET_BACKGROUND_CORNER_RADIUS=12

# Fonts
ICON_BASE_FONT="Hack Nerd Font"
ICON_FONT="$ICON_BASE_FONT:Bold:14.0"
LABEL_BASE_FONT="Hack Nerd Font"
LABEL_FONT="$LABEL_BASE_FONT:Regular:14.0"
LABEL_HIGHLIGHT_FONT="$LABEL_BASE_FONT:ExtraBold:14.0"
