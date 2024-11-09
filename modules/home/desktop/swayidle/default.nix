{ pkgs, lib, config, ...}:
{
  options = {
    swayidle.enable = lib.mkEnableOption "enable swayidle";
    swayidle.enableWorkaround = lib.mkEnableOption "enable sway-audio-idle-inhibit workaround";
  };
  config = lib.mkIf config.swayidle.enable {
    home.packages = with pkgs; [
      swayidle
      sway-audio-idle-inhibit
    ];

    # Workaround systemd for restarting sway-audio-idle-inhibit in case it crashes
    systemd.user.services.keep-saii-alive = lib.mkIf config.swayidle.enableWorkaround {
      Unit = {
        Description = "Keep sway-audio-idle-inhibit alive";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "keep-saii-alive" ''
          pgrep -U $USER sway-audio-idle-inhibit >/dev/null || exec ${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit
        ''}";
      };
      Install.WantedBy = [ "default.target" ];
    };

    systemd.user.timers.keep-saii-alive = lib.mkIf config.swayidle.enableWorkaround {
      Unit = {
        Description = "Keep sway-audio-idle-inhibit alive";
      };
      Timer = {
        Unit = "keep-saii-alive.service";
        OnCalendar = "*-*-* *:*:00";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
