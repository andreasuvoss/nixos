{ lib, config, ... }:{
  # This sort of input would be cool but I do not think I can make it work in my config
  # imports = lib.filesystem.listFilesRecursive ./.;

  imports = [
    ./dconf
    ./fonts
    ./gnome-keyring
    ./gtk
    ./gtk-power-menu
    ./hypridle
    ./hyprland
    ./hyprlock
    ./hyprpicker
    ./screenshot
    ./swaybg
    ./udiskie
    ./utility
    ./wayle
  ];
  options = {
    desktop.enable = lib.mkEnableOption "enables desktop";
  };
  config = lib.mkIf config.desktop.enable {
    dconf-theme.enable = true;
    desktop-utility.enable = true;
    fonts.enable = true;
    gnome-keyring.ssh.enable = true;
    gtk-theme.enable = true;
    gtk-power-menu.enable = true;
    hypridle.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
    hyprpicker.enable = true;
    screenshot.enable = true;
    swaybg.enable = true;
    udiskie.enable = false; # Does not autologin to ssh-agent with this
    wayle.enable = true;
  };
}