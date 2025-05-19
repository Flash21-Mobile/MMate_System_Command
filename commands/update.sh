#!/bin/bash

MMATE_DIR="mmate_system"
GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

if [ ! -d "$MMATE_DIR" ]; then
  echo -e "${RED}[✘] '$MMATE_DIR' not found. Run 'mmate init' first.${RESET}"
  exit 1
fi

cd "$MMATE_DIR" || exit

git fetch origin
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" == "$REMOTE" ]; then
  echo -e "${GREEN}[✓] Already up to date.${RESET}"
else
  echo -e "${GREEN}[✓] Pulling latest changes...${RESET}"
  git pull origin main
  echo -e "${GREEN}[✓] Update complete.${RESET}"
fi

cd - > /dev/null || exit