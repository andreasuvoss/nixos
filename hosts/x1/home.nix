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
  desktop.enable = false;

  # CLIS
  clis.enable = true;

  # Apps
  apps.enable = false;

  # Scripts
  scripts.enable = true;

  # Development tools
  dotnet.enable = false;
  rust.enable = false;
  golang.enable = false;
}
