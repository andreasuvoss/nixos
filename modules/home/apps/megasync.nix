{ pkgs, ... }:
{
  home.packages = with pkgs; [
    megasync
  ];

  # This is started from Hyprland such that it only starts after the WM has loaded
  # services.megasync.enable = true;
}
