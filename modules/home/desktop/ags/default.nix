{ inputs, pkgs, lib, config, ... }:
{
  options = {
    ags.enable = lib.mkEnableOption "enable ags";
  };
  imports = [
    inputs.ags.homeManagerModules.default
  ];
  config = lib.mkIf config.ags.enable {
    home.packages = [ inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.io ];
    # For development purposes I keep these
    programs.ags = {
      enable = true;
      extraPackages = with pkgs; [
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.battery
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.cava
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.mpris
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.tray
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.network
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.battery
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.bluetooth
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.wireplumber
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.notifd
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.io
        fzf
      ];
    };
  };
}