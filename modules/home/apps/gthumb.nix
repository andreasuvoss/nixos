{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gthumb
  ];
}
