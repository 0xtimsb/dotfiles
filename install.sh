#!/bin/bash

packages=(
    git
    config
    x11
    terminal
)

for package in "${packages[@]}"; do
    echo "stowing $package"
    stow -R "$package"
done