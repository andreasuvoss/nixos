{ lib, config, ... }:{
  imports = [
    ./cheatsheet
    ./az-creds
  ];
  options = {
    scripts.enable = lib.mkEnableOption "enable scripts";
  };
  config = lib.mkIf config.scripts.enable {
    chtsh.enable = true;
    az-creds.enable = true;
  };
}
