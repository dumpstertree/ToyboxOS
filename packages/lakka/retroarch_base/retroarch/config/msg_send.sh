#!/bin/sh

HID="/dev/hidraw0"

CMD_READY=0x01
CMD_NO_GAME=0x02
CMD_NO_CORE=0x03
CMD_GAME_START=0x04
CMD_GAME_EXIT=0x05

send() {
    printf '%b' "$(printf '\\x02\\x%02x' "$1")" > "$HID"
}

case "$1" in
    ready)
        send "$CMD_READY"
        ;;
    no-game)
        send "$CMD_NO_GAME"
        ;;
    no-core)
        send "$CMD_NO_CORE"
        ;;
    game-start)
        send "$CMD_GAME_START"
        ;;
    game-exit)
        send "$CMD_GAME_EXIT"
        ;;
    *)
        echo "Usage: $0 {ready|no-game|no-core|game-start|game-exit}"
        exit 1
        ;;
esac
