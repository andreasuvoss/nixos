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

  # Apps
  apps.enable = false;
}
