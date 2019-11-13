#!/usr/bin/env bash

SCRIPT_DIR=$( cd ${0%/*} && pwd -P )

mount /dev/fde/root /mnt
mkdir -p /mnt/boot/ /mnt/home
mount /dev/fde/home /mnt/home
mount /dev/sda1 /mnt/boot
if [ ! -z $USE_SWAP ];then
    swapon /dev/fde/swap
fi

# generate /etc/nixos/{configuration.nix,hardware-configuration.nix}
nixos-generate-config --root /mnt

cp -R ${SCRIPT_DIR}/../* /mnt/etc/nixos/
