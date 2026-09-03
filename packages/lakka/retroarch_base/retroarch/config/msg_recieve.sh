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
            echo "READY"
            ;;
        02)
            echo "NO GAME"
            ;;
        03)
            echo "NO CORE"
            ;;
        04)
            echo "GAME START"
            ;;
        05)
            echo "GAME EXIT"
            ;;
        *)
            echo "UNKNOWN COMMAND: 0x$CMD"
            ;;
    esac
done
