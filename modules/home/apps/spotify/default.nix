{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify
    # spotify-tray
  ];
}
