#!/bin/bash

GIT_NAME="tims"
GIT_EMAIL="0xtimsb@gmail.com"

run_in_fish() {
    fish -c "$1"
}

sudo apt purge snapd
sudo apt autoremove

echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" | sudo tee /etc/apt/preferences.d/no-snap.pref

echo "Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1" | sudo tee /etc/apt/preferences.d/firefox-no-snap.pref

sudo add-apt-repository ppa:mozillateam/ppa
sudo apt update

sudo apt install -y firefox fonts-noto-core git sway swaylock swayidle fish foot neovim inotify-tools brightnessctl blueman

sudo timedatectl set-timezone Asia/Kolkata

chsh -s $(which fish)

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

ssh-keygen -t ed25519 -C "$GIT_EMAIL"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

curl -f https://zed.dev/install.sh | sh

curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client

sudo apt-get install -y curl wget lsb-release software-properties-common cargo ccache cmake git golang libtool ninja-build pkg-config rustc ruby-full xz-utils

curl -fsSL https://bun.sh/install | bash

wget https://apt.llvm.org/llvm.sh -O - | sudo bash -s -- 16 all

run_in_fish "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
run_in_fish "fisher install jorgebucaran/nvm.fish"

run_in_fish "nvm install lts"

echo "yay logout and log back in!"
