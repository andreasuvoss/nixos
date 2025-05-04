{ lib, config, pkgs, ... }:
{
  options = {
    hyprpicker.enable = lib.mkEnableOption "enable hyprpicker";
  };
  config = lib.mkIf config.hyprpicker.enable {
    home.packages = with pkgs; [
      hyprpicker
    ];
  };
}
