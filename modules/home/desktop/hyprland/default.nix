{ pkgs, lib, config, ...}:
{
  options = {
    hyprland.enable = lib.mkEnableOption "enable hyprland";
    hyprland.natural_scroll = lib.mkOption {
      default = false;
    };
    hyprland.wlogout.command = lib.mkOption {
      default = "wlogout -b 6 -s -R 1500 -L 1500 -T 600 -B 600";
      description = "command to run when opening wlogout";
    };
  };
  config = lib.mkIf config.hyprland.enable {
    home.packages = with pkgs; [
      wl-clipboard
      xclip
      nwg-displays
      lxqt.lxqt-policykit
      wofi
    ];

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      monitor = [
        # ",highrr,auto,auto"
        # "eDP-1,highrr,auto,auto"
        "eDP-1,2880x1800@120.0,0x0,1.5"
        "Unknown-1,disable"
      ];
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "yazi";
      "$menu" = "wofi --show drun";
      "$lock" = "swaylock";
      "$wlogoutCmd" = config.hyprland.wlogout.command;
      exec-once = [
        "swaybg --color 000000" # at some point maybe look into swww
        "waybar"
        "sleep 1; swaync"
        "sleep 1; exec lxqt-policykit-agent" # something is not right with this authentication agent
        "discord --start-minimized"
        "sleep 1; signal-desktop"
        "steam %U -nochatui -nofriendsui -silent"
        "exec swayidle -w timeout 180 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' timeout 300 '$lock' before-sleep '$lock'"
        "sleep 1; megasync"
        "sleep 1; bitwarden"
        # The command below might work for keeping xclip and wl-clipboard in sync, I had some issues copying text into proton games
        # "wl-paste -t text -w bash -c '[ \"$(xclip -selection clipboard -o)\" = \"$(wl-paste -n)\" ] || [ \"$(wl-paste -l | grep image)\" = \"\" ] && xclip -selection clipboard'"
      ];
      env = [
        "XDG_CURRENT_DESKTOP,sway"
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
      };
      general = {
        gaps_in = 2;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgb(bd93f9)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
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
        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 1, myBezier"
          "windowsOut, 1, 1, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 1, default"
          "workspaces, 1, 6, default"
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
        "forceinput, class:^(MEGAsync)$"
        "dimaround, class:^(MEGAsync)$"

        "float, title:^(Authentication Required)$"
        "center, title:^(Authentication Required)$"
        "size 500 200, title:^(Authentication Required)$"
        "dimaround, title:^(Authentication Required)$"
        "dimaround, title:^(Authorization Failed)$"

        "float, title:^(Save Document\?)$"
        "center, title:^(Save Document\?)$"
        "dimaround, class:(soffice)"
        "stayfocused, title:^(Save Document\?)$"
        "forceinput, title:^(Save Document\?)$"

        "float, title:^(Welcome to JetBrains Rider\?)$"
        "center, title:^(Welcome to JetBrains Rider\?)$"

        "float, title:^(Volume Control)$"
        # "move 100% 0, title:^(Volume Control)$"
        # "size 500 200, title:^(Authentication Required)$"

        # alternative to audio inhibit?
        # "idleinhibit fullscreen, class:.*"
        "suppressevent maximize, class:.*"
      ];

      bind = [
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

        ", PRINT, exec, grim -g \"$(slurp)\" - | convert - -shave 1x1 PNG:- | swappy -f -"

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ]++ (
        builtins.concatLists (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
          in [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
      )
      10));
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
    };
  };
}
