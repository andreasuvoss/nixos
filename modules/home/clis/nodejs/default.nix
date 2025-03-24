{ pkgs, lib, config, ... }:
{
  options = {
    nodejs.enable = lib.mkEnableOption "enable nodejs";
  };
  config = lib.mkIf config.nodejs.enable {
    home.packages = with pkgs; [
      nodejs_23
    ];
  };
}
