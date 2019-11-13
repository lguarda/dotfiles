#!/usr/bin/env bash

ME="${0##*/}"
params="$(getopt -o p:b:r:s:h --long passpharse:,boot_size:,root_size:,swap_size,help --name "$0" -- "$@")"
eval set -- "$params"

_usage() {
    cat << _END_OF_USAGE_
    Usage: ${ME} OPTIONS...

    Setup basic crypted partition

    Options:
    -p, --passpharse    Disk encryption passphrase
    -b, --boot_size     Boot logical partition size
    -r, --root_size     Root logical partition size
    -s, --swap_size     Swap logical partition size
    -h, --help          Display this help and exit

    Exemple:
    ./part.sh -p :root: -b 500MIB -r 20GIB -s 10GIB

_END_OF_USAGE_
}

while true
do
    case "$1" in
        -p|--passpharse)
            shift
            PASSPHRASE=$1
            ;;
        -b|--boot_size)
            shift
            BOOT_SIZE=$1
            ;;
        -r|--root_size)
            shift
            ROOT_SIZE=$1
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

if [ -z $PASSPHRASE ];then
    echo "Argument passphrase is mandatory" >&2
    EXIT=1
fi
if [ -z $BOOT_SIZE ];then
    echo "Argument boot_size is mandatory" >&2
    EXIT=1
fi
if [ -z $ROOT_SIZE ];then
    echo "Argument root_size is mandatory" >&2
    EXIT=1
fi

if [ ! -z $EXIT ];then
    exit $EXIT
fi

# Basic example for creating *standard* linux partitions
# create MBR partitioning
yes | parted /dev/sda -- mklabel msdos
# create boot partition
yes | parted /dev/sda -- mkpart primary 1MiB ${BOOT_SIZE} # 512MiB
# use the rest for lvm partition
yes | parted /dev/sda -- mkpart primary ${BOOT_SIZE}MiB 100%
# add boot flag to the boot partition
yes | parted /dev/sda set 1 boot on

# setup encryption on for the entire lvm
echo -n $PASSPHRASE | cryptsetup luksFormat /dev/sda2 --key-file -
# open encrypted partition
echo -n $PASSPHRASE | cryptsetup luksOpen /dev/sda2 crypted --key-file -

# start lvm partition
pvcreate /dev/mapper/crypted
# create lvm partition named fde
vgcreate fde /dev/mapper/crypted
# create lvm sub partition
if [ -n $SWAP_SIZE ];then
    lvcreate -n swap fde -L ${SWAP_SIZE} #8GB
fi
lvcreate -n root fde -L ${ROOT_SIZE} #8GB
lvcreate -n home fde -l 100%FREE

# set boot partition to ext2
yes | mkfs.ext2 /dev/sda1
# other to ext4
yes | mkfs.ext4 /dev/fde/root
yes | mkfs.ext4 /dev/fde/home
if [ -n $SWAP_SIZE ];then
    mkswap /dev/fde/swap
fi
