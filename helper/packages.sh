#!/bin/bash

packages=(
    build-essential
    curl
    ffmpeg
    fzf
    vlc
    neovim
    fish
    kitty
    sway
    swaylock
    swayidle
    swaybg
    stow
    wl-clipboard
    syncthing
    transmission-gtk
)

echo "Installing packages..."

for package in "${packages[@]}"; do
    if ! dpkg -s "$package" >/dev/null 2>&1; then
        sudo apt install -y "$package"
        echo "$package installed."
    else
        echo "$package is already installed."
    fi
done

echo "All packages installed successfully."