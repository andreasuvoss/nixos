{
  lib,
  pkgs,
  nixpkgs,
  inputs,
  ...
}:
let
  username = "andreasvoss";
in
{
  imports = [ ../../modules/home ];
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

  services.easyeffects = {
    enable = true;
    preset = "DolbyMovie";
    package = pkgs.easyeffects;
  };

  # services.pulseeffects.enable = true;

  # Work specific apps
  postman.enable = true;
  azuredatastudio.enable = true;
  _1password.enable = false;

  # Desktop
  desktop.enable = true;
  hyprland.wlogout.command = "wlogout -b 6 -s -R 300 -L 300 -T 500 -B 500";
  hyprland.startTeams = true;
  hyprland.enableKanshi = true;
  hyprland.natural_scroll = true;
  hyprland.monitor = [
    # "eDP-1,highrr,auto,auto"
    "eDP-1,2880x1800@120.0,0x0,1.5"
    "Unknown-1,disable"
  ];

  teams.enable = lib.mkForce true;

  # Kanshi
  services.kanshi = {
    # systemdTarget = "";
    enable = true;
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.5;
            mode = "2880x1800@120Hz";
            status = "enable";
          }
        ];
        # profile.exec = [ "${pkgs.freetube}/bin/freetube" ];
      }
      {
        profile.name = "docked-at-work";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.5;
            mode = "2880x1800@120Hz";
            status = "disable";
          }
          {
            # criteria = "DP-1";
            criteria = "Dell Inc. Dell U4924DW 68JT0S3";
            status = "enable";
          }
        ];
      }
    ];
  };

  # CLIS
  clis.enable = true;

  # Apps
  apps.enable = true;
  firefox.workExtensions = true;

  # Scripts
  scripts.enable = true;

  # Development tools
  dotnet.enable = true;
  rust.enable = true;
  golang.enable = true;

  # Disable a few things
  megasync.enable = lib.mkForce false;
  discord.enable = lib.mkForce false;
  signal.enable = lib.mkForce false;
}
