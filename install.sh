#!/bin/bash

# Run system update
./helper/update.sh

# Install packages
./helper/packages.sh

# Install apps
./apps/vscode.sh
./apps/spotify.sh
./apps/slack.sh
./apps/firefox.sh
./apps/mongo.sh

echo "All installations complete!"

