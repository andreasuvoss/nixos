{ pkgs, lib, config, ... }:
{
  options = {
    curl.enable = lib.mkEnableOption "enable curl";
  };
  config = lib.mkIf config.curl.enable {
    home.packages = with pkgs; [
      curl
    ];
  };
}
