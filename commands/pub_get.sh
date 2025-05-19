#!/bin/bash

source "$(dirname "$0")/utils/spinner.sh"

MMATE_DIR="mmate_system"
PACKAGES=("core" "function" "design")
LOG_FILE="temp.log"
ERRORS=()

GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

echo "🚀 Running 'flutter pub get'..."

# 현재 디렉토리
if [ -f "pubspec.yaml" ]; then
  flutter pub get --suppress-analytics > "$LOG_FILE" 2>&1 &
  show_spinner $!
  wait $!

  if [ $? -ne 0 ]; then
    ERRORS+=("${RED}[✘] Current package - Failed.${RESET}")
  else
    echo -e "${GREEN}[✓] Current package - Done.${RESET}"
  fi
fi

# mmate_system 내부 패키지들
if [ ! -d "$MMATE_DIR" ]; then
  echo -e "${RED}[✘] '$MMATE_DIR' not found. Run 'mmate init' first.${RESET}"
  exit 1
fi

for package in "${PACKAGES[@]}"; do
  PACKAGE_PATH="$MMATE_DIR/$package"
  if [ -d "$PACKAGE_PATH" ]; then
    (
      cd "$PACKAGE_PATH" || exit
      flutter pub get --suppress-analytics > "$LOG_FILE" 2>&1
    ) &
    show_spinner $!
    wait $!

    if [ $? -ne 0 ]; then
      ERRORS+=("${RED}[✘] '$package' - Failed.${RESET}")
    else
      echo -e "${GREEN}[✓] '$package' - Done.${RESET}"
    fi
  else
    echo -e "${RED}[✘] '$package' not found. Skipping...${RESET}"
  fi
done

rm -f "$LOG_FILE"

if [ ${#ERRORS[@]} -ne 0 ]; then
  echo -e "${RED}⚠️ Errors:${RESET}"
  for error in "${ERRORS[@]}"; do
    echo "   $error"
  done
  exit 1
fi