{ config, ... }:{
  imports = [
    ./apps
    ./clis
    ./dev-tools
    ./desktop
    ./scripts
  ];

  xdg.userDirs = {
    enable = true;
    videos = "${config.home.homeDirectory}/videos";
    desktop = "${config.home.homeDirectory}";
    pictures = "${config.home.homeDirectory}/pictures";
    download = "${config.home.homeDirectory}/downloads";
    documents = "${config.home.homeDirectory}/documents";
    templates = "${config.home.homeDirectory}/templates";
    createDirectories = false;
  };
}
