{ pkgs, lib, config, ... }:
{
  options = {
    google-chrome.enable = lib.mkEnableOption "enables google-chrome";
  };
  config = lib.mkIf config.google-chrome.enable {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
