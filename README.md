```
sudo apt install neovim git \
fuse syncthing alacritty \
vlc transmission-gtk curl \
zoxide calibre stow build-essential
```

for rust, [here](https://rustup.rs/)

for fish, [here](https://github.com/fish-shell/fish-shell)

fish as default:

```
chsh -s /usr/bin/fish
```

for node on fish, install [fisher](https://github.com/jorgebucaran/fisher) and [nvm.fish](https://github.com/jorgebucaran/nvm.fish?tab=readme-ov-file)

for bun follow this: [here](https://bun.sh/docs/installation)

for zed follow this: [here](https://zed.dev/docs/getting-started)

for git follow this: [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

note use this for fish (c instead of s): `eval "$(ssh-agent -c)"`

run the install script:

```
cd ~/dotfiles
./install.sh
```
