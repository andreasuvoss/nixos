{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tlrc
  ];
}
