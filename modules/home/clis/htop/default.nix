{ pkgs, lib, config, ... }:
{
  options = {
    htop.enable = lib.mkEnableOption "enable htop";
  };
  config = lib.mkIf config.htop.enable {
    home.packages = with pkgs; [
      htop
    ];
  };
}
