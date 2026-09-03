#!/bin/sh

system-log "Waiting for HID Mouse to become available..."

while true; do

    if grep -q '^N: Name="Raspberry Pi Pico Mouse"$' /proc/bus/input/devices 2>/dev/null; then
        break
    fi
    
    sleep 1
done

system-log "HID Mouse successfully found!"
