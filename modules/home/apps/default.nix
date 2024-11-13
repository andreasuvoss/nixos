{ lib, config, ... }:{

  imports = [
    ./1password
    ./alacritty
    ./azuredatastudio
    ./bitwarden
    ./discord
    ./firefox
    ./freetube
    ./gimp
    ./google-chrome
    ./gthumb
    ./kitty
    ./libreoffice
    ./megasync
    ./obs-studio
    ./postman
    ./rider
    ./signal
    ./spotify
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
    gimp.enable = true;
    google-chrome.enable = false;
    gthumb.enable = true;
    kitty.enable = true;
    libreoffice.enable = true;
    megasync.enable = true;
    obs-studio.enable = true;
    rider.enable = true;
    signal.enable = true;
    spotify.enable = true;
    teams.enable = false;
    vlc.enable = true;
  };
}
