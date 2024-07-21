#!/bin/bash

if ! command -v bun &> /dev/null; then
    echo "Installing Bun..."
    sudo apt install unzip -y
    curl -fsSL https://bun.sh/install | bash
    echo "Bun installed successfully."
else
    echo "Bun is already installed."
fi
