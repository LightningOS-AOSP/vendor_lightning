#!/bin/bash

DEVICE="$1"
ROM_NAME="$2"
VERSION="$3"
PACKAGE_TYPE="$4"
RELEASE_TYPE="$5"
ZIP_PATH="$6"
MAINTAINER="$7"
BUILD_DURATION="$8"

[ -z "$MAINTAINER" ] && MAINTAINER="Unknown"
[ -z "$BUILD_DURATION" ] && BUILD_DURATION=0

RESET="\e[0m"
BOLD="\e[1m"
DIM="\e[2m"
WHITE="\e[1;37m"
YELLOW="\e[38;5;226m"
AMBER="\e[38;5;214m"
ORANGE="\e[38;5;208m"
ELECTRIC="\e[38;5;51m"
GREEN="\e[38;5;46m"
RED="\e[38;5;196m"

case "$(echo "$RELEASE_TYPE" | tr '[:upper:]' '[:lower:]')" in
    official)   RELEASE_COLOR="$GREEN" ;;
    unofficial) RELEASE_COLOR="$RED" ;;
    *)          RELEASE_COLOR="$WHITE" ;;
esac

if [ -f "$ZIP_PATH" ]; then
    FILE_SIZE=$(du -h "$ZIP_PATH" | awk '{print $1}')
else
    FILE_SIZE="N/A"
fi

HRS=$((BUILD_DURATION / 3600))
MINS=$(((BUILD_DURATION % 3600) / 60))
SECS=$((BUILD_DURATION % 60))

if [ "$HRS" -gt 0 ]; then
    DURATION_FORMAT="${HRS}h ${MINS}m ${SECS}s"
elif [ "$MINS" -gt 0 ]; then
    DURATION_FORMAT="${MINS}m ${SECS}s"
else
    DURATION_FORMAT="${SECS}s"
fi

BANNER=(
"██╗     ██╗ ██████╗ ██╗  ██╗████████╗███╗   ██╗██╗███╗   ██╗ ██████╗      ██████╗ ███████╗"
"██║     ██║██╔════╝ ██║  ██║╚══██╔══╝████╗  ██║██║████╗  ██║██╔════╝     ██╔═══██╗██╔════╝"
"██║     ██║██║  ███╗███████║   ██║   ██╔██╗ ██║██║██╔██╗ ██║██║  ███╗    ██║   ██║███████╗"
"██║     ██║██║   ██║██╔══██║   ██║   ██║╚██╗██║██║██║╚██╗██║██║   ██║    ██║   ██║╚════██║"
"███████╗██║╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║██║ ╚████║╚██████╔╝    ╚██████╔╝███████║"
"╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝      ╚═════╝ ╚══════╝"
)
GRADIENT=(226 226 220 214 208 202)

echo ""
for i in "${!BANNER[@]}"; do
    echo -e "\e[38;5;${GRADIENT[$i]}m${BANNER[$i]}${RESET}"
done
echo ""
echo -e "${ELECTRIC}              ⚡  Strike Fast. Build Faster.  ⚡${RESET}"
echo ""

LABEL_W=12
TITLE="LightningOS Build Summary"
ZIP_NAME="$(basename "$ZIP_PATH")"

VAL_W=0
for v in "$ROM_NAME" "$ZIP_NAME" "$VERSION" "$PACKAGE_TYPE" "$RELEASE_TYPE" \
         "$DEVICE" "$MAINTAINER" "$FILE_SIZE" "$DURATION_FORMAT"; do
    [ "${#v}" -gt "$VAL_W" ] && VAL_W=${#v}
done
MIN_TOTAL=$(( ${#TITLE} + 4 ))
[ $(( LABEL_W + VAL_W + 5 )) -lt "$MIN_TOTAL" ] && VAL_W=$(( MIN_TOTAL - LABEL_W - 5 ))

rep() { local s; s=$(printf '%*s' "$2" ''); echo -n "${s// /$1}"; }

C1=$(rep ─ $(( LABEL_W + 2 )))
C2=$(rep ─ $(( VAL_W + 2 )))
TOTAL=$(( LABEL_W + VAL_W + 5 ))

top()    { echo -e "${AMBER}╭${C1}┬${C2}╮${RESET}"; }
head_()  { echo -e "${AMBER}├${C1}┬${C2}┤${RESET}"; }
mid()    { echo -e "${AMBER}├${C1}┼${C2}┤${RESET}"; }
bottom() { echo -e "${AMBER}╰${C1}┴${C2}╯${RESET}"; }

row() {
    local label="$1" value="$2" color="${3:-$WHITE}"
    printf "${AMBER}│${RESET} ${BOLD}${ELECTRIC}%-${LABEL_W}s${RESET} ${AMBER}│${RESET} ${color}%-${VAL_W}s${RESET} ${AMBER}│${RESET}\n" \
        "$label" "$value"
}

LEFT=$(( (TOTAL - ${#TITLE}) / 2 ))
RIGHT=$(( TOTAL - ${#TITLE} - LEFT ))

echo -e "${AMBER}╭$(rep ─ $TOTAL)╮${RESET}"
printf "${AMBER}│${RESET}%*s${BOLD}${YELLOW}%s${RESET}%*s${AMBER}│${RESET}\n" "$LEFT" "" "$TITLE" "$RIGHT" ""
head_
row "ROM"        "$ROM_NAME"
mid
row "Version"    "$VERSION"
mid
row "Device"     "$DEVICE"
mid
row "Package"    "$PACKAGE_TYPE"
mid
row "Release"    "$RELEASE_TYPE" "${RELEASE_COLOR}${BOLD}"
mid
row "Maintainer" "$MAINTAINER"
mid
row "Build Time" "$DURATION_FORMAT"
mid
row "File Size"  "$FILE_SIZE"
mid
row "Zip"        "$ZIP_NAME"
bottom
echo ""
echo -e "${GREEN}⚡ Build complete. Lightning struck successfully!${RESET}"
echo -e "${ELECTRIC}⚡ Output: ${WHITE}${ZIP_PATH}${RESET}"
echo ""