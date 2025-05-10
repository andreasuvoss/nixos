{ lib, config, ... }:
{
  options = {
    az-function-runner.enable = lib.mkEnableOption "enable az-function-runner";
  };
  config = lib.mkIf config.az-function-runner.enable {
    home.file.".scripts/az-function-runner.sh" = {
      enable = true;
      executable = true;
      source = ./az-function-runner.sh;
    };
  };
}
