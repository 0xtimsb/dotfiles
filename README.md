![image](https://github.com/user-attachments/assets/7adfd00e-dcc8-4c24-be8a-53c17ea022a1)

move to stable kernel:

```
sudo dnf list kernel --showduplicates
sudo dnf install kernel-xxx
```
then,
```
// to lock kernel
sudo dnf install dnf-plugins-extras-versionlock
sudo dnf versionlock add kernel-6.8.5-301.fc40
sudo dnf versionlock add kernel-devel-6.8.5-301.fc40

// check
sudo dnf versionlock list

// to clear
sudo dnf versionlock clear
```

change hostname (also fixes twice login problem):

```
hostnamectl set-hostname --static some-new-hostname
```

then reboot and choose kernel from grub.

extra packages:

```
sudo dnf install neovim git fish \
xinput xclip xterm picom fuse \
blueman bluez-tools playerctl \
google-roboto-fonts liberation-fonts \
syncthing neofetch gnome-keyring-pam \
vlc transmission-gtk gnome-keyring \
rustup zoxide calibre python3-pip stow
```

nice to have build tool:

```
sudo dnf group install "C Development Tools and Libraries"
```

syncthing:
```
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
```

fish as default:

```
chsh -s /usr/bin/fish
```

sync:

```
xrdb -merge ~/.Xresources
```

for network/power permissions:

```
fish_add_path /sbin /usr/sbin`
```

for rust:

```
rustup-init
```

for node on fish, install [fisher](https://github.com/jorgebucaran/fisher) and [nvm.fish](https://github.com/jorgebucaran/nvm.fish?tab=readme-ov-file)

for bun follow this: [here](https://bun.sh/docs/installation)

for zed follow this: [here](https://zed.dev/docs/getting-started)

for git follow this: [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

note use this for fish (c instead of s): `eval "$(ssh-agent -c)"`

for screen share test: [here](https://mozilla.github.io/webrtc-landing/gum_test.html)

run the install script:

```
cd ~/dotfiles
./install.sh
```
