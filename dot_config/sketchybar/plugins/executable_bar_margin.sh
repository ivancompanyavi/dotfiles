#!/usr/bin/env bash

# Re-apply the bar's outer inset whenever the display configuration changes
# (dock/undock, wake). Mirrors AeroSpace's per-monitor gaps — the compute lives
# in themes/tokyonight.sh (bar_margin_for_displays).
source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/tokyonight.sh"

sketchybar --bar margin="$(bar_margin_for_displays)"
