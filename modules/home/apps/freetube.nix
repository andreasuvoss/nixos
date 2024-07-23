{ pkgs, pkgs-unstable, lib, config, ... }:
{
  options = {
    freetube.enable = lib.mkEnableOption "enable freetube";
  };
  config = lib.mkIf config.freetube.enable {
    home.packages = [
      pkgs-unstable.freetube
    ];
  };
}
