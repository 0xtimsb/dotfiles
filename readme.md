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
fish neovim git rustup sway swayidle swaylock brightnessctl
firefox pulseaudio blueman curl wget wl-clipboard playerctl
syncthing wf-recorder base-devel inotify-tools neofetch htop
grim vlc transmission-gtk slurp openssh foot
```

install `jack2`, `noto-fonts` as dependencies.

` cloudflare-warp  spotify-client` figure out

for rust follow this: [here](https://wiki.debian.org/Rust)

for node on fish, install [fisher](https://github.com/jorgebucaran/fisher) and [nvm.fish](https://github.com/jorgebucaran/nvm.fish?tab=readme-ov-file)

for bun follow this: [here](https://bun.sh/docs/installation)

for zed follow this: [here](https://zed.dev/docs/getting-started)
