#!/usr/bin/env bash

ME="${0##*/}"
params="$(getopt -o d:p:b:r:s:h --long device:,root:,passphrase:,boot_size:,swap_size,help --name "$0" -- "$@")"
eval set -- "$params"

BOOT_SIZE="512Mib"
DEVICE=/dev/sda
PART_PREFIX=""


_usage() {
    cat << _END_OF_USAGE_
    Usage: ${ME} OPTIONS...

    Setup basic crypted partition

    Options:
    -d, --device      device to use (default: $DEVICE)
    -r, --root_size   Root logical partition size (mandadory)
    -b, --boot_size   Boot logical partition size (default: $BOOT_SIZE)
    -s, --swap_size   Swap logical partition size sould be equals to the ram (default: None)
    -p, --passpharse  Disk encryption passphrase (whith this param the script set up a full disk encryption)
    -h, --help        Display this help and exit

    Exemple:
    ./part.sh -p :root: -b 500MIB -r 20GIB -s 10GIB

_END_OF_USAGE_
}

while true
do
    case "$1" in
        -d|--device)
            shift
            DEVICE=$1
            if [[ $DEVICE == *"nvme"* ]]; then
                PART_PREFIX="p"
            fi
            ;;
        -r|--root_size)
            shift
            ROOT_SIZE=$1
            ;;
        -p|--passpharse)
            shift
            PASSPHRASE=$1
            ;;
        -b|--boot_size)
            shift
            BOOT_SIZE=$1
            ;;
        -s|--swap_size)
            shift
            export USE_SWAP=1
            SWAP_SIZE=$1
            ;;
        -h|--help)
            _usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            _usage
            exit 1
            ;;
    esac
    shift
done

if [ -z "$ROOT_SIZE" ];then
    echo "Argument root_size is mandatory" >&2
    EXIT=1
fi

if [ ! -z $EXIT ];then
    exit $EXIT
fi

echo "This script will:"
if [ -n "$PASSPHRASE" ];then
    echo "Create the partions inside a full disk encryption (fde) with the passphrase :{$PASSPHRASE}"
fi
echo "Create a root partition with the size $ROOT_SIZE"
echo "Create a boot partition with the size $BOOT_SIZE"
if [ -n "$SWAP_SIZE" ];then
    echo "Create a swap partition with the size $SWAP_SIZE"
fi
echo "on the device $DEVICE"
read -p "Are you sure? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Basic example for creating *standard* linux partitions
yes | parted ${DEVICE} -- mklabel gpt
# create boot partition
if [ -n "${USE_BIOS}"]; then
    yes | parted /dev/sda -- mkpart ext2 primary ${BOOT_SIZE}MiB 100%
    # add boot flag to the boot partition
    yes | parted /dev/sda set 1 boot on
else
    yes | parted ${DEVICE} -- mkpart ESP fat32 1MiB ${BOOT_SIZE}
    # add boot flag to the efi boot partition
    yes | parted ${DEVICE} -- set 1 esp on
fi

# use the rest for lvm partition
yes | parted ${DEVICE} -- mkpart primary ${BOOT_SIZE}MiB 100%

if [ -n "$PASSPHRASE" ];then
    LVM_NAME="fde"
    # setup encryption on for the entire lvm
    echo -n $PASSPHRASE | cryptsetup luksFormat "${DEVICE}${PART_PREFIX}2" --key-file -
    # open encrypted partition
    echo -n $PASSPHRASE | cryptsetup luksOpen "${DEVICE}${PART_PREFIX}2" crypted --key-file -
    # start lvm partition
    pvcreate /dev/mapper/crypted
    # create lvm partition named $LVM_NAME
    vgcreate $LVM_NAME /dev/mapper/crypted
else
    LVM_NAME="pool"
    # start lvm partition
    pvcreate "${DEVICE}${PART_PREFIX}2"
    # create lvm partition named $LVM_NAME
    vgcreate $LVM_NAME "${DEVICE}${PART_PREFIX}2"
fi

# create lvm sub partition
if [ -n "$SWAP_SIZE" ];then
    lvcreate -n swap $LVM_NAME -L ${SWAP_SIZE} #8GB
fi
lvcreate -n root $LVM_NAME -L ${ROOT_SIZE} #8GB
lvcreate -n home $LVM_NAME -l 100%FREE

yes | mkfs.ext4 /dev/$LVM_NAME/root
yes | mkfs.ext4 /dev/$LVM_NAME/home
if [ -n "$SWAP_SIZE" ];then
    mkswap /dev/$LVM_NAME/swap
fi
