{ lib, pkgs, nixpkgs, inputs, ... }:
let
  username = "andreasvoss";
in
{
  imports = [
    ../../modules/home
    inputs.ags.homeManagerModules.default
  ];
  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.hyprland
      inputs.ags.packages.${pkgs.system}.tray
      inputs.ags.packages.${pkgs.system}.network
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.bluetooth
      inputs.ags.packages.${pkgs.system}.wireplumber
      inputs.ags.packages.${pkgs.system}.notifd
      inputs.ags.packages.${pkgs.system}.io
      fzf
    ];
  };
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
  swayidle.enableWorkaround = true;
  # rider.enable = lib.mkForce false;

  # CLIS
  clis.enable = true;

  # Apps
  apps.enable = true;
  jetbrains-gateway.enable = true;

  # Scripts
  scripts.enable = true;

  # Development tools
  dotnet.enable = true;
  rust.enable = true;
  golang.enable = true;
}
