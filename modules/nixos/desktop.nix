{ pkgs, lib, config, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
  username = "andreasvoss";
in
{
  options = {
    desktop.enable = lib.mkEnableOption "enables libraries needed for desktop";
  };
  config = lib.mkIf config.desktop.enable {

    environment.systemPackages = with pkgs; [
      greetd.tuigreet
    ];

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
    services.xserver.desktopManager.gnome.enable = false;
    services.xserver.excludePackages = [ pkgs.xterm ]; 
    services.gnome.core-utilities.enable = false;
    services.gnome.rygel.enable = false;


    services.gnome.gnome-keyring.enable = true;
    services.dbus.packages = [ pkgs.gnome.seahorse ];
    # Use the decryption passphrase to also unlock the gnome-keyring (which is currently broken with greetd)
    boot.initrd.systemd.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${session}";
          user = "${username}";
        };
        default_session = {
          command = "${tuigreet} --greeting 'enter the mainframe' --asterisks --remember --remember-user-session --time --cmd ${session}";
          user = "greeter";
        };
      };
    };
  };
}
