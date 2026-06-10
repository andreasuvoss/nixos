{ lib, config, inputs, pkgs, ... }:
{
  options = {
    gtk-power-menu.enable = lib.mkEnableOption "enable gtk-power-menu";
  };
  config = lib.mkIf config.gtk-power-menu.enable {
    home.packages = [
      pkgs.libnotify
      inputs.gtk-power-menu.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}