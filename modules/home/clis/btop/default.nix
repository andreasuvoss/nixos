{ pkgs, lib, config, ... }:
{
  options = {
    btop.enable = lib.mkEnableOption "enable btop";
  };
  config = lib.mkIf config.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "dracula";
        background_theme = false;
        vim_keys = true;
      };
    };
  };
}
