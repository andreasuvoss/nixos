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
  keychain.enable = true;
  keychain.keyfile = "id_ed25519";
  git.signingkey = "id_ed25519.pub";

  # Disable stuff I do not need here
  nodejs.enable = lib.mkForce false;
  taskwarrior.enable = lib.mkForce false;
  tldr.enable = lib.mkForce false;
  tmux.enable = lib.mkForce false;

  # Apps
  apps.enable = false;
}