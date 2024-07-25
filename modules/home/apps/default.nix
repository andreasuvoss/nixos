{ lib, config, ... }:{

  imports = [
    ./alacritty
    ./bitwarden
    ./discord
    ./firefox
    ./freetube.nix
    ./google-chrome
    ./gthumb.nix
    ./kitty
    ./libreoffice
    ./megasync.nix
    ./obs-studio
    ./rider
    ./signal
    ./spotify
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
    google-chrome.enable = false;
    gthumb.enable = true;
    kitty.enable = true;
    libreoffice.enable = true;
    megasync.enable = true;
    obs-studio.enable = true;
    rider.enable = true;
    signal.enable = true;
    spotify.enable = true;
  };
}
