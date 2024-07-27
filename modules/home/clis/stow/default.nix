{ pkgs, lib, config, ... }:
{
  options = {
    stow.enable = lib.mkEnableOption "enable stow";
  };
  config = lib.mkIf config.stow.enable {
    home.packages = with pkgs; [
      stow
    ];
  };
}
