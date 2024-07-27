{ pkgs, lib, config, ... }:
{
  options = {
    gcc.enable = lib.mkEnableOption "enable gcc";
  };
  config = lib.mkIf config.gcc.enable {
    home.packages = with pkgs; [
      gcc
    ];
  };
}
