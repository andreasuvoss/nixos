{ lib, config, ... }:{
  imports = [
    ./cheatsheet
  ];
  options = {
    scripts.enable = lib.mkEnableOption "scripts clis";
  };
  config = lib.mkIf config.scripts.enable {
    chtsh.enable = true;
  };
}
