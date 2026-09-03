#!/bin/sh

LOG="/storage/.config/system.log"

mkdir -p /storage/.config

{
    printf '[%s] ' "$(date '+%Y-%m-%d %H:%M:%S')"
    printf '%s\n' "$*"
} >> "$LOG"
