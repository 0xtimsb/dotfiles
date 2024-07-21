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
