{ pkgs-unstable, lib, config, ... }:
{
  options = {
    postman.enable = lib.mkEnableOption "enable postman";
  };
  config = lib.mkIf config.postman.enable {
    home.packages = with pkgs-unstable; [
      postman
    ];
  };
}
