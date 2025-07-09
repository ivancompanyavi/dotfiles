#!/usr/bin/env bash
percent=$(ioreg -rc AppleSmartBattery | awk '/"CurrentCapacity"/ { print $3 }')


get_icon() {
    percent=$1

  if [ $percent -ge 95 ]; then
    icon=""  # Full
  elif [ $percent -ge 70 ]; then
    icon=""  # 3/4
  elif [ $percent -ge 45 ]; then
    icon=""  # Half
  elif [ $percent -ge 20 ]; then
    icon=""  # 1/4
  else
    icon=""  # Empty
  fi

  echo "$icon"
}


sketchybar --set $NAME icon="$(get_icon $percent)" label="$percent"
