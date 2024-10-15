in live cd:
```
pacstrap -K /mnt base linux linux-firmware networkmanager intel-ucode vim grub efibootmgr
```

self note: make sure to add `--removable` flag while grub install on msi motherboard

as root:
```
apt install sudo 
```

as user:
```
sudo apt install fish neovim git rustup network-manager sway swayidle swaylock brightnessctl firefox-esr pulseaudio blueman curl wget wl-clipboard playerctl syncthingn wf-recorder build-essential font-noto-core inotify-tools neofetch htop grim vlc cloudflare-warp transmission-gtk slurp spotify-client
```

for rust follow this: [here](https://wiki.debian.org/Rust)

for node on fish, install [fisher](https://github.com/jorgebucaran/fisher) and [nvm.fish](https://github.com/jorgebucaran/nvm.fish?tab=readme-ov-file)

for bun follow this: [here](https://bun.sh/docs/installation)

for zed follow this: [here](https://zed.dev/docs/getting-started)
