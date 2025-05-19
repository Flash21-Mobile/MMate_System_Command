#!/bin/bash

source "$(dirname "$0")/utils/spinner.sh"

MMATE_DIR="mmate_system"
REPO_URL="https://github.com/Flash21-Mobile/MMate_System.git"
GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

echo "🚀 Initializing MMate System..."

if [ -d "$MMATE_DIR" ]; then
  echo -e "${RED}[✘] '$MMATE_DIR' already exists. Delete it first.${RESET}"
  exit 1
fi

echo -e "${GREEN}[✓] Cloning from $REPO_URL into '$MMATE_DIR'...${RESET}"
git clone "$REPO_URL" "$MMATE_DIR" > /dev/null 2>&1 &
show_spinner $!
wait $!

if [ $? -eq 0 ]; then
  echo -e "${GREEN}[✓] Clone successful.${RESET}"
else
  echo -e "${RED}[✘] Clone failed.${RESET}"
fi