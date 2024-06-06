{ pkgs, ... }:
let
  json = builtins.readFile ./config.json;
  style = builtins.readFile ./style.css;
in
{
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON json;
    style = style;
  };
  home.packages = with pkgs; [
    libnotify
  ];
  # home.file.".config/swaync/style.css" = {
  #   text = builtins.readFile ./style.css;
  #   executable = false;
  # };
  # home.file.".config/swaync/config.json" = {
  #   text = builtins.readFile ./config.json;
  #   executable = false;
  # };

}
