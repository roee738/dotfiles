#!/bin/bash

choices="󰐥  Shutdown\n󰜉  Reboot\n󰌾  Lock\n󰍃  Logout\n󰜗  Hibernate"

chosen=$(echo -e "$choices" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
    "󰐥  Shutdown") systemctl poweroff ;;
    "󰜉  Reboot") systemctl reboot ;;
    "󰌾  Lock") hyprlock ;;
    "󰍃  Logout") hyprctl dispatch exit ;;
    "󰜗  Hibernate") systemctl hibernate ;;
esac
