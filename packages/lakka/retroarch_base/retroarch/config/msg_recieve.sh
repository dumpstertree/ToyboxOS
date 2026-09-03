#!/bin/sh

HID="/dev/hidraw0"

while true; do
    # Read one HID report
    REPORT=$(dd if="$HID" bs=2 count=1 2>/dev/null)

    # Convert report to hex
    HEX=$(printf '%s' "$REPORT" | od -An -t x1)

    # First byte = report ID
    REPORT_ID=$(printf '%s' "$HEX" | awk '{print $1}')

    # Second byte = command
    CMD=$(printf '%s' "$HEX" | awk '{print $2}')

    [ "$REPORT_ID" = "02" ] || continue

    case "$CMD" in
        01)
            system-log "Command recieved: READY"
            echo "READY"
            ;;
        02)
            system-log "Command recieved: No Game"
            echo "NO GAME"
            ;;
        03)
            system-log "Command recieved: No Core"
            echo "NO CORE"
            ;;
        04)
            system-log "Command recieved: READY"
            touch /usr/share/retroarch/.ready
            ;;
        *)
            echo "UNKNOWN COMMAND: 0x$CMD"
            ;;
    esac
done
