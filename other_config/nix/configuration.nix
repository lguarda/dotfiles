{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./laptop_i3.nix
      ./hardware-configuration.nix
    ];
}

