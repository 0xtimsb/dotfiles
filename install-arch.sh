#!/bin/bash

cleanup() {
    echo "cleaning up..."
    umount -R /mnt 2>/dev/null
    cryptsetup close cryptroot 2>/dev/null
    echo "cleanup done"
}

# trap to call cleanup function if script exits unexpectedly
trap cleanup EXIT

echo "installing arch linux"

# initialize password variables
DISK_PASSWORD=""
USER_PASSWORD=""
ROOT_PASSWORD=""

# set keyboard layout
KEY_LAYOUT="us"
loadkeys "$KEY_LAYOUT"
echo "using $KEY_LAYOUT for keyboard layout"
# loadkeys sets the keyboard layout for the current session
# "$KEY_LAYOUT" is the variable containing the desired layout (e.g., "us" for US English)

# specify the disk to be used for installation
DISK="/dev/sda"
echo "using $DISK as disk"
# "/dev/sda" typically refers to the first SATA drive in the system

# specify the kernel to be installed
KERNEL="linux"
echo "using $KERNEL as kernel"
# "linux" is the standard Arch Linux kernel package

# set the system locale
LOCALE="en_US.UTF-8"
echo "using $LOCALE as locale"
# "en_US.UTF-8" is a common locale for US English with UTF-8 encoding

# set the hostname for the new system
HOSTNAME="blue"
echo "using $HOSTNAME as hostname"
# "blue" will be the network name of the computer

# set the username for the new user account
USER_NAME="tims"
echo "using $USER_NAME as username"
# "tims" will be the name of the non-root user account to be created

# set microcode variable based on CPU type
MICROCODE="intel-ucode"
echo "using $MICROCODE as microcode"
# this line sets the MICROCODE variable to "intel-ucode"
# it can be changed to "amd-ucode" for AMD processors

# wipe the disk
echo "wiping disk $DISK"
wipefs -af "$DISK" &>/dev/null
# wipefs -a removes all signatures from the device
# -f forces wiping, even if the filesystem is mounted
# &>/dev/null suppresses output

sgdisk -Zo "$DISK" &>/dev/null
# sgdisk -Z zaps (destroys) all existing partitions
# -o creates a new empty GPT partition table
# &>/dev/null suppresses output

# create new partitions
echo "creating new partitions on $DISK"

parted -s "$DISK" \
mklabel gpt \
mkpart ESP fat32 1MiB 1025MiB \
set 1 esp on \
mkpart CRYPTROOT 1025MiB 100%
# parted is used for partition manipulation
# -s runs in script mode (non-interactive)
# mklabel gpt creates a new GPT partition table
# creates a new partition named ESP, formatted as fat32
# starts at 1MiB and ends at 1025MiB
# sets the esp (EFI System Partition) flag on the first partition
# creates a new partition named CRYPTROOT
# starts at 1025MiB and uses the rest of the disk (100%)

# define variables for the ESP (EFI System Partition) and CRYPTROOT partitions
ESP="/dev/disk/by-partlabel/ESP"
CRYPTROOT="/dev/disk/by-partlabel/CRYPTROOT"

# inform the kernel about disk changes
echo "informing the kernel about the disk changes"
partprobe "$DISK"
# partprobe informs the operating system kernel of partition table changes,
# by requesting that the operating system re-read the partition table

# format the ESP partition as FAT32
echo "formatting $ESP as fat32"
mkfs.fat -F 32 "$ESP" &>/dev/null
# mkfs.fat creates a FAT filesystem
# -F 32 specifies FAT32 format
# &>/dev/null redirects both stdout and stderr to /dev/null (suppresses output)

# set up LUKS (Linux Unified Key Setup) container for CRYPTROOT
echo "setting up LUKS container for $CRYPTROOT"
echo -n "$DISK_PASSWORD" | cryptsetup luksFormat "$CRYPTROOT" -d - &>/dev/null
# echo -n "$DISK_PASSWORD" outputs the disk password without a newline
# | pipes the password to cryptsetup
# cryptsetup luksFormat creates a LUKS encrypted container
# -d - reads the password from stdin
# &>/dev/null suppresses output

# open the LUKS container
echo -n "$DISK_PASSWORD" | cryptsetup open "$CRYPTROOT" cryptroot -d -
# cryptsetup open opens the LUKS container
# cryptroot is the name given to the opened LUKS container

# define the path for the opened LUKS container
BTRFS="/dev/mapper/cryptroot"
# this path will be used for further operations on the encrypted partition

# format the LUKS container as btrfs
echo "formating lukes container as btrfs"
mkfs.btrfs "$BTRFS" &>/dev/null
# mkfs.btrfs creates a btrfs filesystem on the LUKS container
# &>/dev/null suppresses all output

# mount the btrfs filesystem
mount "$BTRFS" /mnt
# mounts the btrfs filesystem to /mnt

# create btrfs subvolumes
echo "creating btrfs subvolumes"
subvols=(snapshots var_pkgs var_log home root srv)
# defines an array of subvolume names

# loop through subvolumes and create them
for subvol in '' "${subvols[@]}"; do
    btrfs su cr /mnt/@"$subvol" &>/dev/null
done
# for loop iterates through the subvols array and an empty string
# btrfs su cr creates a btrfs subvolume
# /mnt/@"$subvol" is the path for each subvolume, with @ prefix
# &>/dev/null suppresses all output
# this creates subvolumes: @, @snapshots, @var_pkgs, @var_log, @home, @root, @srv

# unmount the previously mounted filesystem
echo "mounting the newly created subvolumes"
umount /mnt

# define mount options for btrfs
mountopts="ssd,noatime,compress-force=zstd:3,discard=async"
# ssd: optimizes for SSD
# noatime: don't update access times for better performance
# compress-force=zstd:3: use zstd compression at level 3
# discard=async: enables TRIM for SSDs

# mount the root subvolume
mount -o "$mountopts",subvol=@ "$BTRFS" /mnt

# create necessary directories
mkdir -p /mnt/{home,root,srv,.snapshots,var/{log,cache/pacman/pkg},boot}

# mount other subvolumes
for subvol in "${subvols[@]:2}"; do
    mount -o "$mountopts",subvol=@"$subvol" "$BTRFS" /mnt/"${subvol//_//}"
done
# loops through subvolumes starting from the third element
# mounts each subvolume to its corresponding directory
# ${subvol//_//} replaces underscores with slashes in subvolume names

# set permissions for /root
chmod 750 /mnt/root

# mount snapshots and package cache subvolumes
mount -o "$mountopts",subvol=@snapshots "$BTRFS" /mnt/.snapshots
mount -o "$mountopts",subvol=@var_pkgs "$BTRFS" /mnt/var/cache/pacman/pkg

# disable copy-on-write for /var/log
chattr +C /mnt/var/log

# mount the EFI System Partition
mount "$ESP" /mnt/boot/

# install base system packages
echo "installing base system"
pacstrap -K /mnt base "$KERNEL" "$MICROCODE" linux-firmware "$KERNEL"-headers sbctl btrfs-progs grub grub-btrfs rsync efibootmgr snapper reflector snap-pac zram-generator sudo 
# pacstrap installs packages to the new system
# -K is used to initialize the pacman keyring
# /mnt is the target directory
# the rest are packages to be installed
# &>/dev/null suppresses all output

# set hostname
echo "$HOSTNAME" > /mnt/etc/hostname
# writes the hostname to /etc/hostname in the new system

# generate fstab
echo "generate fstab"
genfstab -U /mnt >> /mnt/etc/fstab
# genfstab generates a fstab file
# -U uses UUIDs for source identifiers
# >> appends the output to /mnt/etc/fstab

# configure locale and keymap
echo "configure locale and keymap"
sed -i "/^#$LOCALE/s/^#//" /mnt/etc/locale.gen
# uncomments the specified locale in /etc/locale.gen
echo "LANG=$LOCALE" > /mnt/etc/locale.conf
# sets the system language
echo "KEYMAP=$KEY_LAYOUT" > /mnt/etc/vconsole.conf
# sets the keyboard layout

# configure hosts file
echo "configure hosts file"
cat > /mnt/etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain   $HOSTNAME
EOF
# creates /etc/hosts file with localhost and hostname entries

# install network packages
echo "installing network packages"
pacstrap /mnt wpa_supplicant dhcpcd 
# pacstrap installs packages to the new system
# wpa_supplicant and dhcpcd are network-related packages
# >/dev/null redirects stdout to /dev/null (suppresses output)

# install additional packages
echo "installing additional packages"
pacstrap /mnt stow sway swaylock swayidle swaybg foot wmenu xorg-xwayland mako wl-clipboard grim slurp fish neovim

# enable network services
systemctl enable wpa_supplicant --root=/mnt &>/dev/null
systemctl enable dhcpcd --root=/mnt &>/dev/null
# enables wpa_supplicant and dhcpcd services to start on boot
# --root=/mnt specifies the root directory for the new system
# &>/dev/null suppresses all output

# moving dotfiles to the new system
echo "moving dotfiles to the new system ansd setting up stow"
cp -r /dotfiles /mnt/root/dotfiles
arch-chroot /mnt /bin/bash -c "mkdir -p /root/.config"
arch-chroot /mnt /bin/bash -c "cd /root/dotfiles && stow -v -t /root/.config -d .config ."

echo "config files have been linked!"

# configure mkinitcpio.conf
echo "configuring /etc/mkinitcpio.conf"
cat > /mnt/etc/mkinitcpio.conf <<EOF
HOOKS=(systemd autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems)
EOF
# writes the specified HOOKS to /mnt/etc/mkinitcpio.conf
# these hooks are used to build the initial ramdisk environment

# set up GRUB configuration
echo "setting up grub config"
UUID=$(blkid -s UUID -o value $CRYPTROOT)
# gets the UUID of the CRYPTROOT partition

sed -i "\,^GRUB_CMDLINE_LINUX=\"\",s,\",&rd.luks.name=$UUID=cryptroot root=$BTRFS," /mnt/etc/default/grub
# modifies /mnt/etc/default/grub
# adds kernel parameters for LUKS encryption and root filesystem
# rd.luks.name=$UUID=cryptroot specifies the LUKS container
# root=$BTRFS specifies the root filesystem

echo "configuring the system (timezone, system clock, initramfs, snapper, grub)"
arch-chroot /mnt /bin/bash -e <<EOF

    # setting up timezone
    ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime &>/dev/null
    # creates a symlink to set the timezone based on IP geolocation

    # setting up clock
    hwclock --systohc
    # sets the system clock from the hardware clock

    # generating locales
    locale-gen &>/dev/null
    # generates locales specified in /etc/locale.gen

    # create secureboot keys
    sbctl create-keys
    # creates keys for secure boot

    # generating a new initramfs
    mkinitcpio -P &>/dev/null
    # generates initial ramdisk environments for all presets

    # snapper configuration
    umount /.snapshots
    rm -r /.snapshots
    snapper --no-dbus -c root create-config /
    btrfs subvolume delete /.snapshots &>/dev/null
    mkdir /.snapshots
    mount -a &>/dev/null
    chmod 750 /.snapshots
    # configures snapper for system snapshots

    # installing grub
    grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB &>/dev/null
    # installs GRUB bootloader for UEFI systems

    # creating grub config file
    grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null
    # generates GRUB configuration file

EOF

# set root password
echo "setting root password"
echo "root:$ROOT_PASSWORD" | arch-chroot /mnt chpasswd
# echo "root:$ROOT_PASSWORD" creates a string with the format "root:password"
# | pipes this string to the chpasswd command
# arch-chroot /mnt runs the command in the /mnt environment
# chpasswd changes the password for the specified user (root in this case)

# add user with root privileges
echo "adding user $USER_NAME to the system with root privilege."
echo "%wheel ALL=(ALL:ALL) ALL" > /mnt/etc/sudoers.d/wheel
# this line adds a sudoers configuration allowing members of wheel group to use sudo
# > redirects the output to the file /mnt/etc/sudoers.d/wheel

# create new user
arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$USER_NAME"
# arch-chroot /mnt runs the command in the /mnt environment
# useradd creates a new user
# -m creates the user's home directory
# -G wheel adds the user to the wheel group
# -s /bin/bash sets the user's login shell to bash
# "$USER_NAME" is the name of the new user

# set password for new user
echo "setting user password for $USER_NAME"
echo "$USER_NAME:$USER_PASSWORD" | arch-chroot /mnt chpasswd
# echo "$USER_NAME:$USER_PASSWORD" creates a string with the format "username:password"
# | pipes this string to the chpasswd command
# arch-chroot /mnt runs the command in the /mnt environment
# chpasswd changes the password for the specified user

# create directory for pacman hooks
echo "configuring /boot backup when pacman transactions are made."
mkdir /mnt/etc/pacman.d/hooks

# create a pacman hook for backing up /boot
cat > /mnt/etc/pacman.d/hooks/50-bootbackup.hook <<EOF
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Path
Target = usr/lib/modules/*/vmlinuz

[Action]
Depends = rsync
Description = Backing up /boot...
When = PostTransaction
Exec = /usr/bin/rsync -a --delete /boot /.bootbackup
EOF
# this hook creates an automatic backup of the /boot directory
# it triggers on upgrade, install, or remove operations
# specifically when changes occur in the kernel (vmlinuz)
# the action depends on rsync being installed
# it runs after the transaction (PostTransaction)
# it uses rsync to create a mirror of /boot in /.bootbackup
# -a preserves all file attributes and recursively copies
# --delete removes files in the destination that aren't in the source
# this ensures /.bootbackup is an exact copy of /boot after each relevant pacman operation

# configure zram
echo "configuring zram"
cat > /mnt/etc/systemd/zram-generator.conf <<EOF
[zram0]
zram-size = min(ram, 8192)
EOF
# creates a zram configuration file
# sets zram size to the minimum of available RAM or 8192 MB

# enable various services
echo "enabling reflector, automatic snapshots, btrfs scrubbing and systemd-oomd"
services=(reflector.timer snapper-timeline.timer snapper-cleanup.timer btrfs-scrub@-.timer btrfs-scrub@home.timer btrfs-scrub@var-log.timer btrfs-scrub@\\x2esnapshots.timer grub-btrfsd.service systemd-oomd)
# defines an array of services to be enabled

# loop through services and enable them
for service in "${services[@]}"; do
    systemctl enable "$service" --root=/mnt &>/dev/null
done
# iterates through the services array
# systemctl enable activates each service to start on boot
# --root=/mnt specifies the root directory for the new system
# &>/dev/null suppresses all output

# the enabled services include:
# - reflector: for updating mirrorlists
# - snapper: for automatic snapshots and cleanup
# - btrfs-scrub: for filesystem integrity checks
# - grub-btrfsd: for GRUB with btrfs
# - systemd-oomd: for out-of-memory daemon

# set fish as default shell for user
echo "setting fish as default shell for $USER_NAME"
arch-chroot /mnt chsh -s /usr/bin/fish $USERNAME

echo "done!"

exit