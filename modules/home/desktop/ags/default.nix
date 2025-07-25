{ inputs, pkgs, lib, config, ... }:
{
  options = {
    ags.enable = lib.mkEnableOption "enable ags";
  };
  imports = [
    inputs.ags.homeManagerModules.default
  ];
  config = lib.mkIf config.ags.enable {
    home.packages = [ inputs.ags.packages.${pkgs.system}.io ];
    # For development purposes I keep these
    programs.ags = {
      enable = true;
      extraPackages = with pkgs; [
        inputs.ags.packages.${pkgs.system}.battery
        inputs.ags.packages.${pkgs.system}.cava
        inputs.ags.packages.${pkgs.system}.hyprland
        inputs.ags.packages.${pkgs.system}.mpris
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
  };
}
