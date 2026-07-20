#!/usr/bin/env bash

source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/current.sh"

SPRINT_LABEL_COLOR="$ROLE_OK"
SPRINT_BACKGROUND_BORDER_COLOR="$ROLE_OK"

sketchybar --add item sprint_spacer_right right \
           --set      sprint_spacer_right \
                      background.drawing=off

sketchybar --add item  sprint right \
           --set       sprint \
                       background.drawing=off \
                       label.color="$SPRINT_LABEL_COLOR" \
                       label.padding_left=0 \
                       label.padding_right=0 \
                       update_freq=300 \
                       label="📊 Loading..." \
                       click_script="open 'https://stackadapt.atlassian.net/jira/software/c/projects/CRAI/boards/1228'" \
                       script="$PLUGIN_DIR/sprint.sh"

sketchybar --add item sprint_spacer_left right \
           --set      sprint_spacer_left \
                      background.drawing=off

sketchybar --add bracket sprint_bracket sprint_spacer_right sprint sprint_spacer_left \
           --set         sprint_bracket \
                         background.border_color="$SPRINT_BACKGROUND_BORDER_COLOR" \
                         background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
                         background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"

sketchybar --add item sprint_spacer right \
           --set      sprint_spacer \
                      width=$ITEM_SPACING \
                      background.drawing=off
