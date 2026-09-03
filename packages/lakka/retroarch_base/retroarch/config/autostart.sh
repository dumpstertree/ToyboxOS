#!/bin/sh

mkdir -p /storage/.config
LOG="/storage/.config/autostart.log"


system-log "Launching Retroarch..."
{

    system-log "Looking for roms in /storage/roms..."

    cat /proc/mounts
    GAME=""
    ROM_DIR="/storage/roms"
    ROM_EXTENSIONS="nes sfc smc gba gb gbc gen md sms n64 z64 v64 chd cue iso"

    echo "[3] Looking for ROMs in $ROM_DIR..."

    for ext in $ROM_EXTENSIONS; do
        GAME=$(find "$ROM_DIR" -maxdepth 1 -type f -iname "*.$ext" 2>/dev/null | head -n 1)

        if [ -n "$GAME" ]; then
            echo "    FOUND: $GAME"
            break
        fi
    done

    if [ -z "$GAME" ]; then
        echo "[4] NO GAME FOUND"
        exit 0
    fi

    echo "[7] Selected game: $GAME"

    system-log "Found game!"
    system-log "Looking for Core..."

    case "${GAME##*.}" in
        nes|NES)
            CORE="/usr/lib/libretro/fceumm_libretro.so"
            ;;
        sfc|SFC|smc|SMC)
            CORE="/usr/lib/libretro/snes9x_libretro.so"
            ;;
        gba|GBA)
            CORE="/usr/lib/libretro/mgba_libretro.so"
            ;;
        gb|GB|gbc|GBC)
            CORE="/usr/lib/libretro/sameboy_libretro.so"
            ;;
        gen|GEN|md|MD|sms|SMS)
            CORE="/usr/lib/libretro/genesis_plus_gx_libretro.so"
            ;;
        n64|N64|z64|Z64|v64|V64)
            CORE="/usr/lib/libretro/mupen64plus_next_libretro.so"
            ;;
        chd|CHD|cue|CUE|iso|ISO)
            CORE="/usr/lib/libretro/pcsx_rearmed_libretro.so"
            ;;
        *)
            echo "[8] Unsupported extension: ${GAME##*.}"
            exit 0
            ;;
    esac

    echo "[8] Selected core: $CORE"


    if [ ! -f "$CORE" ]; then
        echo "[9] ERROR: Core does not exist!"
        system-log "Failed to find core"

        exit 1
    fi
    
    system-log "Found Core..."

    echo "[9] Core exists"

    echo "[10] RetroArch:"
    ls -l /usr/bin/retroarch

    echo "[11] Launching RetroArch..."
    echo "    Command:"
    echo "    /usr/bin/retroarch --verbose -L \"$CORE\" \"$GAME\""

    RETROARCH_LOG="/storage/retroarch-autostart.log"

    echo "[11a] Starting RetroArch..."

    /usr/bin/retroarch \
        --verbose \
        --log-file "$RETROARCH_LOG" \
        -L "$CORE" \
        "$GAME"

    RET=$?

    echo "[11b] RetroArch log:"
    cat "$RETROARCH_LOG" 2>/dev/null

    echo "[12] RetroArch exited with status: $RET"
    exit $RET

} >> "$LOG" 2>&1
