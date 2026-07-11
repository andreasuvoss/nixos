{ config, lib, pkgs, nixpkgs, inputs, ... }:
let
  username = "andreasvoss";
  ssh-key = "andreasvoss+2026@argon";
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
    defaultSopsFile = ./secrets/secrets.yaml;

    secrets."ssh-config" = {
      path = "${config.home.homeDirectory}/.ssh/config";
    };

    secrets."ssh-keys/${ssh-key}" = {
      path = "${config.home.homeDirectory}/.ssh/${ssh-key}";
    };

    secrets."ssh-keys/${ssh-key}.pub" = {
      path = "${config.home.homeDirectory}/.ssh/${ssh-key}.pub";
    };
  };

  git.signingkey = "${ssh-key}.pub";

  # Desktop
  desktop.enable = true;

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