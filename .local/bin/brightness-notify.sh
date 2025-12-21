#!/bin/bash
brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)
percentage=$((brightness * 100 / max_brightness))

notify-send -a "Brightness" -u low -h string:x-canonical-private-synchronous:brightness -h int:value:$percentage "Brightness: ${percentage}%"
