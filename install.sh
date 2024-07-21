#!/bin/bash

# Run system update
./update_system.sh

# Install packages
./install_packages.sh

# Install apps
./apps/vscode.sh
./apps/spotify.sh
./apps/slack.sh
./apps/firefox.sh

echo "All installations complete!"

