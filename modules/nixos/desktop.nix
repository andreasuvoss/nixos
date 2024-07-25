{ pkgs, lib, config, ... }: {
  options = {
    desktop.enable = lib.mkEnableOption "enables libraries needed for desktop";
  };
  config = lib.mkIf config.desktop.enable {
    # TODO: Does this need to be enabled?
    # Enable the X11 windowing system. 
    services.xserver.enable = true;

    # Screensharing and stuff + portal for gnome-keyring
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [ 
        xdg-desktop-portal
        xdg-desktop-portal-gtk 
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-wlr
      ];
    };

    # Enable WM and DM
    programs.hyprland.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = false;
    services.xserver.excludePackages = [ pkgs.xterm ]; 
    services.gnome.core-utilities.enable = false;
    services.gnome.rygel.enable = false;

    # Enable automatic login for the user.
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "andreasvoss";
  };
}
