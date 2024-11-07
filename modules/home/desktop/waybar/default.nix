{ lib, config, ... }:
{
  options = {
    waybar.enable = lib.mkEnableOption "enable waybar";
  };
  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          position = "top";
          height = 5;
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-center = [
            "hyprland/window"
          ];
          modules-right = [
            "custom/audio_idle_inhibitor"
            "idle_inhibitor"
            "backlight"
            "pulseaudio"
            "network"
            "group/hardware"
            # "temperature"
            "battery"
            # "tray"
            "group/clocktray"
            "custom/notification"
          ];

          ## Modules ##
          idle_inhibitor = {
            format = "{icon}";
            align = 0.5;
            justify = "center";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          tray = {
            spacing = 10;
          };

          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%d.%m.%Y}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };
          pulseaudio = {
            format = "{volume}% {icon} ";
            format-muted = "{volume}% 󰝟 ";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "pavucontrol";
          };
          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = [
              ""
              ""
              ""
            ];
          };
          network = {
            format-wifi = "{essid} {icon}";
            format-ethernet = "{ifname} {icon}";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            tooltip-format-ethernet = ''
              Interface: {ifname} {icon}
              IP:        {ipaddr}/{cidr}
              Subnet:    {netmask}
              Gateway:   {gwaddr}'';
            tooltip-format-wifi = ''
              Interface: {ifname} {icon}
              IP:        {ipaddr}/{cidr}
              SSID       {essid}
              Signal:    {signalStrength}%
              Frequency: {frequency}
              Subnet:    {netmask}
              Gateway:   {gwaddr}'';
            format-icons = {
              ethernet = " ";
              default = [
                "󰤟 "
                "󰤢 "
                "󰤥 "
                "󰤨 "
              ];
            };
          };

          # Laptop stuff
          backlight = {
            format = "{percent}% {icon}";
            format-icons = [
              "󰃞"
              "󰃟"
              "󰃠"
            ];
          };
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% 󰂄";
            format-plugged = "{capacity}% 󰂄";
            format-alt = "{time} {icon}";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          "battery#bat2" = {
            bat = "BAT2";
          };

          "custom/audio_idle_inhibitor" = {
            format = "{icon}";
            exec = "sway-audio-idle-inhibit --dry-print-both-waybar";
            exec-if = "which sway-audio-idle-inhibit";
            return-type = "json";
            tooltip = false;
            format-icons = {
              output = "";
              input = "";
              output-input = "  ";
              none = "";
            };
          };

          "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              # none = "";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };

          "group/hardware" = {
            orientation = "horizontal";
            drawer = {
              transition-duration = 150;
              click-to-reveal = true;
            };
            modules = [
              "cpu"
              "memory"
              "disk"
            ];
          };

          "group/clocktray" = {
            orientation = "horizontal";
            drawer = {
              transition-duration = 150;
              click-to-reveal = true;
            };
            modules = [
              "clock"
              "tray"
            ];
          };

          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };
          memory = {
            format = "{}%  ";
            tooltip-format = "{used:0.1f}GiB/{total:0.1f}GiB used";
          };
          disk = {
            interval = 30;
            format = "{specific_free:0.0f}GB 󰋊";
            unit = "GB";
          };

        };
      };
      style = ./style.css;
    };
  };
}
