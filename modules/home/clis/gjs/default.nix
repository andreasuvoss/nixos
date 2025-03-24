{ pkgs, lib, config, ... }:
{
  options = {
    gjs.enable = lib.mkEnableOption "enable gjs";
  };
  config = lib.mkIf config.gjs.enable {
    home.packages = with pkgs; [
      gjs
      # astal.gjs
    ];
  };
}
