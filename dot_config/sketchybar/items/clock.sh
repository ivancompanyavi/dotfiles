#!/usr/bin/env bash

source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/current.sh"

sketchybar --add item clock_spacer_right right \
           --set      clock_spacer_right \
                      background.drawing=off

sketchybar --add item clock right \
           --set      clock \
                      background.drawing=off \
                      label.color="$LABEL_COLOR" \
                      label.padding_left=0 \
                      label.padding_right=0 \
                      update_freq=30 \
                      script="$PLUGIN_DIR/clock.sh"

sketchybar --add item clock_spacer_left right \
           --set      clock_spacer_left \
                      background.drawing=off

sketchybar --add bracket clock_bracket clock_spacer_left clock clock_spacer_right \
           --set         clock_bracket \
                         background.border_color="$BRACKET_BORDER_COLOR" \
                         background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
                         background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"

sketchybar --add item clock_spacer right \
           --set      clock_spacer \
                      background.drawing=off \
                      label="$SEGMENT_SEPARATOR" \
                      label.color="$SEPARATOR_COLOR" \
                      label.padding_left=$ITEM_SPACING \
                      label.padding_right=$ITEM_SPACING
