{ pkgs, lib, config, ... }:
{
  options = {
    parallel.enable = lib.mkEnableOption "enable parallel";
  };
  config = lib.mkIf config.parallel.enable {
    home.packages = with pkgs; [
      parallel
    ];
  };
}
