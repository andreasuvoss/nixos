{ inputs, pkgs, lib, config, ... }:
{
  options = {
    ags.enable = lib.mkEnableOption "enable ags";
  };
  config = lib.mkIf config.ags.enable {
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
  };
}
