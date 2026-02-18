#!/bin/bash
# LightningOS Fancy Build Output Banner
# Arguments:
# 1=device, 2=lineage_version, 3=lightning_version, 4=package_type,
# 5=release_type, 6=zip_path, 7=maintainer, 8=build_duration_seconds

DEVICE="$1"
ROM_NAME="$2"
VERSION="$3"
PACKAGE_TYPE="$4"
RELEASE_TYPE="$5"
ZIP_PATH="$6"
MAINTAINER="$7"
BUILD_DURATION="$8"

# Fallbacks
[ -z "$MAINTAINER" ] && MAINTAINER="Unknown"
[ -z "$BUILD_DURATION" ] && BUILD_DURATION=0

# 
# High-Voltage 256-Color Palette
# 
ARC_WHITE="\e[1;37m"         # Blinding white arc core
VOLT_GOLD="\e[38;5;226m"     # High-voltage neon yellow
VOLT_AMBER="\e[38;5;214m"    # Hot discharge amber
PLASMA_CYAN="\e[38;5;51m"    # Ionized plasma border
ARC_BLUE="\e[38;5;45m"       # Electric discharge blue
VAL_WHITE="\e[38;5;255m"     # Crisp readout text
SUCC_NEON="\e[38;5;48m"      # Overcharged green
ERR_FLASH="\e[38;5;196m"     # Danger surge red
BOLD="\e[1m"
RESET="\e[0m"

# Release Type Check
case "$(echo "$RELEASE_TYPE" | tr '[:upper:]' '[:lower:]')" in
    official)   RELEASE_COLOR="$SUCC_NEON" ;;
    unofficial) RELEASE_COLOR="$ERR_FLASH" ;;
    *)          RELEASE_COLOR="$VAL_WHITE" ;;
esac

# File size
FILE_SIZE=$(du -h "$ZIP_PATH" 2>/dev/null | awk '{print $1}')
[ -z "$FILE_SIZE" ] && FILE_SIZE="N/A"

# Duration calculation
HOURS=$((BUILD_DURATION / 3600))
MINUTES=$(((BUILD_DURATION % 3600) / 60))
SECONDS=$((BUILD_DURATION % 60))

if [ "$HOURS" -gt 0 ]; then
    DURATION_FORMAT="${HOURS}h ${MINUTES}m ${SECONDS}s"
elif [ "$MINUTES" -gt 0 ]; then
    DURATION_FORMAT="${MINUTES}m ${SECONDS}s"
else
    DURATION_FORMAT="${SECONDS}s"
fi

# 
# ASCII Banner (LIGHTNING OS) - Voltage Arc Fade
# 
echo ""
echo -e "${PLASMA_CYAN}${RESET}"
echo -e "${ARC_WHITE} _     ___ ____ _   _ _____ _   _ ___ _   _  ____    ___  ____  ${RESET}"
echo -e "${VOLT_GOLD}| |   |_ _/ ___| | | |_   _| \\\\ | |_ _| \\\\ | |/ ___|  / _ \\\\/ ___| ${RESET}"
echo -e "${VOLT_AMBER}| |    | | |  _| |_| | | | |  \\\\| || ||  \\\\| | |  _  | | | \\\\___ \\\\ ${RESET}"
echo -e "${PLASMA_CYAN}| |___ | | |_| |  _  | | | | |\\\\  || || |\\\\  | |_| | | |_| |___) |${RESET}"
echo -e "${ARC_BLUE}|_____|___\\\\____|_| |_| |_| |_| \\\\_|___|_| \\\\_|\\\\____|  \\\\___/|____/ ${RESET}"
echo -e "${PLASMA_CYAN}${RESET}"

# 
# Build Summary Box
# 
echo -e ""
echo -e "${PLASMA_CYAN}${RESET}"
echo -e "${PLASMA_CYAN}${RESET}   ${BOLD}${VOLT_GOLD} LIGHTNING OS // SYSTEM COMPILED ${RESET}                 ${PLASMA_CYAN}${RESET}"
echo -e "${PLASMA_CYAN}${RESET}"
echo -e "${PLASMA_CYAN}${RESET} ${ARC_BLUE}TARGET DEVICE${RESET}      ${VAL_WHITE}${DEVICE}${RESET}"
echo -e "${PLASMA_CYAN}${RESET} ${ARC_BLUE}ROM NAME${RESET}           ${VAL_WHITE}${ROM_NAME}${RESET}"
echo -e "${PLASMA_CYAN}${RESET} ${ARC_BLUE}VERSION${RESET}            ${VAL_WHITE}${VERSION}${RESET}"
echo -e "${PLASMA_CYAN}${RESET} ${ARC_BLUE}PACKAGE${RESET}            ${VAL_WHITE}${PACKAGE_TYPE}${RESET}"
echo -e "${PLASMA_CYAN}${RESET} ${ARC_BLUE}RELEASE${RESET}            ${RELEASE_COLOR}${BOLD}${RELEASE_TYPE}${RESET}"
echo -e "${PLASMA_CYAN}${RESET} ${ARC_BLUE}MAINTAINER${RESET}         ${VAL_WHITE}${MAINTAINER}${RESET}"
echo -e "${PLASMA_CYAN}${RESET} ${ARC_BLUE}PAYLOAD SIZE${RESET}       ${VAL_WHITE}${FILE_SIZE}${RESET}"
echo -e "${PLASMA_CYAN}${RESET} ${ARC_BLUE}BUILD TIME${RESET}         ${VAL_WHITE}${DURATION_FORMAT}${RESET}"
echo -e "${PLASMA_CYAN}${RESET}"
echo -e ""
echo -e "${SUCC_NEON} Build completed with zero fault current!${RESET}"
echo -e "${PLASMA_CYAN} Output Archive:${RESET} ${VAL_WHITE}${ZIP_PATH}${RESET}"
echo ""
