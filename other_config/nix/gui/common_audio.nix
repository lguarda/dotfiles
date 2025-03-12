{ config, pkgs, ... }:

{
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.support32Bit = true;

  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
