{ pkgs, lib, config, ... }: {
  options = {
    gnome-keyring.enable = lib.mkEnableOption "enables gnome-keyring";
  };
  config = lib.mkIf config.gnome-keyring.enable {
    services.gnome.gnome-keyring.enable = true;
    environment.systemPackages = with pkgs; [ home-manager mangohud libsecret ];
    services.dbus.packages = [ pkgs.gnome.seahorse ];

    # Use the decryption passphrase to also unlock the gnome-keyring
    # boot.initrd.systemd.enable = true;
    boot.initrd.systemd.enable = true;
    security.pam.services = {
      gdm-autologin.text = ''
        auth      requisite     pam_nologin.so

        auth      required      pam_succeed_if.so uid >= 1000 quiet
        auth      optional      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
        auth      optional      ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
        auth      required      pam_permit.so

        account   sufficient    pam_unix.so

        password  requisite     pam_unix.so nullok yescrypt

        session   optional      pam_keyinit.so revoke
        session   include       login
      '';
    };
  };
}
