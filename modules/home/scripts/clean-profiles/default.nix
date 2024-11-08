{ lib, config, ... }:
{
  options = {
    clean-profiles.enable = lib.mkEnableOption "enable clean-profiles" ;
  };
  config = lib.mkIf config.clean-profiles.enable {
    home.file.".scripts/clean-profiles.sh" = {
      enable = true;
      executable = true;
      source = ./clean-profiles.sh;
    };
  };
}
