#!/usr/bin/env bash
# "Next meeting" widget, ported from sketchybar's next_event plugin:
#  - shows the current or next timed event in the next 24h (skips all-day events)
#  - class "imminent" when it is <=5 min away or already live
#  - prints nothing (so waybar hides it) until gcalcli is authenticated
#
# TSV columns (with --details url --details conference):
#  1 start_date  2 start_time  3 end_date  4 end_time
#  5 html_link   6 hangout_link 7 conf_entry_type 8 conf_uri  9 title
# gcalcli prompts for OAuth setup on stdin when it has no token, which would
# hang the bar, so stay silent until `gcalcli init` has been run.
command -v gcalcli >/dev/null 2>&1 || exit 0
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/gcalcli/oauth" ] || [ -f "$HOME/.gcalcli_oauth" ] || exit 0
gcal() { timeout 30 gcalcli --nocolor "$@" </dev/null 2>/dev/null; }

# --nodeclined drops events we said no to; in-progress meetings are kept so a
# meeting that just started still shows (and can be joined).
row="$(gcal agenda --nodeclined \
        --tsv --details url --details conference "now" "now+24hours" \
      | awk -F'\t' 'NR>1 && $2!="" {print; exit}')"

if [ -z "$row" ]; then
  # gcalcli answered but there is nothing in the next day.
  gcal list >/dev/null || exit 0
  printf '{"text": "📅 No upcoming events", "class": "none"}\n'
  exit 0
fi

# Parse with `cut`, not `read`: read collapses runs of tabs, so an empty column
# (no conference link) would shift every later field.
s_date="$(printf '%s' "$row" | cut -f1)"
s_time="$(printf '%s' "$row" | cut -f2)"
e_date="$(printf '%s' "$row" | cut -f3)"
e_time="$(printf '%s' "$row" | cut -f4)"
title="$(printf '%s' "$row" | cut -f9-)"

now="$(date +%s)"
start="$(date -d "$s_date $s_time" +%s 2>/dev/null)"
mins=$(( start ? (start - now) / 60 : 999 ))

max=28
[ ${#title} -gt $max ] && title="${title:0:$max}…"

if [ "$mins" -lt 0 ]; then
  end="$(date -d "$e_date $e_time" +%s 2>/dev/null)"
  left=$(( end ? (end - now) / 60 : 0 ))
  if [ "$left" -gt 0 ]; then when="live · ends $e_time (${left}m)"; else when="live · ending now"; fi
elif [ "$mins" -le 90 ]; then
  when="in ${mins}m"
else
  when="$s_time"
fi

class="upcoming"
[ "$mins" -le 5 ] && class="imminent"

jq -cn --arg text "📅 $title · $when" --arg class "$class" '{text: $text, class: $class}'
