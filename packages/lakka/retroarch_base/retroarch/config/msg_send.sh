#!/bin/sh

HID="/dev/hidraw0"

CMD_READY=0x01
CMD_NO_GAME=0x02
CMD_NO_CORE=0x03
CMD_GAME_START=0x04

send() {
    printf '%b' "$(printf '\\x02\\x%02x' "$1")" > "$HID"
}

case "$1" in
    ready)
        system-log "Command sent: READY"
        send "$CMD_READY"
        ;;
    no-game)
        system-log "Command sent: NO GAME"
        send "$CMD_NO_GAME"
        ;;
    no-core)
        system-log "Command sent: NO CORE"
        send "$CMD_NO_CORE"
        ;;
    game-start)
        system-log "Command sent: GAME START"
        send "$CMD_GAME_START"
        ;;
    *)
        echo "Usage: $0 {ready|no-game|no-core|game-start}"
        exit 1
        ;;
esac
