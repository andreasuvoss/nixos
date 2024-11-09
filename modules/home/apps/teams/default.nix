{ lib, config, ... }:
{
  options = {
    teams.enable = lib.mkEnableOption "enable teams" ;
  };
  config = lib.mkIf config.teams.enable {
    home.file.".config/firejail/teams-for-linux.local" = {
      enable = true;
      source = ./teams-for-linux.local;
    };
  };
}
