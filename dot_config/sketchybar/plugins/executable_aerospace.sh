#!/usr/bin/env bash

if [ "$SENDER" = "aerospace_service_mode_enabled_changed" ]; then
  if [ "$AEROSPACE_SERVICE_MODE_ENABLED" = true ]; then
    sketchybar --set workspaces_service_mode \
                     label.drawing=on
  else
    sketchybar --set workspaces_service_mode \
                     label.drawing=off
  fi
fi

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  workspace_id="$1"

  # i3-style visibility: only draw a workspace if it has windows or is focused.
  # `list-workspaces --empty no` returns the non-empty ones across all monitors;
  # grep -qx matches a whole line so "1" doesn't match "R1", etc.
  if [ "$workspace_id" = "$FOCUSED_WORKSPACE" ] \
     || aerospace list-workspaces --monitor all --empty no | grep -qx "$workspace_id"; then
    drawing=on
  else
    drawing=off
  fi

  if [ "$workspace_id" = "$FOCUSED_WORKSPACE" ]; then
    highlight=on
  else
    highlight=off
  fi

  sketchybar --set "$NAME" \
                   drawing="$drawing" \
                   label.highlight="$highlight" \
                   icon.highlight="$highlight"
fi
