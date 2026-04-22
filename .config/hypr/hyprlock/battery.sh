#!/usr/bin/env bash

# Check if battery exists
if [ ! -d /sys/class/power_supply/BAT1 ]; then
    exit 0
fi

battery_percentage=$(cat /sys/class/power_supply/BAT1/capacity)
battery_status=$(cat /sys/class/power_supply/BAT1/status)

# Nerd Font battery icons (10% increments)
battery_icons=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")
charging_icon="󰂄"

icon_index=$((battery_percentage / 10))
[ $icon_index -gt 9 ] && icon_index=9
battery_icon=${battery_icons[$icon_index]}

if [ "$battery_status" = "Charging" ] || [ "$battery_status" = "Full" ]; then
    battery_icon="$charging_icon"
fi

echo "$battery_percentage% $battery_icon"
