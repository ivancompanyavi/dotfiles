#!/usr/bin/env bash

source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/current.sh"


sketchybar --add item cpu right \
           --set      cpu \
                      background.drawing=off \
                      icon="" \
                      icon.color="$ROLE_ACCENT2" \
                      icon.padding_right=4 \
                      label.color="$LABEL_COLOR" \
                      label.padding_left=0 \
                      background.padding_left=5 \
                      update_freq=15 \
                      script="$PLUGIN_DIR/cpu.sh"

sketchybar --add item battery right \
           --set      battery \
                      background.drawing=off \
                      label.color="$LABEL_COLOR" \
                      label.padding_left=5 \
                      background.padding_left=5  \
                      background.padding_right=5  \
                      update_freq=30 \
                      script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke

sketchybar --add item wifi right \
           --set      wifi \
                      background.drawing=off \
                      icon.font.size=16 \
                      background.padding_left=5 \
                      update_freq=30 \
                      click_script="open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi'" \
                      script="$PLUGIN_DIR/wifi.sh" \
           --subscribe wifi system_woke wifi_change

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


sketchybar --add bracket tools_bracket  cpu battery wifi telegram slack  \
           --set         tools_bracket \
                         background.border_color="$FRONT_APP_BACKGROUND_BORDER_COLOR" \
                         background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
                         background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"   \

sketchybar --add item tools_spacer right \
           --set      tools_spacer \
                      width=$ITEM_SPACING \
                      background.drawing=off
