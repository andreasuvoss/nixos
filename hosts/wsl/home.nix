{ lib, pkgs, nixpkgs, ... }:
let
  username = "nixos";
in
{
  imports = [
    ../../modules/home
  ];
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  home.packages = with pkgs; [
    wl-clipboard
  ];
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.05";
  };

  # CLIS
  clis.enable = true;

  # Development tools
  dotnet.enable = true;
  rust.enable = true;
  golang.enable = true;
}
