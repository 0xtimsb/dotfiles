#!/bin/bash

if ! command -v slack &> /dev/null; then
    echo "Installing Slack..."
    wget https://downloads.slack-edge.com/releases/linux/4.29.149/prod/x64/slack-desktop-4.29.149-amd64.deb
    sudo apt install ./slack-desktop-*.deb -y
    rm slack-desktop-*.deb
    echo "Slack installed successfully."
else
    echo "Slack is already installed."
fi