#!/usr/bin/env bash

# Theme colors (ROLE_*) from the active theme.
source "$CONFIG_DIR/environment.sh"
source "$THEME_DIR/palette.sh"

WIFI_INTERFACE="en0"

get_wifi_status() {
    # Check if we have an IP on the WiFi interface
    wifi_ip=$(ipconfig getifaddr "$WIFI_INTERFACE" 2>/dev/null)
    
    if [ -n "$wifi_ip" ]; then
        # We have an IP, check if it's WiFi (has SSID)
        ssid=$(ipconfig getsummary "$WIFI_INTERFACE" 2>/dev/null | grep "SSID" | grep -v "BSSID" | awk -F' : ' '{print $2}')
        
        if [ -n "$ssid" ]; then
            # Connected to WiFi
            ICON="󰤨"  # WiFi connected
            ICON_COLOR="$ROLE_OK"
        else
            # Connected but no SSID (might be ethernet adapter)
            ICON="󰤯"  # WiFi uncertain
            ICON_COLOR="$ROLE_WARN"
        fi
    else
        # No IP on WiFi interface
        wifi_power=$(networksetup -getairportpower "$WIFI_INTERFACE" 2>/dev/null)
        if echo "$wifi_power" | grep -q "Off"; then
            ICON="󰤭"  # WiFi off
            ICON_COLOR="$ROLE_MUTED"
        else
            ICON="󰤯"  # WiFi on but not connected
            ICON_COLOR="$ROLE_WARN"
        fi
    fi
    
    sketchybar --set $NAME icon="$ICON" icon.color="$ICON_COLOR"
}

get_wifi_status
