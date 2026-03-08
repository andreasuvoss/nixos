{ lib, config, ... }:
{
  options = {
    hypridle.enable = lib.mkEnableOption "enable hypridle";
  };
  config = lib.mkIf config.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock";
        };
        listener = [
          {
            timeout = 180;
            on-timeout = "pidof hyprlock || hyprlock";
          }
          # The code below works, but turning dpms off has annoying side effects like rearranging windows and crashing
          # programs, so I'll keep this for the future if hyprlock implements a way to swap out the background
          # {
          #   timeout = 240;
            # on-timeout = "hyprctl dispatch dpms off";
            # on-resume = "hyprctl dispatch dpms on";
          # }
        ];
      };
    };
  };
}