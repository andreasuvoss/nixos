{ pkgs, lib, config, ... }:
{
  options = {
    glow.enable = lib.mkEnableOption "enable glow";
  };
  config = lib.mkIf config.glow.enable {
    home.packages = with pkgs; [
      glow
    ];
  };
}
