#!/bin/sh

MAX_WAIT=30

for i in $(seq 1 "$MAX_WAIT"); do

    if grep -q '^N: Name="Raspberry Pi Pico Keyboard"$' /proc/bus/input/devices 2>/dev/null; then
        break
    fi
    
    sleep 1
done
