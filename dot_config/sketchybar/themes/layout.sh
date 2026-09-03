#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# sketchybar LAYOUT — geometry & typography only. Theme-INDEPENDENT: nothing in
# here changes when you switch themes. Colors live in palette.sh (resolved from
# the active theme). Sourced via themes/current.sh.
# ─────────────────────────────────────────────────────────────────────────────

# Bar. A solid band with a rule under it, like the status line at the bottom of
# a terminal. The colors live in palette.sh; only the geometry is here.
BAR_BLUR_RADIUS=0
BAR_BORDER_WIDTH=1
BAR_POSITION="top"
BAR_HEIGHT=40
# Inner padding between the bar's edge and its first/last item. The outer inset
# comes from BAR_MARGIN (below), so this stays small. Set to 8 to match
# WezTerm's default window padding, so the bar's items line up with the
# terminal's text column (the bar frame itself already matches the window).
BAR_PADDING=8
BAR_Y_OFFSET=0
BAR_CORNER_RADIUS=0
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

# Item defaults — geometry & typography.
# Everything is square with hairline borders so the bar reads like a status
# line drawn in a terminal, matching the browser styles and WezTerm.
LABEL_ALIGN="center"
ITEM_SPACING=10
BACKGROUND_BORDER_WIDTH=0
BACKGROUND_CORNER_RADIUS=0
BACKGROUND_HEIGHT=24
LABEL_Y_OFFSET=1
LABEL_PADDING=6
# The band itself separates the bar from the desktop, so the groups inside it
# are told apart by a separator rather than by a box each.
BRACKET_BACKGROUND_BORDER_WIDTH=0
BRACKET_BACKGROUND_CORNER_RADIUS=0
SEGMENT_SEPARATOR="│"

# Fonts. Labels use the terminal's own font; icons stay on a Nerd Font, which
# is where the glyphs live.
ICON_BASE_FONT="Hack Nerd Font"
ICON_FONT="$ICON_BASE_FONT:Bold:14.0"
LABEL_BASE_FONT="Fira Code"
LABEL_FONT="$LABEL_BASE_FONT:Regular:14.0"
LABEL_HIGHLIGHT_FONT="$LABEL_BASE_FONT:Bold:14.0"
