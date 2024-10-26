as root:
```
usermod -aG sudo tims
apt update
apt upgrade
apt install sudo
```

packages:
```
sudo apt install sway swayidle swaylock neovim git firefox-esr \
fish curl wl-clipboard playerctl \
syncthing wf-recorder neofetch htop grim slurp build-essential \
vlc transmission-gtk fonts-roboto fonts-liberation \
bluez blueman pipewire wireplumber pipewire-audio \
gnome-disk-utility ntfs-3g gnome-keyring \
xdg-desktop-portal-wlr xdg-desktop-portal-gtk rustup zoxide \
unzip calibre
```
fish as default:
```
chsh -s /usr/bin/fish
```

for network/power permissions: `fish_add_path /sbin /usr/sbin`

firefox scale fix: `layout.css.devPixelsPerPx` as `1.8` in `about:config`


for rust follow this: [here](https://wiki.debian.org/Rust)

for node on fish, install [fisher](https://github.com/jorgebucaran/fisher) and [nvm.fish](https://github.com/jorgebucaran/nvm.fish?tab=readme-ov-file)

for bun follow this: [here](https://bun.sh/docs/installation)

for zed follow this: [here](https://zed.dev/docs/getting-started)

for git follow this: [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

note use this for fish (c instead of s): `eval "$(ssh-agent -c)"`

for screen share:

1. restart
2. run `dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway`
3. run `systemctl --user restart pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk`
4. make sure both are running `systemctl --user status xdg-desktop-portal-gtk xdg-desktop-portal-wlr`
5. test [here](https://mozilla.github.io/webrtc-landing/gum_test.html)
