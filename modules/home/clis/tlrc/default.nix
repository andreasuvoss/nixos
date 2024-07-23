{ pkgs, lib, config, ... }:
{
  options = {
    tldr.enable = lib.mkEnableOption "enable tldr";
  };
  config = lib.mkIf config.tldr.enable {
    home.packages = with pkgs; [
      tlrc
    ];
  };
}
