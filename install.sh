#!/bin/bash

# Install packages
./helper/update.sh
./helper/packages.sh

# Install tools
./tools/fish.sh
./tools/nvm.sh
./tools/pnpm.sh
./tools/bun.sh

# Install apps
./apps/vscode.sh
./apps/spotify.sh
./apps/slack.sh
./apps/firefox.sh
./apps/mongo.sh

echo "All installations complete!"

