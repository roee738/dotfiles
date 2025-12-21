#!/bin/bash

choices="󰌾  Lock\n󰍃  Logout\n󰜉  Reboot\n󰐥  Shutdown"

chosen=$(echo -e "$choices" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
    "󰌾  Lock") hyprlock ;;
    "󰍃  Logout") hyprctl dispatch exit ;;
    "󰜉  Reboot") systemctl reboot ;;
    "󰐥  Shutdown") systemctl poweroff ;;
esac
