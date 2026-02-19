{ lib, config, ... }:{

  imports = [
    ./1password
    ./alacritty
    ./bitwarden
    ./bruno
    ./discord
    ./firefox
    ./freetube
    ./ghostty
    ./gimp
    ./google-chrome
    ./gthumb
    ./libreoffice
    ./megasync
    ./obs-studio
    ./obsidian
    ./postman
    ./rider
    ./signal
    ./spotify
    ./syncthing
    ./teams
    ./vlc
  ];

  options = {
    apps.enable = lib.mkEnableOption "enable apps";
  };
  config = lib.mkIf config.apps.enable {
    alacritty.enable = false;
    bitwarden.enable = true;
    discord.enable = true;
    firefox.enable = true;
    freetube.enable = true;
    ghostty.enable = true;
    gimp.enable = true;
    google-chrome.enable = true;
    gthumb.enable = true;
    libreoffice.enable = true;
    megasync.enable = true;
    obs-studio.enable = true;
    obsidian.enable = true;
    postman.enable = true;
    rider.enable = true;
    signal.enable = true;
    spotify.enable = true;
    syncthing.enable = true;
    teams.enable = false;
    vlc.enable = true;
  };
}