#!/bin/bash

FAN_FILE="/sys/devices/platform/asus-nb-wmi/fan_boost_mode"

CURRENT=$(cat "$FAN_FILE")

case "$CURRENT" in
    0)
        NEXT=1
        LABEL="🚀 Overboost"
        ;;
    1)
        NEXT=2
        LABEL="🤫 Silent"
        ;;
    2)
        NEXT=0
        LABEL="⚖️ Balanced"
        ;;
    *)
        NEXT=0
        LABEL="⚖️ Balanced"
        ;;
esac

echo "$NEXT" > "$FAN_FILE"

REAL_USER="${SUDO_USER:-$USER}"
USER_ID=$(id -u "$REAL_USER")

sudo -u "$REAL_USER" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus" \
    notify-send "Fan Mode" "$LABEL" -t 2000

#Then make it executable

chmod +x switch_fan.sh