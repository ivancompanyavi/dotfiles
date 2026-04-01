next_event() {
  raw=$(gcalcli --nocolor agenda --calendar "ivan.company@stackadapt.com" --nostarted --nodeclined --details end "now" | head -n 2)

  if [ -z "$raw" ]; then
    echo "📅 No upcoming events"
    return
  fi


  clean=$(echo "$raw" | tr -s ' ')

  # Now parse it: date = fields 1-3, start_time = 4, dash = 5, end_time = 6, title = 7+
  start_time=$(echo "$clean" | awk '{print $4}')
  end_time=$(echo "$clean" | awk '{print $6}')
  title=$(echo "$clean" | cut -d' ' -f7-)

  echo "📅 $start_time - $end_time - $title"
}

sketchybar --set $NAME label="$(next_event)"
