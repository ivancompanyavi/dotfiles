#!/usr/bin/env bash

# Actionable "next meeting" widget:
#  - shows the current or next timed event (skips all-day events)
#  - reddens when the meeting is <=5 min away (or already live)
#  - click opens the Meet/Zoom/calendar link
#
# TSV columns (with --details url --details conference):
#  1 start_date  2 start_time  3 end_date  4 end_time
#  5 html_link   6 hangout_link 7 conf_entry_type 8 conf_uri  9 title

source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/current.sh"

CAL="ivan.company@stackadapt.com"

# First timed event (start_time non-empty) from now over the next 24h.
# --nodeclined drops events we said no to; we intentionally keep in-progress
# meetings so we can still offer a join link for one that just started.
row=$(gcalcli --nocolor agenda --calendar "$CAL" --nodeclined \
        --tsv --details url --details conference "now" "now+24hours" 2>/dev/null \
      | awk -F'\t' 'NR>1 && $2!="" {print; exit}')

if [ -z "$row" ]; then
  sketchybar --set "$NAME" label="📅 No upcoming events" label.color="$LABEL_COLOR" click_script=""
  exit 0
fi

# NOTE: parse with `cut`, not `read -r`. `read` treats tab as IFS whitespace and
# collapses runs of it, so any empty column (no Meet/conference link) would shift
# every later field left. `cut -f` (tab-delimited by default) preserves empties.
s_date=$(printf '%s' "$row" | cut -f1)
s_time=$(printf '%s' "$row" | cut -f2)
html_link=$(printf '%s' "$row" | cut -f5)
hangout_link=$(printf '%s' "$row" | cut -f6)
conf_uri=$(printf '%s' "$row" | cut -f8)
title=$(printf '%s' "$row" | cut -f9-)

# Prefer a real conference link; fall back to the calendar page.
if [ -n "$hangout_link" ]; then
  join="$hangout_link"
elif [ -n "$conf_uri" ]; then
  join="$conf_uri"
else
  join="$html_link"
fi

# Minutes until the meeting starts (negative = already in progress).
now_epoch=$(date +%s)
start_epoch=$(date -j -f "%Y-%m-%d %H:%M" "$s_date $s_time" +%s 2>/dev/null)
if [ -n "$start_epoch" ]; then
  mins=$(( (start_epoch - now_epoch) / 60 ))
else
  mins=999
fi

# Trim long titles.
max=28
[ ${#title} -gt $max ] && title="${title:0:$max}…"

if [ "$mins" -lt 0 ]; then
  when="live"
elif [ "$mins" -le 90 ]; then
  when="in ${mins}m"
else
  when="$s_time"
fi

# Imminent (<=5 min out, or live) -> red to grab attention.
if [ "$mins" -le 5 ]; then
  color="$ROLE_URGENT"
else
  color="$LABEL_COLOR"
fi

sketchybar --set "$NAME" \
  label="📅 $title · $when" \
  label.color="$color" \
  click_script="open '$join'"
