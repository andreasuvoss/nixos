{ pkgs, ... }:
{
  home.packages = with pkgs; [
    grim
    slurp
    swappy
    imagemagick
  ];
}
