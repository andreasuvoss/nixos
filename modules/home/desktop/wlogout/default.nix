{ lib, config, ...}:
{
  options = {
    wlogout.enable = lib.mkEnableOption "enable wlogout";
  };
  config = lib.mkIf config.wlogout.enable {
    home.file.".config/wlogout/icons" = {
        source = ./icons;
        recursive = true;
    };
    programs.wlogout = {
      enable = true;
      style = ./style.css;
      layout = [
        {
            label = "lock";
            action = "swaylock -f -c 000000";
            text = "Lock";
            keybind = "l";
        }
        {
            label = "logout";
            action = "hyprctl dispatch exit";
            text = "Logout";
            keybind = "e";
        }
        {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
        }
        {
            label = "suspend";
            action = "systemctl suspend";
            text = "Suspend";
            keybind = "u";
        }
        {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
        }
        {
            label = "windows";
            action = "systemctl reboot --boot-loader-entry=auto-windows";
            text = "Windows";
            keybind = "w";
        }
      ];
    };
  };
}
