#!/bin/bash

mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/zed"
mkdir -p "$HOME/.config/Cursor/User"
mkdir -p "$HOME/.config/fish"

stow -R -t "$HOME" config git