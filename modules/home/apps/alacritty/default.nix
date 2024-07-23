{ lib, config, ... }:
let 
  cfg = builtins.readFile ./alacritty.toml;
in
{
  options = {
    alacritty.enable = lib.mkEnableOption "enables alacritty";
  };
  config = lib.mkIf config.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = builtins.fromTOML cfg;
    };
  };
}
