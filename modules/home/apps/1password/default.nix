{ pkgs, lib, config, ... }:
{
  options = {
    _1password.enable = lib.mkEnableOption "enables 1password";
  };
  config = lib.mkIf config._1password.enable {
    home.packages = with pkgs; [
      _1password
      _1password-gui
    ];
  };
}
