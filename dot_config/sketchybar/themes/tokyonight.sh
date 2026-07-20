#!/usr/bin/env bash

# Tokyonight Night Palette
black="0xff24283b"
blue="0xff7aa2f7"
blue1="0xff1a1b26"
cyan="0xff7dcfff"
green="0xff9ece6a"
magenta="0xffbb9af7"
orange="0xffff9e64"
purple="0xff9d7cd8"
red="0xfff7768e"
transparent="0x00000000"
white="0xffa9b1d6"
yellow="0xffe0af68"

# Bar
## Colors
BAR_COLOR="$transparent"
BAR_BLUR_RADIUS=30

## Geometry
BAR_POSITION="top"
BAR_HEIGHT=40
# Inner padding between the bar's edge and its first/last item. The outer inset
# now comes from BAR_MARGIN (below), so this only needs to be small.
BAR_PADDING=10
BAR_Y_OFFSET=5
BAR_CORNER_RADIUS=12
# Outer inset between the bar and the screen edge, mirroring AeroSpace's
# per-monitor outer gaps (~/.config/aerospace/aerospace.toml [gaps]): the
# built-in laptop panel stays compact, an external monitor (e.g. the Odyssey)
# gets the wide inset so the bar's blur band and item pills line up with the
# window column. sketchybar's bar margin is a single global value, so we pick it
# from the currently-connected displays at load and re-apply on display changes
# (see items/bar_margin.sh + plugins/bar_margin.sh).
BAR_MARGIN_BUILTIN=10
BAR_MARGIN_EXTERNAL=120

bar_margin_for_displays() {
  # Any connected monitor whose name isn't the built-in Retina panel counts as
  # "external" → use the wide inset. Falls back to the compact inset if
  # AeroSpace can't be reached (e.g. the bar loads before the WM is up).
  local externals
  externals=$(aerospace list-monitors 2>/dev/null | grep -civ 'built-in')
  if [ "${externals:-0}" -gt 0 ]; then
    printf '%s' "$BAR_MARGIN_EXTERNAL"
  else
    printf '%s' "$BAR_MARGIN_BUILTIN"
  fi
}

BAR_MARGIN="$(bar_margin_for_displays)"

# Item Defaults
## Colors
BACKGROUND_COLOR="$blue1"
BACKGROUND_BORDER_COLOR="$blue"
BACKGROUND_BORDER_WIDTH=0
LABEL_ALIGN="center"
LABEL_COLOR="$blue"
LABEL_HIGHLIGHT_COLOR="$red"
ITEM_SPACING=10

## Fonts
ICON_BASE_FONT="Hack Nerd Font"
ICON_FONT="$ICON_BASE_FONT:Bold:14.0"
LABEL_BASE_FONT="Hack Nerd Font"
LABEL_FONT="$LABEL_BASE_FONT:Regular:14.0"
LABEL_HIGHLIGHT_FONT="$LABEL_BASE_FONT:ExtraBold:14.0"

## Geometry
BACKGROUND_CORNER_RADIUS=4
BACKGROUND_HEIGHT=24
LABEL_Y_OFFSET=1
LABEL_PADDING=6
BRACKET_BACKGROUND_BORDER_WIDTH=2
BRACKET_BACKGROUND_CORNER_RADIUS=12
