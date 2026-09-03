#!/bin/sh


system-log "Waiting for HID storage to become available..."

while true; do

  for dev in /dev/sd[a-z][0-9]; do
        [ -e "$dev" ] || continue

        if udevadm info --query=property --name="$dev" 2>/dev/null | grep -q '^ID_VENDOR_ID=239a$'; then
            break
        fi
    done
    
    sleep 1
done

system-log "HID storage successfully found!"

