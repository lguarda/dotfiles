#/usr/bin/env bash

sgdisk -Z -n 1:0:+512M -t 1:ef00 -n 2:0:0 -t 2:8304 /dev/sda
mkfs.ext4 /dev/sda2
mkfs.fat -F 32 /dev/sda1

mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

pacstrap -K /mnt base base-devel linux linux-firmware efibootmgr sudo openssh grub networkmanager dnsmasq git nvim fish ncdu ranger
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
arch-chroot /mnt locale-gen
arch-chroot /mnt bash -c "echo 'LANG=en_US.UTF-8' > /etc/locale.conf"
arch-chroot /mnt bash -c "echo 'KEYMAP=en-us' > /etc/vconsole.conf"
arch-chroot /mnt bash -c "echo 'arch' > /etc/hostname"
arch-chroot /mnt mkinitcpio -P
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt bash -c "echo 'root:root' | chpasswd"

# git clone https://aur.archlinux.org/paru.git
# cd paru
# makepkg -si



