#!/bin/bash

packages=(
    git
    config
)

for package in "${packages[@]}"; do
    echo "stowing $package"
    stow -R "$package"
done