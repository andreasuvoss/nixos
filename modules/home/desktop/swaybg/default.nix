{ pkgs, ... }:
let
  # settings = builtins.readFile ./config.json;
in
{
  home.packages = with pkgs; [
    swaybg
  ];
}
