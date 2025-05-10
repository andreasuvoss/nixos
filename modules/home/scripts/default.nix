{ lib, config, ... }:{
  imports = [
    ./cheatsheet
    ./clean-profiles
    ./az-creds
    ./az-function-runner
  ];
  options = {
    scripts.enable = lib.mkEnableOption "enable scripts";
  };
  config = lib.mkIf config.scripts.enable {
    chtsh.enable = true;
    clean-profiles.enable = true;
    az-creds.enable = true;
    az-function-runner.enable = true;
  };
}
