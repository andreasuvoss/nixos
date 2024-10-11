{ lib, pkgs, nixpkgs, inputs, ... }:
let
  username = "andreasvoss";
in
{
  imports = [
    ../../modules/home
  ];
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.05";
    packages = with pkgs; [
      dconf
      brightnessctl
    ];
  };


  services.pulseeffects.enable = true;

  # Desktop
  desktop.enable = true;
  hyprland.wlogout.command = "wlogout -b 6 -s -R 300 -L 300 -T 500 -B 500";
  hyprland.natural_scroll = true;
  hyprland.monitor = [
    # "eDP-1,highrr,auto,auto"
    "eDP-1,2880x1800@120.0,0x0,1.5"
    "Unknown-1,disable"
  ];

  # CLIS
  clis.enable = true;

  # Apps
  apps.enable = true;

  # Scripts
  scripts.enable = false;

  # Development tools
  dotnet.enable = true;
  rust.enable = true;
  golang.enable = true;

  # Disable a few things
  megasync.enable = lib.mkForce false;
  discord.enable = lib.mkForce false;
  signal.enable = lib.mkForce false;
}
