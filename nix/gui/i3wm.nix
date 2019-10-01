{ config, pkgs, ... }:

{
  services.xserver.windowManager.i3.enable = true;
  environment.systemPackages = with pkgs; [
    i3blocks
    i3lock
  ];
}
