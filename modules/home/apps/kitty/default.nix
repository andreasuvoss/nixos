{ lib, config, ... }:
{
  options = {
    kitty.enable = lib.mkEnableOption "enables kitty";
  };
  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      theme = "Dracula";
      font.name = "JetBrainsMono Nerd Font";
      font.size = 9;
    };
  };
}
