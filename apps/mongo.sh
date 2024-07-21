#!/bin/bash

MONGO_COMPASS_VERSION="1.43.4"

if ! command -v mongodb-compass &> /dev/null; then
    echo "Installing MongoDB Compass..."
    wget https://downloads.mongodb.com/compass/mongodb-compass_${MONGO_COMPASS_VERSION}_amd64.deb
    sudo apt install ./mongodb-compass_${MONGO_COMPASS_VERSION}_amd64.deb -y
    rm mongodb-compass_${MONGO_COMPASS_VERSION}_amd64.deb
    echo "MongoDB Compass installed successfully."
else
    echo "MongoDB Compass is already installed."
fi