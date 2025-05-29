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
  };

  # Desktop
  desktop.enable = true;

  # CLIS
  clis.enable = true;

  # Apps
  apps.enable = true;
  jetbrains-gateway.enable = true;

  # Scripts
  scripts.enable = true;

  # Development tools
  rust.enable = true;
  golang.enable = true;
}
