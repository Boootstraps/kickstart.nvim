#!/usr/bin/env bash

# Define colour codes
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"  # No Colour / Reset

CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
LOCAL_SHARE_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
REPO_URL="https://github.com/boootstraps/kickstart.nvim.git"

# Remove existing Neovim config if it exists
if [ -d "$CONFIG_PATH" ]; then
  echo -e "${BLUE}Removing existing Neovim config at:${NC} ${CONFIG_PATH}"
  rm -rf "$CONFIG_PATH"
else
  echo -e "${GREEN}No existing Neovim config found at:${NC} ${CONFIG_PATH}"
fi

# Remove existing Neovim local data if it exists
if [ -d "$LOCAL_SHARE_PATH" ]; then
  echo -e "${BLUE}Removing existing Neovim local data at:${NC} ${LOCAL_SHARE_PATH}"
  rm -rf "$LOCAL_SHARE_PATH"
else
  echo -e "${GREEN}No existing Neovim local data found at:${NC} ${LOCAL_SHARE_PATH}"
fi

# Clone fresh Kickstart config
echo -e "${GREEN}Cloning Kickstart.nvim into:${NC} ${CONFIG_PATH}"
if git clone "$REPO_URL" "$CONFIG_PATH"; then
  echo -e "${GREEN}Successfully cloned Kickstart.nvim.${NC}"
else
  echo -e "${RED}Error: Git clone failed.${NC}"
  exit 1
fi

echo -e "${GREEN}Enjoy your fresh Neovim config.${NC}"
