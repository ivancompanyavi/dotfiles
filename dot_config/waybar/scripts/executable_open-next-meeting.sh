#!/usr/bin/env bash
# Open the current/next meeting's join link. Shared by the next-event widget's
# click and Hyprland's SUPER+M, and recomputed on every call so the shortcut is
# right even when the bar is stale. Ported from sketchybar's open_next_meeting.
row="$(timeout 30 gcalcli --nocolor agenda --nodeclined \
        --tsv --details url --details conference "now" "now+24hours" </dev/null 2>/dev/null \
      | awk -F'\t' 'NR>1 && $2!="" {print; exit}')"
[ -z "$row" ] && exit 0

html_link="$(printf '%s' "$row" | cut -f5)"
hangout_link="$(printf '%s' "$row" | cut -f6)"
conf_uri="$(printf '%s' "$row" | cut -f8)"

# Prefer a real conference link; fall back to the calendar page.
join="${hangout_link:-${conf_uri:-$html_link}}"
[ -n "$join" ] && xdg-open "$join"
