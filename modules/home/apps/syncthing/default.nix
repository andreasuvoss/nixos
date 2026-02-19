{ pkgs, lib, config, ... }:
{
  options = {
    syncthing.enable = lib.mkEnableOption "enables syncthing";
  };
  config = lib.mkIf config.syncthing.enable {
    services.syncthing = {
      enable = true;

    };
  };

}