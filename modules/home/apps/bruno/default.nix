{ pkgs-unstable, lib, config, ... }:
{
  options = {
    bruno.enable = lib.mkEnableOption "enable bruno";
  };
  config = lib.mkIf config.bruno.enable {
    home.packages = with pkgs-unstable; [
      bruno
      bruno-cli
    ];
  };
}
