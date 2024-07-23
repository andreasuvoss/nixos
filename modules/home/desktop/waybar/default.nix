{ lib, config, ...}:
let
  settings = builtins.readFile ./config.json;
in
{
  options = {
    waybar.enable = lib.mkEnableOption "enable waybar";
  };
  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;
      settings = builtins.fromJSON settings;
      style = ./style.css;
    };
  };
}
