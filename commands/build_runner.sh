#!/bin/bash

source "$(dirname "$0")/utils/spinner.sh"

MMATE_DIR="mmate_system"
PACKAGES=("core" "function" "design")
LOG_FILE="temp.log"
ERRORS=()

GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

# build_runner 존재 여부 확인 함수
check_build_runner_installed() {
  if ! grep -E "^[[:space:]]*build_runner:" pubspec.yaml > /dev/null 2>&1; then
    echo -e "${RED}[!] 'build_runner' not found in pubspec.yaml. Skipping...${RESET}"
    return 1
  fi
  return 0
}

echo "🔨 Running 'build_runner build'..."

# 현재 디렉토리
if [ -f "pubspec.yaml" ]; then
  if check_build_runner_installed; then
    flutter pub run build_runner build --delete-conflicting-outputs > "$LOG_FILE" 2>&1 &
    show_spinner $!
    wait $!

    if [ $? -ne 0 ]; then
      ERRORS+=("${RED}[✘] Current package - Build failed.${RESET}")
    else
      echo -e "${GREEN}[✓] Current package - Build complete.${RESET}"
    fi
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
      if check_build_runner_installed; then
        flutter pub run build_runner build --delete-conflicting-outputs > "$LOG_FILE" 2>&1
        exit $?
      else
        exit 99
      fi
    ) &
    show_spinner $!
    wait $!

    STATUS=$?
    if [ $STATUS -eq 99 ]; then
      echo -e "${RED}[!] '$package' skipped due to missing build_runner.${RESET}"
    elif [ $STATUS -ne 0 ]; then
      ERRORS+=("${RED}[✘] '$package' - Build failed.${RESET}")
    else
      echo -e "${GREEN}[✓] '$package' - Build complete.${RESET}"
    fi
  else
    echo -e "${RED}[✘] '$package' not found. Skipping...${RESET}"
  fi
done

rm -f "$LOG_FILE"

if [ ${#ERRORS[@]} -ne 0 ]; then
  echo -e "${RED}⚠️ Build errors:${RESET}"
  for error in "${ERRORS[@]}"; do
    echo "   $error"
  done
  exit 1
fi
