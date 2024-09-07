{ pkgs, lib, config, ... }:
{
  options = {
    smassh.enable = lib.mkEnableOption "enable smassh";
  };
  config = lib.mkIf config.smassh.enable {
    home.packages = with pkgs; [
      smassh
    ];
  };
}
