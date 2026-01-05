{ lib, config, inputs, pkgs, ... }:
{
  options = {
    gtk-shell.enable = lib.mkEnableOption "enable gtk-shell";
  };
  config = lib.mkIf config.gtk-shell.enable {
    home.packages = [
      inputs.gtk-shell.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}