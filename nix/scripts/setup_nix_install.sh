mount /dev/fde/root /mnt
mkdir -p /mnt/boot/ /mnt/home
mount /dev/fde/home /mnt/home
mount /dev/sda1 /mnt/boot
# generate /etc/nixos/{configuration.nix,hardware-configuration.nix}
nixos-generate-config --root /mnt
