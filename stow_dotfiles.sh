#!/usr/bin/env bash

DOTFILES_DIR="$HOME/dotfiles"

stow_dir() {
    local source_dir="$1"
    local target_dir="$2"
    local stow_dir="$3"

    echo "Stowing $stow_dir to $target_dir"
    stow -v -R -t "$target_dir" -d "$source_dir" --adopt "$stow_dir"
}

stow_dir "$DOTFILES_DIR" "$HOME/.config" "config"
stow_dir "$DOTFILES_DIR" "$HOME" "home"

if [ -d "$DOTFILES_DIR/nixos" ]; then
    sudo stow -v -R -t "/etc/nixos" -d "$DOTFILES_DIR" --adopt "nixos"
fi

echo "dotfiles have been stowed!"
