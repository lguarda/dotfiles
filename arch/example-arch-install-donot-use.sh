#!/usr/bin/env bash

# This script is based on the following
# See https://wiki.archlinux.org/title/User:ZachHilman/Installation_-_Btrfs_%2B_LUKS2_%2B_Secure_Boot#Start
# The difference is that here its grub+luks1+btrfs and swap setup for hibernation

# You can embed this script with xorriso like so:
# xorriso  -dev archlinux-x86_64.iso -boot_image any keep -cpr ~/lol/arch_scripts/arch_luks_btrfs.sh /
# Then you will find it here /run/archiso/bootmnt/arch_luks_btrfs.sh

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

yn() {
    if [ -n "${AUTO}" ]; then
        return
    fi
    while true; do
        read -p "$1
        Please answer yes or no." yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) ;;
        esac
    done
}

yn "The install script should not be run as is do you have edited it to match your need?"

install_disk="${INSTALL_DISK:-/dev/sda}"
swap_space="${SWAP_SPACE:-2GiB}"

yn "The install script will run with the following parameter
    install_disk=${install_disk}
    swap_space=${swap_space}
    WARNING THIS WILL WIPE ${install_disk}"

sgdisk_args=(
    --clear
    # setup efi par of 512M
    --new=1:0:+512MiB --typecode=1:ef00 --change-name=1:EFI

    # setup swap the swap_space need to match you ram size
    --new=2:0:+${swap_space} --typecode=2:8200 --change-name=2:cryptswap

    # use the rest of the disk for the hole system
    --new=3:0:0 --typecode=3:8300 --change-name=3:cryptsystem

    ${install_disk}
)

sgdisk "${sgdisk_args[@]}"

sleep 2 # it take some time to create the partlabel link

echo Setup luks Encrypted Containers
# Create keyfile
root_key=/tmp/.root.key
swap_key=/tmp/.swap.key
openssl genrsa -out ${root_key} 4096
openssl genrsa -out ${swap_key} 4096
chmod 400 ${root_key}
chmod 400 ${swap_key}

# Create the encrypted system partition. Note that we explicitly specify LUKS1 it's mandatory for grub rd.luks
cryptsetup -q luksFormat --type luks1 /dev/disk/by-partlabel/cryptsystem

# Add key file for root in order to only type password one time in grub
cryptsetup luksAddKey /dev/disk/by-partlabel/cryptsystem ${root_key}

# Create the encrypted swap partition only with key-file.
cryptsetup -q luksFormat --type luks1 --key-file ${swap_key} /dev/disk/by-partlabel/cryptswap

# Open the new encrypted system partition.
cryptsetup open --key-file ${root_key} /dev/disk/by-partlabel/cryptsystem system
cryptsetup open --key-file ${swap_key} /dev/disk/by-partlabel/cryptswap swap

echo "Setup Swap"
# Make swap partition
mkswap -L swap /dev/mapper/swap
# Mount swap partition
swapon -L swap

# swapfile setup to support hibernation
# first create nested subvolume so it's automounted
# btrfs subvolume create /swap

# create the swap file it must be same size as ram
# btrfs filesystem mkswapfile --size 32g --uuid clear /swap/swapfile

# get swapfile offset
# btrfs inspect-internal map-swapfile -r /swap/swapfile

# add this to /etc/fstab
# /swap/swapfile          none            swap            defaults 0 0
#
# and add this to GRUB_CMDLINE_LINUX_DEFAULT where offset is the result of the btrfs inspect-internal command
#
# resume=/dev/mapper/system resume_offset=<offset>


echo "Setup Btrfs"
# This section need to be edited
yn "Have you check the btrfs mount option?"

#Create the filesystem
mkfs.btrfs --label system /dev/mapper/system

#Mount at root
mount -t btrfs LABEL=system /mnt

# see ./btrfs-layout.md
# root
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@root_snapshots
# home
btrfs subvolume create /mnt/@project
btrfs subvolume create /mnt/@project_snapshots
btrfs subvolume create /mnt/@steam
btrfs subvolume create /mnt/@home_cache
btrfs subvolume create /mnt/@downloads
btrfs subvolume create /mnt/@home_other
btrfs subvolume create /mnt/@home_snapshots

#Unmount root so we can change mount options
umount -R /mnt
mount_btfs () {
    mount -t btrfs -o "defaults,${1},subvol=${2}" "LABEL=system" "/mnt${3}"
}

mount_btfs "x-mount.mkdir,ssd,noatime" @root /
mount_btfs "x-mount.mkdir,ssd,noatime" @root_snapshots /.snapshots

mount_btfs "x-mount.mkdir,compress=zstd,ssd,noatime" @home /home
mount_btfs "x-mount.mkdir,compress=zstd,ssd,noatime" @home_snapshots /home/.snapshots
mount_btfs "x-mount.mkdir,compress=zstd,ssd,noatime" @var /var

echo "Setup EFI System Partition"
# Format the partition as FAT-32, with label 'EFI'
mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI

# Make the mount directory
mkdir /mnt/efi

# Mount the ESP
mount LABEL=EFI /mnt/efi

# Install Base System
pacstrap /mnt base linux linux-firmware grub efibootmgr networkmanager less ncdu vim neovim btrfs-progs dosfstools pkgfile zsh htop

#Generate the filesystem table. Unlike the default installation guide, we choose to use labels instead of UUIDs for mounts.
genfstab -L -p /mnt >> /mnt/etc/fstab

ln -sf /usr/share/zoneinfo/Europe/Paris /mnt/etc/localtime

echo "Setup grub with luks unlocking"

# Extract uuid of system and swap partition
uuid=$(blkid -o value -s UUID /dev/disk/by-partlabel/cryptsystem)
uuid_swap=$(blkid -o value -s UUID /dev/disk/by-partlabel/cryptswap)

# WARNING i think the mkinitcpio hook ise useless for root it try to use it for swap unlocking on hibernate but it doesn't work
# This will enable mkinitcpio to add keyfile into the intramfs this is mandatory to avoid typing luks pass twice
sed -i 's/^FILE.*/FILES=(\/.root.key \/.swap.key)/' /mnt/etc/mkinitcpio.conf

# This will configure intiramfs upon mkinitcpio
sed -i 's/^HOOKS.*/HOOKS=(base systemd autodetect modconf kms block keyboard sd-encrypt filesystems fsck)/' /mnt/etc/mkinitcpio.conf

# This line enalbe grub to open luks
sed -i 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/' /mnt/etc/default/grub

# Allow grub to open luks with key file
grub_cmd_line="quiet rd.luks.name=${uuid}=system root=/dev/mapper/system rootflags=subvol=@root rd.luks.key=${uuid}=/.root.key rd.luks.name=${uuid_swap}=swap rd.luks.key=${uuid_swap}=/.swap.key resume=/dev/mapper/swap"
grub_cmd_line=$(echo "GRUB_CMDLINE_LINUX_DEFAULT=\"${grub_cmd_line}\"" | sed 's/\//\\\//g')
sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT.*/${grub_cmd_line}/" /mnt/etc/default/grub

echo "swap /dev/disk/by-partlabel/cryptswap /.swap.key swap" >> /mnt/etc/crypttab

cp /mnt/etc/crypttab /mnt/etc/crypttab.initramfs
# copy luks key into the new arch system
cp ${root_key} /mnt
cp ${swap_key} /mnt

cat <<EOT >> /mnt/install
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
mkinitcpio -p linux
grub-mkconfig -o /boot/grub/grub.cfg

# Warning you will need to change root password when install is done
echo root:root | chpasswd

# init pacman so it will work on reboot
pacman-key --init
pacman-key --populate archlinux
pkgfile --update
EOT

chmod a+x /mnt/install

arch-chroot /mnt bash -e ./install

# if you are very confident you can uncomment this line
# reboot
