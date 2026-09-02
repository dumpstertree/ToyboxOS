PKG_NAME="libretro_cores"
PKG_LICENSE="GPL"
PKG_SITE="https://www.lakka.tv"
PKG_SECTION="virtual"
PKG_LONGDESC="Root package used to select libretro cores"

# List of libretro cores
#
# Mainstream consoles only.
# Selected for a lightweight/offline Raspberry Pi Zero 2 W system.
#
# NES                  - fceumm
# SNES                 - snes9x
# Game Boy / Color     - sameboy
# Game Boy Advance     - mgba
# Genesis/Mega Drive    - genesis_plus_gx
# Master System         - genesis_plus_gx
# Game Gear             - genesis_plus_gx
# PC Engine/TG16        - beetle_pce
# PlayStation            - pcsx_rearmed
# Nintendo 64            - mupen64plus_next
# Nintendo DS             - melonds
# Arcade / Neo Geo       - fbneo
# Atari 2600              - stella
# Atari 7800              - prosystem
# ColecoVision            - gearcoleco

LIBRETRO_CORES="\
                fceumm \
                snes9x \
                sameboy \
                mgba \
                genesis_plus_gx \
                beetle_pce \
                pcsx_rearmed \
                mupen64plus_next \
                melonds \
                fbneo \
                stella \
                prosystem \
                gearcoleco \
              "


# Cores that take longer to compile can be started first.
# Keep this limited to cores actually included above.
EARLY_START_LR_CORES="\
                      fbneo \
                      mupen64plus_next \
                      melonds \
                      pcsx_rearmed \
                    "


# Put early-start cores at the front of the list.
# First remove them to avoid duplicates.
for core in ${EARLY_START_LR_CORES} ; do
  LIBRETRO_CORES="${LIBRETRO_CORES// ${core} /}"
done


# Prepend the early-start list.
LIBRETRO_CORES="${EARLY_START_LR_CORES} ${LIBRETRO_CORES}"


# Override above with custom list via:
# CUSTOM_LIBRETRO_CORES="core1 core2"
# passed to make.
if [ -n "${CUSTOM_LIBRETRO_CORES}" ]; then
  LIBRETRO_CORES="${CUSTOM_LIBRETRO_CORES}"
fi


# Disable cores that do not build for OpenGLES.
if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
  EXCLUDE_LIBRETRO_CORES+=" kronos"
fi


# Disable cores based on PROJECT/DEVICE.
#
# The core list above is already intentionally small, but keep the
# project-specific exclusions required by Lakka.

if [ "${PROJECT}" = "Allwinner" ]; then

  EXCLUDE_LIBRETRO_CORES+=" lr_moonlight"

elif [ "${PROJECT}" = "Amlogic" ]; then

  EXCLUDE_LIBRETRO_CORES+=" lr_moonlight \
                            panda3ds"

elif [ "${PROJECT}" = "Ayn" ]; then

  EXCLUDE_LIBRETRO_CORES+=" lr_moonlight"

elif [ "${PROJECT}" = "Generic" ]; then

  EXCLUDE_LIBRETRO_CORES+=" lr_moonlight"

elif [ "${PROJECT}" = "L4T" ]; then

  EXCLUDE_LIBRETRO_CORES+=" lr_moonlight \
                            panda3ds"

elif [ "${PROJECT}" = "NXP" ]; then

  EXCLUDE_LIBRETRO_CORES+=" lr_moonlight"

  if [ "${DEVICE}" = "iMX8" ]; then
    EXCLUDE_LIBRETRO_CORES+=" panda3ds"
  fi

elif [ "${PROJECT}" = "Rockchip" ]; then

  EXCLUDE_LIBRETRO_CORES+=" lr_moonlight"

elif [ "${PROJECT}" = "RPi" ]; then

  EXCLUDE_LIBRETRO_CORES+=" lr_moonlight"

  # Pi Zero 2 W specific exclusions.
  #
  # These are cores from the original Lakka configuration that are
  # either too demanding or unnecessary for this target.
  if [ "${DEVICE}" = "RPiZero2-GPiCase2W" ]; then
    EXCLUDE_LIBRETRO_CORES+=" panda3ds"
  fi

elif [ "${PROJECT}" = "Samsung" ]; then

  EXCLUDE_LIBRETRO_CORES+=" lr_moonlight"

fi


# Exclude cores at build time via:
# EXCLUDE_LIBRETRO_CORES="core1 core2"
#
# Cores added above by the platform-specific logic are also removed.
if [ -n "${EXCLUDE_LIBRETRO_CORES}" ]; then
  for core in ${EXCLUDE_LIBRETRO_CORES} ; do
    LIBRETRO_CORES="${LIBRETRO_CORES// ${core} /}"
  done
fi


# Finally set package dependencies.
PKG_DEPENDS_TARGET="${LIBRETRO_CORES}"