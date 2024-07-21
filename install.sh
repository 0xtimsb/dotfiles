#!/bin/bash

# Run system update
./update.sh

# Install packages
./packages.sh

# Install apps
./apps/vscode.sh
./apps/spotify.sh
./apps/slack.sh
./apps/firefox.sh

echo "All installations complete!"

