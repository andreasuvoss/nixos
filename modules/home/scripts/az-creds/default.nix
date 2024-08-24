{ lib, config, ... }:
{
  options = {
    az-creds.enable = lib.mkEnableOption "enable az-creds" ;
  };
  config = lib.mkIf config.az-creds.enable {
    home.file.".scripts/az-credentials.sh" = {
      enable = true;
      executable = true;
      source = ./az-credentials.sh;
    };
  };
}
