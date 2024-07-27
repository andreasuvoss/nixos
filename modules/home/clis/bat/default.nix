{ pkgs, lib, config, ... }:
{
  options = {
    bat.enable = lib.mkEnableOption "enable bat";
  };
  config = lib.mkIf config.bat.enable {
    home.packages = with pkgs; [
      bat
    ];
  };
}
