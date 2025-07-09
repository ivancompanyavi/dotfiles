#!/usr/bin/env bash

source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/tokyonight.sh"

FRONT_APP_LABEL_COLOR="$blue"
FRONT_APP_BACKGROUND_BORDER_COLOR="$blue"

sketchybar --add item next_event_spacer_left left \
           --set      next_event_spacer_left \
                      background.drawing=off

sketchybar --add item  next_event left \
           --subscribe next_event next_event_switched \
           --set       next_event \
                       background.drawing=off \
                       label.color="$FRONT_APP_LABEL_COLOR" \
                       label.padding_left=0 \
                       update_freq=60 \
                       label.padding_right=0 \
                       script="$PLUGIN_DIR/next_event.sh"

sketchybar --add item next_event_spacer_right left \
           --set      next_event_spacer_right \
                      background.drawing=off

sketchybar --add bracket next_event_bracket next_event_spacer_left next_event next_event_spacer_right \
           --set         next_event_bracket \
                         background.border_color="$FRONT_APP_BACKGROUND_BORDER_COLOR" \
                         background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
                         background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"

