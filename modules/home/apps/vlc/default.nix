{ pkgs, lib, config, ... }:
{
  options = {
    vlc.enable = lib.mkEnableOption "enable vlc";
  };
  config = lib.mkIf config.vlc.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
