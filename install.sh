#!/bin/bash

packages=(
    git
    config
    x11
)

for package in "${packages[@]}"; do
    echo "stowing $package"
    stow -R "$package"
done