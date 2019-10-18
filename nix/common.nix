{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Remove systemd log on boot
  boot.kernelParams=["quiet"];
  boot.consoleLogLevel=0;

  environment.systemPackages = with pkgs; [
    autojump
    bc
    # command-not-found # don't work
    curl
    dtrx
    fuse
    git
    htop
    ncdu
    ranger
    vim
    neovim
    wget
    woof
    zsh
  ];
  services.openssh.enable = true;
}
