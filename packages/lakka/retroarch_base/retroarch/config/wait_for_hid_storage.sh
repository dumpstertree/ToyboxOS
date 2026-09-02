

#!/bin/sh

MAX_WAIT=30

for i in $(seq 1 "$MAX_WAIT"); do

  for dev in /dev/sd[a-z][0-9]; do
        [ -e "$dev" ] || continue

        if udevadm info --query=property --name="$dev" 2>/dev/null | grep -q '^ID_VENDOR_ID=239a$'; then
            break
        fi
    done
    
    sleep 1
done
