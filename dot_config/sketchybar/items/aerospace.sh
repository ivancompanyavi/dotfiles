#!/usr/bin/env bash

source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/current.sh"

# Nerd Font (Hack Nerd Font) glyphs shown next to each workspace number,
# matching the app assignment in ~/.config/aerospace/aerospace.toml.
# UTF-8 byte sequences are used so this works on macOS's bash 3.2,
# where printf '\uXXXX' is not supported.
workspace_icon() {
  case "$1" in
    1) printf '\xef\x84\xa0' ;; # U+F120 terminal  (WezTerm)
    2) printf '\xef\x82\xac' ;; # U+F0AC globe     (Brave)
    3) printf '\xef\x84\xa1' ;; # U+F121 code      (Cursor)
    4) printf '\xef\x82\xae' ;; # U+F0AE tasks     (Asana)
    5) printf '\xef\x86\x98' ;; # U+F198 slack     (Slack)
    R) printf '\xef\x85\x81' ;; # U+F141 ellipsis  (misc)
    *) printf '\xef\x83\x88' ;; # U+F0C8 square    (fallback)
  esac
}

create_workspace_bracket_for_monitor() {
  parameters=("$@")
  monitor_id=${parameters[0]}
  monitor_workspaces=("${parameters[@]:1}")

  if [ $monitor_id -eq 1 ]; then
    sketchybar --add item workspaces_spacer_left left \
               --set      workspaces_spacer_left \
                          width=4 \
                          background.drawing=off \
                          label.drawing=off
  fi

  for workspace_id in ${monitor_workspaces[@]}; do
    icon_glyph=$(workspace_icon "$workspace_id")
    sketchybar --add item  workspaces."$monitor_id"."$workspace_id" left \
                          --subscribe workspaces."$monitor_id"."$workspace_id" aerospace_workspace_change \
                          --set       workspaces."$monitor_id"."$workspace_id" \
                                      background.drawing=off \
                                      click_script="aerospace workspace $workspace_id" \
                                      icon="$icon_glyph" \
                                      icon.color="$LABEL_COLOR" \
                                      icon.highlight_color="$LABEL_HIGHLIGHT_COLOR" \
                                      icon.padding_left=4 \
                                      icon.padding_right=2 \
                                      label="$workspace_id" \
                                      label.width="20" \
                                      script="$PLUGIN_DIR/aerospace.sh $workspace_id"
  done

  if [ $monitor_id -lt ${#monitor_ids[@]} ]; then
    sketchybar --add item workspaces_monitor_separator."$monitor_id" left \
               --set      workspaces_monitor_separator."$monitor_id" \
                          background.drawing=off \
                          label.padding_left=-6 \
                          label.font.size="$BACKGROUND_HEIGHT" \
                          label="|"
  else
    sketchybar --add item workspaces_service_mode left \
           --subscribe workspaces_service_mode aerospace_service_mode_enabled_changed \
           --set       workspaces_service_mode \
                       background.drawing=off \
                       label.drawing=off \
                       label.highlight=on \
                       label.font="$LABEL_HIGHLIGHT_FONT" \
                       label="[s]" \
                       label.padding_right=10 \
                       script="$PLUGIN_DIR/aerospace.sh $AEROSPACE_SERVICE_MODE_ENABLED"

    sketchybar --add item workspaces_spacer_right left \
               --set      workspaces_spacer_right \
                          width=4 \
                          background.drawing=off \
                          label.drawing=off
  fi

  sketchybar --add bracket workspaces."$monitor_id" /workspaces\.*/ \
             --set         workspaces."$monitor_id" \
                           background.padding_left="50" \
                           background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
                           background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"
}

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_service_mode_enabled_changed


monitor_ids=( $(aerospace list-monitors | awk '{print $1}') )

# TODO:
# - Update this view when moving workspaces to a different monitors.
# - Only show workspaces with active windows or currently selected like in i3
#   default configuration.
for monitor_id in ${monitor_ids[@]}; do
  workspaces_for_monitor_id=( $(aerospace list-workspaces --monitor $monitor_id) )
  create_workspace_bracket_for_monitor $monitor_id "${workspaces_for_monitor_id[@]}"
done

sketchybar --add item aerospace_spacer left \
           --set      aerospace_spacer \
                      width=$ITEM_SPACING \
                      background.drawing=off
