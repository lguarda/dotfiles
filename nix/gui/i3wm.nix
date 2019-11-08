{ config, pkgs, ... }:

{
  services.xserver.windowManager.i3.enable = true;

  # disable default dm in order to use i3 as default at the first startup
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.desktopManager.default = "none";

  environment.systemPackages = with pkgs; [
    i3blocks
    i3lock
  ];
}
