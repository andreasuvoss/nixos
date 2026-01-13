{ pkgs, lib, config, ... }:
{
  options = {
    gnome-keyring.ssh.enable = lib.mkEnableOption "enables the gnome-keyring ssh functionality";
  };
  config = lib.mkIf config.gnome-keyring.ssh.enable {
    home.sessionVariables = {
      SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gcr/ssh";
      SSH_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    };
    systemd.user.services.gnome-keyring =
    {
      Unit = {
        Description = "GNOME Keyring";
        PartOf = [ "graphical-session-pre.target" ];
      };
      Service = {
        ExecStart = "/run/wrappers/bin/gnome-keyring-daemon --start --foreground";
        Restart = "on-abort";
      };
      Install.WantedBy = [ "graphical-session-pre.target" ];
    };
  };
}