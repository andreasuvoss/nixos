{ lib, config, ... }:
{
  options = {
    kitty.enable = lib.mkEnableOption "enables kitty";
  };
  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      themeFile = "Dracula";
      font.name = "JetBrainsMono Nerd Font";
      font.size = 9;
      settings = {
        scrollback_lines = 10000;
      };
    };
  };
}
