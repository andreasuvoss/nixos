{ pkgs, lib, config, ... }:
{
  options = {
    udisks.enable = lib.mkEnableOption "enable udisks";
  };
  config = lib.mkIf config.udisks.enable {
    home.packages = with pkgs; [
      udisks
    ];
  };
}
