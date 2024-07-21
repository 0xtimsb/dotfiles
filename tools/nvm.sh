#!/bin/bash

echo "Installing Fisher and NVM for Fish..."
mkdir -p ~/.config/fish
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install jorgebucaran/nvm.fish"
echo "Fisher and NVM for Fish installed successfully."

echo "Installing Node.js LTS version..."
fish -c "nvm install lts"
echo "Node.js LTS version installed successfully."