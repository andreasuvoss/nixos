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
    hyprland.wlogout.command = lib.mkOption {
      default = "wlogout -b 6 -s -R 1500 -L 1500 -T 600 -B 600";
      description = "command to run when opening wlogout";
    };
    hyprland.monitor = lib.mkOption {
      default = [
        ",highrr,auto,auto"
      ];
      description = "hyprland monitor setup";
    };
  };
  config = lib.mkIf config.hyprland.enable {
    home.packages = with pkgs; [
      wl-clipboard
      xclip
      nwg-displays
      lxqt.lxqt-policykit
    ];

    programs.tofi = {
      enable = true;
      settings = {
        font = "JetBrainsMono Nerd Font";
        font-size = 10;

        border-width = 1;
        border-color = "#ff79c6"; # pink
        # border-color = "#bd93f9"; # purple
        # border-color = "#ffb86c"; # orange
        corner-radius = 5;
        outline-width = 0;
        num-results = 12;
        width = 700;
        height = 350;

        # prompt-text = "run: ";
        # text-color = "#cad3f5";
        # prompt-color = "#ed8796";
        # background-color = "#24273a";
        #
        #
        # selection-color = "#eed49f";
        # selection-background = "#000000";
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
        # selection-match-color = "#8be9fd"; # this results in weird behaviour
      };
    };

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      monitor = config.hyprland.monitor;
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "yazi";
      "$menu" = "tofi-drun | xargs hyprctl dispatch exec --";
      "$lock" = "swaylock";
      "$wlogoutCmd" = config.hyprland.wlogout.command;
      exec-once =
        [
          "swaybg --color 000000" # at some point maybe look into swww
          "waybar"
          "sleep 1; swaync"
          "sleep 1; exec ${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent"
          "discord --start-minimized"
          "sleep 1; signal-desktop"
          "steam %U -nochatui -nofriendsui -silent"
          "exec swayidle -w timeout 180 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' timeout 300 '$lock' before-sleep '$lock'"
          "sleep 1; megasync"
          "sleep 1; bitwarden"
          # The command below might work for keeping xclip and wl-clipboard in sync, I had some issues copying text into proton games
          # "wl-paste -t text -w bash -c '[ \"$(xclip -selection clipboard -o)\" = \"$(wl-paste -n)\" ] || [ \"$(wl-paste -l | grep image)\" = \"\" ] && xclip -selection clipboard'"
        ]
        ++ lib.optional config.hyprland.startTeams "sleep 1; teams --minimized true"
        # ++ lib.optional config._1password.enable "sleep 1; 1password --silent"
        ++ lib.optional config.hyprland.enableKanshi "exec ${pkgs.kanshi}/bin/kanshi"
        ++ lib.optional (
          !config.swayidle.enableWorkaround
        ) "exec ${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
      env = [
        # "XDG_CURRENT_DESKTOP,sway"
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
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
        # layout = "dwindle";
        layout = "master";
        allow_tearing = false;
      };
      master = {
        allow_small_split = true;
        orientation = "left"; # to use entire monitor
        # orientation = "center";
        always_center_master = true;
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
        # drop_shadow = "yes";
        # shadow_range = 4;
        # shadow_render_power = 3;
        # "col.shadow" = "rgba(1a1a1aee)";
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
          # "workspaces, 1, 6, default"
          "workspaces,1,1,default"
        ];
      };
      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };
      master.new_status = "master";
      # master.new_is_master = true;
      gestures.workspace_swipe = "off";
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = false;
        key_press_enables_dpms = true;
        focus_on_activate = true;
      };
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      windowrulev2 = [
        # Steam
        "float, title:^(Friends List)$"
        "float, class:^(steam)$"

        # MEGA
        "float, class:^(MEGAsync)$"
        "stayfocused, class:^(MEGAsync)$"
        # "forceinput, class:^(MEGAsync)$"
        "dimaround, class:^(MEGAsync)$"

        "float, title:^(Authentication Required)$"
        "center, title:^(Authentication Required)$"
        "size 500 200, title:^(Authentication Required)$"
        "dimaround, title:^(Authentication Required)$"
        "dimaround, title:^(Authorization Failed)$"

        # "float, title:^(Extension:.*Bitwarden.*Firefox)$"
        # "center, title:^(Extension:.*Bitwarden.*Firefox)$"
        # "size 500 200, title:^(Extension:.*Bitwarden.*Firefox)$"
        # "dimaround, title:^(Extension:.*Bitwarden.*Firefox)$"

        "float, title:^(Save Document\?)$"
        "center, title:^(Save Document\?)$"
        "dimaround, class:(soffice)"
        "stayfocused, title:^(Save Document\?)$"
        # "forceinput, title:^(Save Document\?)$"

        "float, title:^(Welcome to JetBrains Rider\?)$"
        "center, title:^(Welcome to JetBrains Rider\?)$"

        "float, title:^(Volume Control)$"
        # "move 100% 0, title:^(Volume Control)$"
        # "size 500 200, title:^(Authentication Required)$"

        # RIDER
        "float, title:^(Rename)$"
        "center, title:^(Rename)$"
        # "dimaround, class:(Rename)"
        "stayfocused, title:^(Rename)$"
        # "forceinput, title:^(Rename)$"

        "stayfocused, title:^(Create\: Directory)$"

        # alternative to audio inhibit?
        # "idleinhibit fullscreen, class:.*"
        "suppressevent maximize, class:.*"
      ];

      bind =
        [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, M, exec, sleep 0.1; hyprctl dispatch dpms off; $lock"
          "$mainMod, ESCAPE, exec, pgrep -U $USER wlogout >/dev/null || exec $wlogoutCmd" # I wonder how this looks on a smaller display..
          # "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating"
          "$mainMod, C, togglefloating"
          "$mainMod, X, killactive"
          "$mainMod, C, centerwindow"
          "$mainMod, N, exec, swaync-client -t -sw"
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
          "$mainMod SHIFT, F, fullscreen"
          "$mainMod ALT, F, togglefloating"
          "$mainMod ALT, C, centerwindow"

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
      ];
      # bindl = [
      #   ", switch:on:Lid Switch, exec, $terminal"
      #   ", switch:off:Lid Switch, exec, $terminal"
      # ];
    };
  };
}
