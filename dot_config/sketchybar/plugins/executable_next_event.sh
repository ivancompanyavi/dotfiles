next_event() {
  raw=$(gcalcli --nocolor agenda --nostarted --nodeclined "now" "tomorrow" | head -n 2)

  if [ -z "$raw" ]; then
    echo "📅 No upcoming events"
    return
  fi


  clean=$(echo "$raw" | tr -s ' ')

  # Now parse it: date = fields 1-3, time = 4, title = 5+
  time=$(echo "$clean" | awk '{print $4}')
  title=$(echo "$clean" | cut -d' ' -f5-)

  echo "📅 $time - $title"
}

sketchybar --set $NAME label="$(next_event)"
