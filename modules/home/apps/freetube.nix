{ pkgs, pkgs-unstable, ... }:
{
  home.packages = [
    pkgs-unstable.freetube
  ];
}
