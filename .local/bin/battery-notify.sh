#!/bin/sh
# Battery notification script for systemd timer
# Alerts on low/critical battery states

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# Thresholds
WARNING_LEVEL=20
CRITICAL_LEVEL=10

# Get battery info using acpi
BATTERY_DISCHARGING=$(acpi -b | grep -c "Discharging")
BATTERY_LEVEL=$(acpi -b | grep -P -o '[0-9]+(?=%)')

# State files to prevent notification spam
WARNING_FILE=/tmp/battery-warning
CRITICAL_FILE=/tmp/battery-critical

# Clean up state files when charging starts
if [ "$BATTERY_DISCHARGING" -eq 0 ]; then
    # Charging - remove all low battery states
    rm -f "$WARNING_FILE" "$CRITICAL_FILE"
fi

# Check battery states and notify (only when discharging)
if [ "$BATTERY_DISCHARGING" -eq 1 ]; then
    if [ "$BATTERY_LEVEL" -le "$CRITICAL_LEVEL" ]; then
        # Critical: repeat notification every 5 minutes (or first time)
        if [ ! -f "$CRITICAL_FILE" ] || [ "$(find "$CRITICAL_FILE" -mmin +5 2>/dev/null)" ]; then
            notify-send "Battery Critical" \
                "Only ${BATTERY_LEVEL}% remaining." \
                -u critical -i "battery-caution" -r 9991
            touch "$CRITICAL_FILE"
        fi
        
    elif [ "$BATTERY_LEVEL" -le "$WARNING_LEVEL" ] && [ ! -f "$WARNING_FILE" ]; then
        # Warning: notify once per discharge cycle
        notify-send "Battery Low" \
            "${BATTERY_LEVEL}% of battery remaining." \
            -u normal -i "battery-low" -r 9991
        touch "$WARNING_FILE"
    fi
fi
