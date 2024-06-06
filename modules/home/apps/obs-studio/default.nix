{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obs-studio
    # bitwarden-cli
  ];
}
