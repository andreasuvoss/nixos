{ lib, config, ... }:{
  # This sort of input would be cool but I do not think I can make it work in my config
  # imports = lib.filesystem.listFilesRecursive ./.; 
  
  imports = [
    ./ags
    ./dconf
    ./fonts
    ./gnome-keyring
    ./gtk
    ./gtk-shell
    ./hypridle
    ./hyprland
    ./hyprlock
    ./hyprpicker
    ./screenshot
    ./swaybg
    ./swaync
    ./udiskie
    ./utility
  ];
  options = {
    desktop.enable = lib.mkEnableOption "enables desktop";
  };
  config = lib.mkIf config.desktop.enable {
    ags.enable = true;
    dconf-theme.enable = true;
    desktop-utility.enable = true;
    fonts.enable = true;
    gnome-keyring.ssh.enable = true;
    gtk-theme.enable = true;
    gtk-shell.enable = true;
    hypridle.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
    hyprpicker.enable = true;
    screenshot.enable = true;
    swaybg.enable = true;
    swaync.enable = true;
    udiskie.enable = false; # Does not autologin to ssh-agent with this
  };
}
