{ lib, config, ... }:{

  imports = [
    ./alacritty
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
    ./rider
    ./signal
    ./spotify
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
    vlc.enable = true;
  };
}
