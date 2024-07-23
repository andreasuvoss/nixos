{ pkgs, lib, config, ... }:
{
  options = {
    gum.enable = lib.mkEnableOption "enable gum" ;
  };
  config = lib.mkIf config.gum.enable {
    home.packages = with pkgs; [
      gum
    ];
  };
}
