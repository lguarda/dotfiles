{ config, pkgs, ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Open fde at the end of boot
  boot.initrd.luks.devices = [
    { name = "crypted"; device = "/dev/sda2"; preLVM = true; }
  ];
}
