{...}:
let
  settings = builtins.readFile ./config.json;
in
{
  programs.waybar = {
    enable = true;
    settings = builtins.fromJSON settings;
    style = ./style.css;
  };
}
