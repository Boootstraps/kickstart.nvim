#!/usr/bin/env bash

# Define some colour codes (and reset)
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"  # No Colour / Reset

CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
REPO_URL="https://github.com/boootstraps/kickstart.nvim.git"

echo -e "${BLUE}Removing existing Neovim config at:${NC} ${CONFIG_PATH}"
rm -rf "$CONFIG_PATH"

echo -e "${GREEN}Cloning Kickstart.nvim into:${NC} $CONFIG_PATH"
git clone "$REPO_URL" "$CONFIG_PATH" || {
  echo -e "${RED}Error: Git clone failed.${NC}"
  exit 1
}

echo -e "${GREEN}Enjoy your fresh Neovim config.${NC}"

