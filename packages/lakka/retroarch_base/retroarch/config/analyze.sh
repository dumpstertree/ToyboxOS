#!/bin/sh

LOG="/storage/.config/boot-profiler.log"
PLOT="/storage/.config/boot.svg"

mkdir -p /storage/.config



# Append immediately. Do NOT wrap the script in a giant
# { ... } >> "$LOG" block, so crashes preserve the log.
log()
{
    echo "$*" >> "$LOG"
}

run()
{
    echo "$ $*" >> "$LOG"
    "$@" >> "$LOG" 2>&1
    echo "[exit=$?]" >> "$LOG"
}

log ""
log "============================================================"
log "Lakka Boot Profiler"
log "Started: $(date)"
log "============================================================"

# ------------------------------------------------------------
# Wait for systemd to finish booting
# ------------------------------------------------------------


# copy
cp /usr/lib/udev/hwdb.bin /storage/.config/hwdb.bin

# ------------------------------------------------------------
# Basic boot information
# ------------------------------------------------------------

log ""
log "===== [2] Boot completion ====="
run date
run systemctl is-system-running
run systemctl list-jobs

# ------------------------------------------------------------
# systemd timing
# ------------------------------------------------------------

log ""
log "===== [3] systemd-analyze time ====="
run systemd-analyze time

log ""
log "===== [4] systemd-analyze blame ====="
run systemd-analyze blame

log ""
log "===== [5] systemd-analyze critical-chain ====="
run systemd-analyze critical-chain

# ------------------------------------------------------------
# Boot graph
# ------------------------------------------------------------

log ""
log "===== [6] systemd-analyze plot ====="
log "Writing boot timeline to: $PLOT"

systemd-analyze plot > "$PLOT" 2>> "$LOG"
PLOT_RET=$?

log "[plot exit=$PLOT_RET]"

if [ -f "$PLOT" ]; then
    ls -lh "$PLOT" >> "$LOG" 2>&1
else
    log "[PLOT] No plot was created."
fi

# ------------------------------------------------------------
# Running / failed services
# ------------------------------------------------------------

log ""
log "===== [7] Running services ====="
run systemctl list-units --type=service --state=running --no-pager

log ""
log "===== [8] Failed units ====="
run systemctl --failed --no-pager

# ------------------------------------------------------------
# HWDB diagnostics
# ------------------------------------------------------------

log ""
log "============================================================"
log "SYSTEMD HWDB DIAGNOSTICS"
log "============================================================"

log ""
log "===== [9] systemd-hwdb-update.service status ====="
run systemctl status systemd-hwdb-update.service --no-pager

log ""
log "===== [10] systemd-hwdb-update.service definition ====="
run systemctl cat systemd-hwdb-update.service

log ""
log "===== [11] systemd-hwdb-update.service properties ====="
run systemctl show systemd-hwdb-update.service \
    -p Id \
    -p LoadState \
    -p ActiveState \
    -p SubState \
    -p Result \
    -p ExecMainStartTimestamp \
    -p ExecMainExitTimestamp \
    -p ExecMainStatus \
    -p ExecStart \
    -p After \
    -p Before \
    -p Wants \
    -p Requires \
    -p WantedBy

log ""
log "===== [12] HWDB service dependencies ====="
run systemctl list-dependencies systemd-hwdb-update.service --no-pager

log ""
log "===== [13] systemd-hwdb executable ====="

if command -v systemd-hwdb >/dev/null 2>&1; then
    log "$(command -v systemd-hwdb)"
    ls -l "$(command -v systemd-hwdb)" >> "$LOG" 2>&1

    log ""
    log "===== [14] systemd-hwdb help ====="
    systemd-hwdb --help >> "$LOG" 2>&1
else
    log "ERROR: systemd-hwdb not found"
fi

log ""
log "===== [15] HWDB binary ====="

if [ -e /usr/lib/udev/hwdb.bin ]; then
    ls -lh /usr/lib/udev/hwdb.bin >> "$LOG" 2>&1
    stat /usr/lib/udev/hwdb.bin >> "$LOG" 2>&1
else
    log "/usr/lib/udev/hwdb.bin does not exist"
fi

log ""
log "===== [16] HWDB source directories ====="

for DIR in \
    /usr/lib/udev/hwdb.d \
    /etc/udev/hwdb.d \
    /lib/udev/hwdb.d
do
    log ""
    log "--- $DIR ---"

    if [ -d "$DIR" ]; then
        ls -lah "$DIR" >> "$LOG" 2>&1
    else
        log "Directory does not exist"
    fi
done

# ------------------------------------------------------------
# UDEV / HID diagnostics
# ------------------------------------------------------------

log ""
log "============================================================"
log "UDEV / INPUT DIAGNOSTICS"
log "============================================================"

log ""
log "===== [17] /proc/bus/input/devices ====="
cat /proc/bus/input/devices >> "$LOG" 2>&1

log ""
log "===== [18] /dev/input ====="

if [ -d /dev/input ]; then
    ls -la /dev/input >> "$LOG" 2>&1
else
    log "/dev/input does not exist"
fi

log ""
log "===== [19] udev database ====="

if command -v udevadm >/dev/null 2>&1; then
    udevadm info --export-db >> "$LOG" 2>&1
else
    log "ERROR: udevadm not found"
fi

# ------------------------------------------------------------
# Other expensive services
# ------------------------------------------------------------

log ""
log "============================================================"
log "OTHER BOOT SERVICES"
log "============================================================"

log ""
log "===== [20] add-entropy.service ====="
run systemctl status add-entropy.service --no-pager
run systemctl cat add-entropy.service

log ""
log "===== [21] iwd.service ====="
run systemctl status iwd.service --no-pager
run systemctl cat iwd.service

log ""
log "===== [22] connman.service ====="
run systemctl status connman.service --no-pager
run systemctl cat connman.service

log ""
log "===== [23] dbus.service ====="
run systemctl status dbus.service --no-pager

log ""
log "===== [24] systemd-logind.service ====="
run systemctl status systemd-logind.service --no-pager

# ------------------------------------------------------------
# Finish
# ------------------------------------------------------------

log ""
log "============================================================"
log "BOOT PROFILER COMPLETE"
log "Finished: $(date)"
log "============================================================"

exit 0
