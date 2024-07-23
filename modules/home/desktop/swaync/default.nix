{ pkgs, lib, config, ... }:
let
  json = builtins.readFile ./config.json;
  style = builtins.readFile ./style.css;
in
{
  options = {
    swaync.enable = lib.mkEnableOption "enable swaync";
  };
  config = lib.mkIf config.swaync.enable {
    home.packages = with pkgs; [
      libnotify
    ];
    services.swaync = {
      enable = true;
      settings = builtins.fromJSON json;
      style = style;
    };
  };
}
