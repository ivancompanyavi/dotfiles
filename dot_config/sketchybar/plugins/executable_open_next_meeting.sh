#!/usr/bin/env bash

# Resolve the current/next timed meeting's join link and open it.
#
# Shared by two callers, so the link resolution lives in exactly one place:
#  - the next_event sketchybar widget's click_script
#  - the AeroSpace `alt-m` keybinding (open the meeting without clicking)
#
# The link is recomputed fresh on every invocation (not read from whatever the
# widget last rendered), so the shortcut is correct even if the bar is stale.

# gcalcli lives in Homebrew; AeroSpace's exec-and-forget may run with a minimal
# PATH, so make sure it's reachable.
export PATH="/opt/homebrew/bin:$PATH"

CAL="ivan.company@stackadapt.com"

# First timed event (start_time non-empty) from now over the next 24h.
# See next_event.sh for the column layout and the --nodeclined rationale.
row=$(gcalcli --nocolor agenda --calendar "$CAL" --nodeclined \
        --tsv --details url --details conference "now" "now+24hours" 2>/dev/null \
      | awk -F'\t' 'NR>1 && $2!="" {print; exit}')

[ -z "$row" ] && exit 0

# Parse with `cut` (tab-delimited), not `read`, to preserve empty columns.
html_link=$(printf '%s' "$row" | cut -f5)
hangout_link=$(printf '%s' "$row" | cut -f6)
conf_uri=$(printf '%s' "$row" | cut -f8)

# Prefer a real conference link; fall back to the calendar page.
if [ -n "$hangout_link" ]; then
  join="$hangout_link"
elif [ -n "$conf_uri" ]; then
  join="$conf_uri"
else
  join="$html_link"
fi

[ -n "$join" ] && open "$join"
