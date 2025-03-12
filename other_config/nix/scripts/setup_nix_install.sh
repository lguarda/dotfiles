#!/usr/bin/env bash

SCRIPT_DIR=$( cd ${0%/*} && pwd -P )


mount ${ROOT_D} /mnt
mkdir /mnt/boot/ /mnt/home
mount ${HOME_D} /mnt/home
mount ${BOOT_D} /mnt/boot
if [ ! -z $USE_SWAP ];then
    swapon ${SWAP_D}
fi

# generate /etc/nixos/{configuration.nix,hardware-configuration.nix}
nixos-generate-config --root /mnt

cp -R ${SCRIPT_DIR}/../* /mnt/etc/nixos/
