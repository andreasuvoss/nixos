{ config, lib, pkgs, nixpkgs, inputs, ... }:
let
  username = "andreasvoss";
in
{
  imports = [
    ../../modules/home
    inputs.sops-nix.homeManagerModules.sops
  ];
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.05";
  };

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets."sensitive-abbrs" = {
      path = "${config.home.homeDirectory}/.config/fish/sensitive.fish";
    };
  };

  # Desktop
  desktop.enable = true;
  swaync.enable = lib.mkForce false;

  # CLIS
  clis.enable = true;

  # Apps
  apps.enable = true;

  # Scripts
  scripts.enable = true;

  # Development tools
  rust.enable = true;
  golang.enable = true;
}