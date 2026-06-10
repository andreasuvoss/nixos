{ lib, config, ... }:{
  imports = [
    ./az-creds
    ./az-function-runner
    ./cheatsheet
    ./clean-profiles
    ./tailscale-exit
  ];
  options = {
    scripts.enable = lib.mkEnableOption "enable scripts";
  };
  config = lib.mkIf config.scripts.enable {
    chtsh.enable = true;
    clean-profiles.enable = true;
    az-creds.enable = true;
    az-function-runner.enable = true;
    tailscale-exit.enable = true;
  };
}