#!/usr/bin/env bash

source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/current.sh"

FRONT_APP_LABEL_COLOR="$ROLE_ACCENT"
FRONT_APP_BACKGROUND_BORDER_COLOR="$ROLE_ACCENT"

sketchybar --add item front_app_spacer_left right \
           --set      front_app_spacer_left \
                      background.drawing=off

sketchybar --add item  front_app right \
           --subscribe front_app front_app_switched \
           --set       front_app \
                       background.drawing=off \
                       label.color="$FRONT_APP_LABEL_COLOR" \
                       label.padding_left=0 \
                       label.padding_right=0 \
                       script="$PLUGIN_DIR/front_app.sh"

sketchybar --add item front_app_spacer_right right \
           --set      front_app_spacer_right \
                      background.drawing=off

sketchybar --add bracket front_app_bracket front_app_spacer_left front_app front_app_spacer_right \
           --set         front_app_bracket \
                         background.border_color="$FRONT_APP_BACKGROUND_BORDER_COLOR" \
                         background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
                         background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"
