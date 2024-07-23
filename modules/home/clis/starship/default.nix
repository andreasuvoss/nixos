{ lib, config, ... }:
let
  cfg = builtins.readFile ./starship.toml;
in
{
  options = {
    starship.enable = lib.mkEnableOption "enable starship";
  };
  config = lib.mkIf config.starship.enable {
    programs.starship = {
      enable = true;
      settings = builtins.fromTOML cfg;
    };
  };
}
