{ lib, config, ... }:
{
  options = {
    chtsh.enable = lib.mkEnableOption "enable chtsh" ;
  };
  config = lib.mkIf config.chtsh.enable {
    home.file.".scripts/cht.sh" = {
      enable = true;
      executable = true;
      source = ./cht.sh;
    };
  };
}
