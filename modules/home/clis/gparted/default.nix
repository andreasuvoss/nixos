{ pkgs, lib, config, ... }:
{
  options = {
    gparted.enable = lib.mkEnableOption "enable gparted";
  };
  config = lib.mkIf config.gparted.enable {
    home.packages = with pkgs; [
      gparted
    ];
  };
}
