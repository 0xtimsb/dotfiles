1. as root:

```
apt update
apt upgrade
apt install sudo
usermod -aG sudo <username>
```

2. reboot

3. as user:

```
sudo apt install git
git clone https://github.com/0xtimsb/dotfiles.git
cd dotfiles
```

4. nuke!

```
./install.sh
```

# More

- i have added `xwayland` so that apps that are only X11 compatible can still run. though, only a few apps are X11 only. most apps are wayland compatible. some of them needs `--ozone-platform=wayland` flag to run in wayland. i have added this flag to the `.desktop` files of those apps. you can check if any app is running using xwayland by `xlsclients`. if it is running using xwayland, it will show up in this list. if you are not using any X11 only app, you can remove `xwayland` by `sudo apt remove xwayland`.

apps that are X11 only:

- mongodb-compass

apps that supports wayland but needs `--ozone-platform=wayland` flag:

- code
- spotify
- slack

apps that supports wayland out of the box:

- vlc
- firefox
- kitty
- transmission-gtk
