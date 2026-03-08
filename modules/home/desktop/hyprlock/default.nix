{ lib, config, pkgs, ... }:
{
  options = {
    hyprlock.enable = lib.mkEnableOption "enable hyprlock";
  };
  config = lib.mkIf config.hyprlock.enable {
    home.file.".config/hypr/bg.png" = {
      source = ./bg.png;
      executable = false;
    };
    programs.hyprlock = {
      enable = true;
      package = pkgs.hyprlock.overrideAttrs(old: {
        # patch to allow image to be loaded when using screenshot
        patches = (old.patches or []) ++ [
          (pkgs.fetchpatch {
            url = "https://github.com/hyprwm/hyprlock/commit/98b86752fe4867bd14ef96a92ea788229af93130.patch";
            hash = "sha256-QmT9WdX1Nh1vy6ybjRATqCt7UW0Byb4QQ2dAfP50c5o=";
          })
        ];
      });
      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };
        background = [
          {
            path = "screenshot";
            color = "rgba(0, 0, 0, 1)";
            blur_passes = 2;
            blur_size = 7;
            brightness = 0.40;
            reload_cmd = "echo \"~/.config/hypr/bg.png\"";
            reload_time = 60;
          }
        ];
        input-field = [
          {
            size = "100, 100";
            position = "0, -80";
            outline_thickness = 7;
            monitor = "";
            dots_center = true;
            fade_on_empty = true;
            hide_input = true;
            font_family = "JetBrainsMono Nerd Font";
            inner_color = "rgba(40, 42, 54, 1)";
            outer_color = "rgba(189, 147, 249, 1)";
            hide_input_base_color = "rgba(189, 147, 249, 1)";
            placeholder_text = "";
            fail_color = "rgba(209, 76, 78, 1)";
            check_color = "rgba(241,250,140, 1)";
          }
        ];
      };
    };
  };
}