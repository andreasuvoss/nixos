{ pkgs, lib, config, ... }:
{
  options = {
    vhs.enable = lib.mkEnableOption "enable vhs" ;
  };
  config = lib.mkIf config.vhs.enable {
    home.packages = with pkgs; [
      vhs
    ];
  };
}
