{
  pkgs,
  lib,
  config,
  ...
}:
let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
  };
in
{
  options = {
    desktop.enable = lib.mkEnableOption "enables libraries needed for desktop";
  };
  config = lib.mkIf config.desktop.enable {

    # Screensharing and stuff + portal for gnome-keyring
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };

    # Mount USB drives
    services.udisks2.enable = false; # Does not autologin to ssh-agent with this

    # Enable WM and DM
    programs.hyprland.enable = true;

    security.pam.services.greetd.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    services.dbus.packages = [ pkgs.seahorse ];
    boot.initrd.systemd.enable = true;

    environment.systemPackages = [ sddm-astronaut ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      settings = {
        Theme = {
          Current = "sddm-astronaut-theme";
        };
      };
      package = pkgs.kdePackages.sddm;
      extraPackages = [ sddm-astronaut ];
    };

    # services.displayManager.autoLogin.enable = true;
    # services.displayManager.autoLogin.user = "andreasvoss";
  };
}
