{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./common.nix
    ./gui/common_gui.nix
    ./gui/i3wm.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  # Open fde at the end of boot
  boot.initrd.luks.devices = [
    { name = "crypted"; device = "/dev/sda2"; preLVM = true; }
  ];
  services.openssh.permitRootLogin = "yes"; # disable after full install
  system.stateVersion = "19.03"; # Did you read the comment?

  programs.fish.enable = true;
  users.extraUsers.leo = {
    isNormalUser = true;
    home = "/home/leo";
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    password = ""; # remember to passwd
    shell = pkgs.fish;
  };
}
