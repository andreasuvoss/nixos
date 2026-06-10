{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  options = {
    wayle.enable = lib.mkEnableOption "enable wayle";
    wayle.module.battery.enable = lib.mkEnableOption "shows battery in the bar";
  };
  config = lib.mkIf config.wayle.enable {
    services.wayle = {
      enable = true;
      package = pkgs.wayle.overrideAttrs(old: let
        tsIcon = builtins.fetchurl{
          url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/tailscale.svg";
          sha256 = "sha256:165d8484s15s42c8a9al087zpmyfprkhm2yg3695nn9grxfn98yg";
        };
        wgIcon = builtins.fetchurl{
          url = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/wireguard-transparent-dark.svg";
          sha256 = "sha256:1yyyhskw0g4iv1ykxl70h1alxzpxfn5z9mlcjqgx2b521siy9sys";
        };


      in{
        preInstall = (old.preInstall or "") + ''
          mkdir -p $out/share/icons/hicolor/scalable/actions
          cp ${tsIcon} "$out/share/icons/hicolor/scalable/actions/ld-tailscale-symbolic.svg"
          cp ${wgIcon} "$out/share/icons/hicolor/scalable/actions/ld-wg-symbolic.svg"
        '';
      });
      settings = {
        bar = {
          layout = [
            {
              center = [ "window-title" ];
              left = [
                # "media"
                "hyprland-workspaces"
              ];
              monitor = "*";
              right = [
                "idle-inhibit"
                "separator"
                "notifications"
                "separator"
                "custom-tailscale"
              ]
              ++ lib.optional config.wayle.module.battery.enable
              [
                "separator"
                "battery"
              ]
              ++
              [
                "separator"
                "bluetooth"
                "separator"
                "network"
                "separator"
                "microphone"
                "separator"
                "volume"
                "separator"
                "clock"
                "separator"
                "systray"
              ];
              show = true;
            }
          ];
          scale = 0.8;
        };
        general = {
          font-sans = "JetBrainsMonoNL Nerd Font";
        };
        styling.palette = {
          bg = "#282a36";
          surface = "#1e1f29";
          elevated = "#44475a";
          fg = "#f8f8f2";
          fg-muted = "#6272a4";
          primary = "#bd93f9";
          red = "#ff5555";
          yellow = "#f1fa8c";
          green = "#50fa7b";
          blue = "#8be9fd";
        };
        modules = {
          hyprland-workspaces = {
            container-bg-color = "transparent";
          };
          battery = {
            icon-bg-color = "green";
            label-color = "fg-default";
            button-bg-color = "#44475a";
          };
          bluetooth = {
            label-color = "fg-default";
            button-bg-color = "#44475a";
          };
          clock = {
            format = "%H:%M";
            icon-bg-color = "#ffb86c";
            label-color = "fg-default";
            button-bg-color = "#44475a";
          };
          idle-inhibit = {
            icon-bg-color = "fg-muted";
            label-show = false;
            label-color = "fg-default";
          };
          microphone = {
            icon-bg-color = "border-accent";
            label-color = "fg-default";
            button-bg-color = "#44475a";
          };
          network = {
            icon-bg-color = "#ff79c6";
            label-color = "fg-default";
            button-bg-color = "#44475a";
          };
          notifications = {
            icon-bg-color = "#ffb86c";
            label-show = false;
            popup-position = "top-center";
          };
          volume = {
            icon-bg-color = "accent";
            label-color = "fg-default";
            button-bg-color = "#44475a";
          };
          window-title = {
            button-bg-color = "transparent";
            icon-bg-color = "auto";
            icon-show = false;
            label-color = "fg-default";
          };
          separator = {
            size = 1;
            length = 0.8;
            color = "transparent";
          };
          custom = [
            {
              id = "tailscale";
              command = ''
                TAILSCALE_STATUS=$(tailscale status --json)

                BACKEND_STATE=$(echo $TAILSCALE_STATUS | jq '.BackendState' -r)
                EXIT_NODE=$(echo $TAILSCALE_STATUS | jq '.Peer | to_entries | .[].value | select(.ExitNode==true) | .HostName' -r)

                if [[ -n $EXIT_NODE ]]; then
                    echo $EXIT_NODE
                elif [ $BACKEND_STATE = "Running" ]; then
                    echo "On"
                elif [ $BACKEND_STATE = "Stopped" ]; then
                    echo "Off"
                else
                    echo "Unknown"
                fi
              ''; # inline bash
              interval-ms = 10000;
              icon-name = "ld-wg-symbolic";
              format = "{{ output }}";
              label-color = "fg-default";
              icon-bg-color = "accent";
              button-bg-color = "#44475a";
            }
          ];
        };
      };
    };
  };
}