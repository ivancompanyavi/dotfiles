#!/usr/bin/env bash

# Total CPU load (user + sys) from top's summary line. We take two samples
# (-l 2) because the first is a since-boot average; the second reflects the
# current instant.
read -r user sys <<<"$(top -l 2 -n 0 \
  | grep -E '^CPU usage' \
  | tail -1 \
  | awk '{ gsub(/%/,"",$3); gsub(/%/,"",$5); print $3, $5 }')"

cpu=$(printf '%.0f' "$(echo "$user + $sys" | bc -l 2>/dev/null || echo 0)")

sketchybar --set "$NAME" label="${cpu}%"
