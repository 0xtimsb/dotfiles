as root:
```
usermod -aG sudo tims
apt update
apt upgrade
apt install sudo
```

as user:
```
sudo apt install sway swayidle swaylock neovim git firefox-esr
```

more:
```
sudo apt install fish rustup bluez blueman curl wget wl-clipboard playerctl
syncthing wf-recorder base-devel neofetch htop
grim vlc transmission-gtk slurp openssh foot fuse
power-profiles-daemon ttf-liberation ttf-roboto noto-fonts
pusleaudio pulseaudio-bluetooth gnome-keyring
gnome-disk-utility ntfs-3g sysstat wireless_tools
zoxide pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
```

for rust follow this: [here](https://wiki.debian.org/Rust)

for node on fish, install [fisher](https://github.com/jorgebucaran/fisher) and [nvm.fish](https://github.com/jorgebucaran/nvm.fish?tab=readme-ov-file)

for bun follow this: [here](https://bun.sh/docs/installation)

for zed follow this: [here](https://zed.dev/docs/getting-started)

for screen share:

1. restart
2. run `dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway`
3. run `systemctl --user restart pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk`
4. make sure both are running `systemctl --user status xdg-desktop-portal-gtk xdg-desktop-portal-wlr`
5. test [here](https://mozilla.github.io/webrtc-landing/gum_test.html)
