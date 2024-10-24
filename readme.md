arch install guide: [https://wiki.archlinux.org/title/Installation_guide](here).

in live cd:
```
pacstrap -K /mnt base linux linux-firmware networkmanager intel-ucode vim grub efibootmgr
```

grub stuff: [https://wiki.archlinux.org/title/GRUB](here).

self note: make sure to add `--removable` flag while grub install on msi motherboard

post install:

```
useradd -m -G wheel tims
passwd tims
```

connect to wifi using network manager. install `sudo` as root. add `tims` is not sudoers file. 

give wheel sudoer permission as root:
```
vim /etc/sudoers
```

packages to install post user:
```
fish neovim git rustup sway swayidle swaylock bluez
firefox blueman curl wget wl-clipboard playerctl
syncthing wf-recorder base-devel neofetch htop
grim vlc transmission-gtk slurp openssh foot fuse
power-profiles-daemon ttf-liberation ttf-roboto noto-fonts
pusleaudio pulseaudio-bluetooth gnome-keyring
gnome-disk-utility ntfs-3g sysstat wireless_tools
zoxide pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk // for wayland screen share
```

for yay follow this: [here](https://github.com/Jguer/yay)

yay apps:
```
walk cloudflare-warp-bin
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
