#!/bin/bash

if ! command -v fish &> /dev/null; then
    echo "Installing Fish shell..."
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
    curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    sudo apt update
    sudo apt install fish -y
    echo "Fish shell installed successfully."
    echo "Setting Fish as the default shell..."
    chsh -s $(which fish)
    echo "Fish is now set as the default shell. Please log out and log back in for the changes to take effect."
else
    echo "Fish shell is already installed."
    if [[ $SHELL != *"fish"* ]]; then
        echo "Setting Fish as the default shell..."
        chsh -s $(which fish)
        echo "Fish is now set as the default shell. Please log out and log back in for the changes to take effect."
    else
        echo "Fish is already set as the default shell."
    fi
fi