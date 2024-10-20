{
  pkgs,
  lib,
  config,
  ...
}:
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

    environment.systemPackages = with pkgs; [ greetd.tuigreet ];

    services.gnome.gnome-keyring.enable = true;
    services.dbus.packages = [ pkgs.gnome.seahorse ];
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

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "andreasvoss";

    # security.pam.services.greetd.text = ''
    #   # Account management.
    #   # account   required    pam_unix.so # unix (order 10900)
    #
    #   # Authentication management.
    #   auth      required    pam_succeed_if.so uid >= 1000 debug
    #   auth      optional    pam_unix.so likeauth nullok debug # unix-early (order 11500)
    #   auth      optional    ${config.systemd.package}/lib/security/pam_systemd_loadkey.so keyname=cryptsetup debug
    #   auth      optional    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so # gnome_keyring (order 12100)
    #
    #   account   sufficient pam_unix.so debug # unix (order 10900)
    #
    #   # Password management.
    #   password  requisite   pam_unix.so nullok yescrypt debug # unix (order 10200)
    #   password  optional    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so use_authtok # gnome_keyring (order 11200)
    #
    #   # Session management.
    #   session   optional    pam_keyinit.so revoke debug
    #   # session   required    pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
    #   # session   required    pam_unix.so # unix (order 10200)
    #   # session   required    pam_loginuid.so # loginuid (order 10300)
    #   # session   optional    ${config.systemd.package}/lib/security/pam_systemd.so # systemd (order 12000)
    #   # session   optional    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start # gnome_keyring (order 12600)
    #   session   include     login
    # '';
  };
}
