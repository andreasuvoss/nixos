{ lib, config, ... }:
let
  theme = builtins.readFile ./theme.toml;
in
{
  options = {
    yazi.enable = lib.mkEnableOption "enable yazi";
  };
  config = lib.mkIf config.yazi.enable {
    home.file.".config/yazi/flavors/dracula.yazi/flavor.toml" = {
      text = builtins.readFile ./flavors/dracula.yazi/flavor.toml;
      executable = false;
    };
    programs.yazi = {
      enable = true;
      theme = builtins.fromTOML theme;
    };
  };
}
