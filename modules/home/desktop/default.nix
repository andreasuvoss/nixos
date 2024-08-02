{ lib, config, ... }:{
  # This sort of input would be cool but I do not think I can make it work in my config
  # imports = lib.filesystem.listFilesRecursive ./.; 
  
  imports = [
    ./dconf
    ./fonts
    ./gnome-keyring
    ./gtk
    ./hyprland
    ./nemo
    ./screenshot
    ./swaybg
    ./swayidle
    ./swaylock
    ./swaync
    ./udiskie
    ./utility
    ./waybar
    ./wlogout
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
    hyprland.enable = true;
    nemo.enable = true;
    screenshot.enable = true;
    swaybg.enable = true;
    swayidle.enable = true;
    swaylock.enable = true;
    swaync.enable = true;
    udiskie.enable = true;
    waybar.enable = true;
    wlogout.enable = true;
  };
}
