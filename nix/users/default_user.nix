{ config, pkgs, ... }:

{

  programs.fish.enable = true

  users.extraUsers.leo = {
    isNormalUser = true;
    home = "/home/leo";
    extraGroups = [ "wheel" "networkmanager" ];
    password = ""; # remember to passwd
    shell= pkgs.fish
  };

}
