{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    hyprland.enable = lib.mkEnableOption "enable hyprland";
    hyprland.natural_scroll = lib.mkOption {
      default = false;
    };
    hyprland.startTeams = lib.mkEnableOption "starts teams automatically";
    hyprland.enableKanshi = lib.mkEnableOption "starts kanshi";
    hyprland.defaultOrientation = lib.mkOption {
      default = "center";
      description = "default orientation for master layout - left for entire monitor";
    };
    hyprland.monitor = lib.mkOption {
      default = [
        ",highrr,auto,auto"
      ];
      description = "hyprland monitor setup";
    };
  };
  config = lib.mkIf config.hyprland.enable {

    # Extra packages required
    home.packages = with pkgs; [
      wl-clipboard
      xclip
      nwg-displays
      hyprpolkitagent
    ];

    programs.tofi = {
      enable = true;
      settings = {
        font = "JetBrainsMono Nerd Font";
        font-size = 10;

        border-width = 1;
        border-color = "#ff79c6"; # pink
        corner-radius = 5;
        outline-width = 0;
        num-results = 12;
        width = 700;
        height = 350;
        background-color = "#282a36";
        text-color = "#f8f8f2";
        input-color = "#ff79c6";
        clip-to-padding = false;

        default-result-background = "#282a36";
        default-result-background-padding = "4, -1";
        result-spacing = 8;
        selection-color = "#50fa7b";
        selection-background-padding = "4, -1";
        selection-background = "#44475a";
      };
    };

    home.activation = {
      # https://github.com/philj56/tofi/issues/115#issuecomment-1701748297
      regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        tofi_cache=${config.xdg.cacheHome}/tofi-drun
        [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
      '';
    };

    wayland.windowManager.hyprland.enable = true;
    # wayland.windowManager.hyprland.configType = "lua";
    wayland.windowManager.hyprland.configType = "hyprlang";
    wayland.windowManager.hyprland.settings = {
      monitor = config.hyprland.monitor;
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "yazi";
      "$menu" = "tofi-drun | xargs -I{} hyprctl dispatch exec -- \"{}\"";
      "$lock" = "hyprlock";
      exec-once =
        [
          "swaybg --color 000000" # at some point maybe look into swww
          "gtk-power-menu"
          "sleep 1; exec ${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent"
          "discord --start-minimized"
          "sleep 1; signal-desktop"
          # "sleep 5; steam %U -nochatui -nofriendsui -silent"
          "steam %U -nochatui -nofriendsui -silent"
          # "hyprpolkitagent"
          # "systemctl --user start hyprpolkitagent.service"
          "sleep 1; bitwarden --autostart"
          "tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE \"$HYPRLAND_INSTANCE_SIGNATURE\""
          # The command below might work for keeping xclip and wl-clipboard in sync, I had some issues copying text into proton games
          # "wl-paste -t text -w bash -c '[ \"$(xclip -selection clipboard -o)\" = \"$(wl-paste -n)\" ] || [ \"$(wl-paste -l | grep image)\" = \"\" ] && xclip -selection clipboard'"
        ]
        ++ lib.optional config.hyprland.startTeams "sleep 5; teams --minimized true"
        # ++ lib.optional config._1password.enable "sleep 1; 1password --silent"
        ++ lib.optional config.hyprland.enableKanshi "exec ${pkgs.kanshi}/bin/kanshi";
      env = [
        # "XDG_CURRENT_DESKTOP,sway"
        "GTK_THEME,Dracula"
        "XCURSOR_SIZE,16"
        "HYPRCURSOR_SIZE,16"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "SSH_AUTH_SOCK,/run/user/1000/gcr/ssh"
        "SSH_ASKPASS,${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
        "SSH_AUTH_SOCK2,\${XDG_RUNTIME_DIR}/gcr/ssh"
      ];
      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        follow_mouse = 1;
        sensitivity = -0.5;
        accel_profile = "flat";
        force_no_accel = true;
        touchpad.natural_scroll = config.hyprland.natural_scroll;
        touchpad.clickfinger_behavior = config.hyprland.natural_scroll;
      };
      general = {
        gaps_in = 2;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgb(bd93f9)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "master";
        allow_tearing = false;
      };
      master = {
        allow_small_split = true;
        orientation = config.hyprland.defaultOrientation;
        slave_count_for_center_master = 0;
        center_master_fallback = "left";
        mfact = "0.55";
      };
      cursor = {
        inactive_timeout = 3;
      };
      decoration = {
        rounding = 2;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };
      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          #NAME,ONOFF,SPEED,CURVE,STYLE
          "windows, 1, 1, myBezier"
          "windowsOut, 1, 1, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 1, default"
          "workspaces,1,1,default"
        ];
      };
      dwindle = {
        # pseudotile = "yes";
        preserve_split = "yes";
      };
      master.new_status = "slave";
      # gestures.workspace_swipe = "off";
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = false;
        key_press_enables_dpms = true;
        focus_on_activate = true;
        enable_anr_dialog = false;
      };
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      windowrule = [
        # Rider
        "match:title ^(Welcome to JetBrains Rider\?)$, float on"
        "match:title ^(Welcome to JetBrains Rider\?)$, center on"
        "match:title ^(Rename)$, float on"
        "match:title ^(Rename)$, center on"
        "match:title ^(Rename)$, stay_focused on"
        "match:title ^(Create\: Directory)$, stay_focused on"

        # Steam
        "match:title ^(Friends List)$, float on"
        "match:class ^(steam)$, float on"

        # Volume control
        "match:title ^(Volume Control)$, float on"

        # Libre Office
        "match:title ^(Save Document\?)$, float on"
        "match:title ^(Save Document\?)$, center on"
        "match:title ^(Save Document\?)$, stay_focused on"
        "match:class ^(soffice)$, dim_around on"

        # Authentication
        "match:title ^(Authentication Required)$, float on"
        "match:title ^(Authentication Required)$, center on"
        "match:title ^(Authentication Required)$, size 500 200"
        "match:title ^(Authentication Required)$, dim_around on"
        "match:title ^(Authentication Failed)$, dim_around on"

        # Inhibit from maximizing window when going fullscreen
        "match:class .*, suppress_event maximize"
      ];

      bind =
        [
          "$mainMod, Q, exec, $terminal"
          # Use this to completely black out the monitor when locking
          # "$mainMod, M, exec, sleep 0.1; hyprctl dispatch dpms off; $lock"
          "$mainMod, M, exec, $lock"
          "$mainMod, P, exec, hyprpicker -a"
          # "$mainMod, ESCAPE, exec, astal -i gtk-shell power-menu"
          # "$mainMod, ESCAPE, exec, ags request -i gtk-shell power-menu"
          "$mainMod, ESCAPE, exec, gtk-power-menu show"
          # "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating"
          "$mainMod, C, togglefloating"
          "$mainMod, X, killactive"
          "$mainMod, C, centerwindow"
          "ALT, SPACE, exec, $menu"

          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"
          "$mainMod CTRL, H, resizeactive, 100 0"
          "$mainMod CTRL, L, resizeactive, -100 0"
          "$mainMod CTRL, K, resizeactive, 0 -100"
          "$mainMod CTRL, J, resizeactive, 0 100"

          # Layout config
          "$mainMod CTRL, comma, layoutmsg, addmaster"
          "$mainMod CTRL, period, layoutmsg, removemaster"
          "$mainMod SHIFT, down, layoutmsg, orientationcenter"
          "$mainMod SHIFT, left, layoutmsg, orientationleft"
          "$mainMod SHIFT, right, layoutmsg, orientationright"
          "$mainMod SHIFT, RETURN, layoutmsg, swapwithmaster"
          "$mainMod SHIFT, period, layoutmsg, mfact +0.1"
          "$mainMod SHIFT, comma, layoutmsg, mfact -0.1"
          "$mainMod ALT, F, togglefloating"
          "$mainMod ALT, C, centerwindow"

          # Fullscreen and maximize
          "$mainMod, F, fullscreen, 1"
          "$mainMod SHIFT, F, fullscreen, 0"

          ", PRINT, exec, grim -g \"$(slurp)\" - | convert - -shave 1x1 PNG:- | swappy -f -"

          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          ) 10
        ));
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      binde = [
        ", XF86MonBrightnessUp , exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown , exec, brightnessctl set 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        # ", XF86Display, exec, echo hello"
        # ", XF86Favorites, exec, echo hello"
      ];
      # bindl = [
      #   ", switch:on:Lid Switch, exec, $terminal"
      #   ", switch:off:Lid Switch, exec, $terminal"
      # ];
    };
  };
}