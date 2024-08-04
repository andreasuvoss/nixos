{ pkgs, lib, config, ... }:
{
  options = {
    screenshot.enable = lib.mkEnableOption "enable screenshot";
  };
  config = lib.mkIf config.screenshot.enable {
    home.packages = with pkgs; [
      grim
      slurp
      swappy
      imagemagick
    ];
    home.file.".config/swappy/config" = {
      text = ''
        [Default]
        save_dir=$HOME/screenshots
        save_filename_format=swappy-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=2
        text_size=20
        text_font=sans-serif
        paint_mode=rectangle
        early_exit=true
        fill_shape=false
      '';
      executable = false;
    };
  };
}
