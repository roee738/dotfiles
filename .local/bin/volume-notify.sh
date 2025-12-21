#!/bin/bash

# Get the default sink (audio output)
sink=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# Extract volume percentage and mute status
volume=$(echo $sink | awk '{print int($2 * 100)}')
muted=$(echo $sink | grep -o "MUTED")

if [ -n "$muted" ]; then
    notify-send -a "Volume" -u low -h string:x-canonical-private-synchronous:volume "Volume: Muted"
else
    notify-send -a "Volume" -u low -h string:x-canonical-private-synchronous:volume -h int:value:$volume "Volume: ${volume}%"
fi
