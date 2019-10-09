{ config, pkgs, ... }:

{
  imports =
    [
      ./common_audio.nix
    ];
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 35;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    arandr
    feh
    scrot
    shutter
    xclip
    xorg.xbacklight
    xorg.xinput
    firefox
    #zenity
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.config.firefox = {
    enableAdobeFlash = true;
  };
}
