{ pkgs, lib, config, ... }:
{
  options = {
    unzip.enable = lib.mkEnableOption "enable unzip";
  };
  config = lib.mkIf config.unzip.enable {
    home.packages = with pkgs; [
      unzip
    ];
  };
}
