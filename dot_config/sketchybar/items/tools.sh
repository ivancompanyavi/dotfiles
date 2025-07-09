#!/usr/bin/env bash

source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/tokyonight.sh"


sketchybar --add item battery right \
           --set      battery \
                      background.drawing=off \
                      label.color="$LABEL_COLOR" \
                      label.padding_left=5 \
                      background.padding_left=5  \
                      background.padding_right=5  \
                      update_freq=60 \
                      script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke

sketchybar  --add   item telegram right \
            --set   telegram \
                    update_freq=30 \
                    background.drawing=off \
                    script="$PLUGIN_DIR/telegram.sh" \
                    background.padding_left=5  \
                    icon.font.size=18 \
           --subscribe telegram system_woke

sketchybar  --add   item slack right \
            --set   slack \
                    update_freq=30 \
                    script="$PLUGIN_DIR/slack.sh" \
                    background.drawing=off \
                    background.padding_left=15  \
                    icon.font.size=18 \
           --subscribe slack system_woke


sketchybar --add bracket tools_bracket  battery telegram slack  \
           --set         tools_bracket \
                         background.border_color="$FRONT_APP_BACKGROUND_BORDER_COLOR" \
                         background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
                         background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"   \

sketchybar --add item tools_spacer right \
           --set      tools_spacer \
                      width=20 \
                      background.drawing=off
