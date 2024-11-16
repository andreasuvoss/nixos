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

    security.pam.services.greetd.enableGnomeKeyring = true;
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

    # I simply cannot get the autounlock for the gnome-keyring to work...

    # security.pam.services.systemd-user.text = ''
    #   # Account management.
    #   account required pam_unix.so audit # unix (order 10900)
    #
    #   # Authentication management.
    #   auth sufficient pam_unix.so likeauth try_first_pass audit # unix (order 11500)
    #   auth required pam_deny.so # deny (order 12300)
    #
    #   # Password management.
    #   password sufficient pam_unix.so nullok yescrypt audit # unix (order 10200)
    #
    #   # Session management.
    #   session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
    #   session required pam_unix.so audit # unix (order 10200)
    #   session required pam_loginuid.so # loginuid (order 10300)
    #   session optional /nix/store/h05qs7dk5i6490ji0f9fndia9q2wwjac-systemd-255.9/lib/security/pam_systemd.so # systemd (order 12000)
    # '';

    # security.pam.services.greetd.text = ''
    #   # Account management.
    #   account required pam_unix.so audit # unix (order 10900)
    #
    #   # Authentication management.
    #   auth optional pam_unix.so audit nullok # unix-early (order 11500)
    #   # auth      optional    ${config.systemd.package}/lib/security/pam_systemd_loadkey.so keyname=cryptsetup debug
    #   #
    #   # auth required pam_exec.so debug log=/home/andreasvoss/pam/log2.txt /home/andreasvoss/pam/pam-script-test.sh
    #   # auth required pam_exec.so debug expose_authtok log=/home/andreasvoss/pam/log.txt /home/andreasvoss/pam/pam-script.sh
    #   auth      optional    ${config.systemd.package}/lib/security/pam_systemd_loadkey.so
    #
    #   auth optional /nix/store/l9y56l7jvsmwwpfrsa946syi08a1fij9-gnome-keyring-46.2/lib/security/pam_gnome_keyring.so debug # gnome_keyring (order 12100)
    #   auth sufficient pam_unix.so audit nullok try_first_pass # unix (order 12800)
    #   auth required pam_deny.so debug # deny (order 13600)
    #
    #   # Password management.
    #   password sufficient pam_unix.so nullok yescrypt # unix (order 10200)
    #   password optional /nix/store/l9y56l7jvsmwwpfrsa946syi08a1fij9-gnome-keyring-46.2/lib/security/pam_gnome_keyring.so use_authtok # gnome_keyring (order 11200)
    #
    #   # Session management.
    #   session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
    #   session required pam_unix.so # unix (order 10200)
    #   session required pam_loginuid.so # loginuid (order 10300)
    #   session optional /nix/store/h05qs7dk5i6490ji0f9fndia9q2wwjac-systemd-255.9/lib/security/pam_systemd.so # systemd (order 12000)
    #   session optional /nix/store/l9y56l7jvsmwwpfrsa946syi08a1fij9-gnome-keyring-46.2/lib/security/pam_gnome_keyring.so auto_start # gnome_keyring (order 12600)
    # '';
    #
    # systemd.services."greetd" = {
    #   # overrideStrategy = "asDropin";
    #   serviceConfig.KeyringMode = lib.mkForce "inherit";
    # };

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
