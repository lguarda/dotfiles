{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./common.nix
    ./gui/common_gui.nix
    ./gui/i3wm.nix
    ./system/boot/grub_default.nix
  ];

  services.openssh.permitRootLogin = "yes"; # disable after full install

  programs.fish.enable = true;
  users.extraUsers.leo = {
    isNormalUser = true;
    home = "/home/leo";
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    password = ""; # remember to passwd
    shell = pkgs.fish;
  };
}
