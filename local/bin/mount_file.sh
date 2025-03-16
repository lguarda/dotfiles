#!/usr/bin/env bash

# Shoud be ran as root

file_partition_setup() {
    file_name=$1
    directory=$2
    file_size=$3
    loop_dev=$(losetup -f)

    if [ -e ${directory} ]; then
        mv ${directory} ${directory}.bk
    fi

    fallocate -l${file_size} ${file_name}
    dd bs=$(stat -c "%B" ${file_name}) count=$(stat -c "%b" ${file_name}) if=/dev/zero of=${file_name}

    mkdir -p ${directory}
    losetup ${loop_dev} ${file_name}
    mkfs.ext4 ${loop_dev}
    mount ${loop_dev} ${directory}

    # return loop_dev for file_partition_teardown
    echo ${loop_dev}
}

file_partition_teardown() {
    umount --lazy ${directory}
    losetup -d ${loop_dev}
    dd bs=$(stat -c "%B" ${file_name}) count=$(stat -c "%b" ${file_name}) if=/dev/zero of=${file_name}

    truncate --size=0 ${file_name}
    rm -f ${file_name}
    rm -rf ${directory}

    if [ -e ${directory}.bk ]; then
        mv ${directory}.bk ${directory}
    fi
    sync
}

# raw example usage
# sudo bash -c ". ./mount_file.sh && file_partition_setup /tmp/toto.img /tmp/toto 3G && file_partition_teardown"
# This will mout the file /tmp/toto.img into /tmp/toto with 3Gbytes with ext4 partition
