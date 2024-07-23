{ pkgs, lib, config, ... }:
{
  options = {
    gthumb.enable = lib.mkEnableOption "enable gthumb";
  };
  config = lib.mkIf config.gthumb.enable {
    home.packages = with pkgs; [
      gthumb
    ];
  };
}
