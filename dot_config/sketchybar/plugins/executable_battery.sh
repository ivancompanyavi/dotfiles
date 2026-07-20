#!/usr/bin/env bash

# Get battery info from pmset. pmset reports a true 0-100 percentage on every
# Mac; ioreg's CurrentCapacity is raw mAh on some models, so we use pmset as the
# single source for both the icon and the label.
battery_info=$(pmset -g batt | grep -E "InternalBattery")

# Extract percentage (remove % symbol)
percentage=$(echo "$battery_info" | grep -o '[0-9]\+%' | sed 's/%//')
percent="$percentage"

# Check if charging (look for 'AC Power' or 'charging')
if echo "$battery_info" | grep -q "discharging"; then
    charging=false
else
    charging=true
fi

get_icon() {
    local pct=$1
    local is_charging=$2
    
    if [[ "$is_charging" == true ]]; then
        # Charging icons
        if [[ $pct -ge 90 ]]; then
            echo "󰂅"  # nf-md-battery_charging_100
        elif [[ $pct -ge 80 ]]; then
            echo "󰂋"  # nf-md-battery_charging_90
        elif [[ $pct -ge 70 ]]; then
            echo "󰂊"  # nf-md-battery_charging_80
        elif [[ $pct -ge 60 ]]; then
            echo "󰢞"  # nf-md-battery_charging_70
        elif [[ $pct -ge 50 ]]; then
            echo "󰂉"  # nf-md-battery_charging_60
        elif [[ $pct -ge 40 ]]; then
            echo "󰢝"  # nf-md-battery_charging_50
        elif [[ $pct -ge 30 ]]; then
            echo "󰂈"  # nf-md-battery_charging_40
        elif [[ $pct -ge 20 ]]; then
            echo "󰂇"  # nf-md-battery_charging_30
        elif [[ $pct -ge 10 ]]; then
            echo "󰂆"  # nf-md-battery_charging_20
        else
            echo "󰢜"  # nf-md-battery_charging_10
        fi
    else
        # Discharging icons
        if [[ $pct -ge 90 ]]; then
            echo "󰁹"  # nf-md-battery_90
        elif [[ $pct -ge 80 ]]; then
            echo "󰂂"  # nf-md-battery_80
        elif [[ $pct -ge 70 ]]; then
            echo "󰂁"  # nf-md-battery_70
        elif [[ $pct -ge 60 ]]; then
            echo "󰂀"  # nf-md-battery_60
        elif [[ $pct -ge 50 ]]; then
            echo "󰁿"  # nf-md-battery_50
        elif [[ $pct -ge 40 ]]; then
            echo "󰁾"  # nf-md-battery_40
        elif [[ $pct -ge 30 ]]; then
            echo "󰁽"  # nf-md-battery_30
        elif [[ $pct -ge 20 ]]; then
            echo "󰁼"  # nf-md-battery_20
        elif [[ $pct -ge 10 ]]; then
            echo "󰁻"  # nf-md-battery_10
        else
            echo "󰂎"  # nf-md-battery_alert (critical)
        fi
    fi
}


sketchybar --set $NAME icon="$(get_icon $percentage $charging)" label="$percent"
