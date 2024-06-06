{pkgs, ...}:
{
  home.packages = with pkgs; [
    sway-audio-idle-inhibit
    wl-clipboard
    nwg-displays
    lxqt.lxqt-policykit
    wofi
  ];

  # Workaround systemd for restarting sway-audio-idle-inhibit in case it crashes
  systemd.user.services.keep-saii-alive = {
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
  
  
  systemd.user.timers.keep-saii-alive = {
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

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",highrr,auto,auto"
    ];
    "$mainMod" = "SUPER";
    "$terminal" = "alacritty";
    "$fileManager" = "nemo";
    "$menu" = "wofi --show drun";
    "$lock" = "swaylock";
    exec-once = [
      # "exec sway-audio-idle-inhibit" - this is run via service
      "swaybg --color 000000" # at some point maybe look into swww
      "waybar & swaync"
      "lxqt-policykit-agent"
      "discord --start-minimized"
      "sleep 1; Enpass -minimize"
      "steam %U -nochatui -nofriendsui -silent"
      "exec swayidle -w timeout 180 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' timeout 300 '$lock' before-sleep '$lock'"
      "sleep 1; megasync"
      "sleep 1; bitwarden"
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
      "float, title:^(Authentication Required)$"
      "center, title:^(Authentication Required)$"
      "size 500 200, title:^(Authentication Required)$"
      "dimaround, title:^(Authentication Required)$"
      "dimaround, title:^(Authorization Failed)$"

      # Until I swap it out for Bitwarden or 1Password
      # ... alright it is still almost unusable on hyprland.
      "float, title:^(Enpass Assistant)$"
      "center, title:^(Enpass Assistant)$"
      "dimaround, title:^(Enpass Assistant)$"
      "stayfocused, title:^(Enpass Assistant)$"
      "forceinput, title:^(Enpass Assistant)$"

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
      "$mainMod, ESCAPE, exec, pgrep -U $USER wlogout >/dev/null || exec wlogout -b 6 -s -R 1500 -L 1500 -T 600 -B 600" # I wonder how this looks on a smaller display..
      "$mainMod, E, exec, $fileManager"
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
  };
}
