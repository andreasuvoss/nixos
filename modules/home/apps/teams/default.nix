{ lib, config, ... }:
{
  options = {
    teams.enable = lib.mkEnableOption "enable teams" ;
  };
  config = lib.mkIf config.teams.enable {
    xdg.desktopEntries.teams = {
      name = "Microsoft Teams";
      genericName = "";
      exec = "teams";
      terminal = false;
      categories = [ "Application" ];
    };

    home.file.".config/firejail/teams-for-linux.local" = {
      enable = true;
      source = ./teams-for-linux.local;
    };
  };
}