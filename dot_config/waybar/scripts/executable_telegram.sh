#!/usr/bin/env bash
# Telegram widget, the Linux counterpart of sketchybar's telegram plugin (which
# reads the Dock badge). Telegram Desktop puts the unread count in its window
# title, "Telegram (3)", so read that from Hyprland.
#   not running → accent dot · no unread (or tray only) → ok · unread → urgent + count
title="$(hyprctl clients -j 2>/dev/null \
  | jq -r '.[] | select(.class == "org.telegram.desktop") | .title' | head -1)"

icon=$'\uf2c6'  # Font Awesome paper plane (Hack Nerd Font)

if [ -z "$title" ] && pgrep -x Telegram >/dev/null; then
  # Closed to the tray: no window, so no title to read a count from.
  printf '{"text": "%s", "class": "read", "tooltip": "Telegram is in the tray"}\n' "$icon"
elif [ -z "$title" ]; then
  printf '{"text": "%s •", "class": "closed", "tooltip": "Telegram is not running"}\n' "$icon"
elif [[ $title =~ \(([0-9]+)\) ]]; then
  n="${BASH_REMATCH[1]}"
  printf '{"text": "%s %s", "class": "unread", "tooltip": "%s unread"}\n' "$icon" "$n" "$n"
else
  printf '{"text": "%s", "class": "read", "tooltip": "No unread messages"}\n' "$icon"
fi
