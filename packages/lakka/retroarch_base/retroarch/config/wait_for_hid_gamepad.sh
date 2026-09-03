#!/bin/sh

MAX_WAIT=30

system-log "Waiting for HID Gamepad to become available..."

while true; do

    if grep -q '^N: Name="Raspberry Pi Pico"$' /proc/bus/input/devices 2>/dev/null; then
        break
    fi
    
    sleep 1
done

system-log "HID Gamepad successfully found!"
