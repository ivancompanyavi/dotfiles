#!/usr/bin/env bash

source "$CONFIG_DIR/environment.sh"

# Invisible driver item: keeps the bar's outer inset in sync with the connected
# displays. Fires plugins/bar_margin.sh on display changes and on wake so
# docking/undocking updates the inset the same way AeroSpace updates window gaps.
sketchybar --add item      bar_margin_watcher left \
           --set           bar_margin_watcher drawing=off \
                           script="$PLUGIN_DIR/bar_margin.sh" \
           --subscribe     bar_margin_watcher display_change system_woke
