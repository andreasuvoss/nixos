{ pkgs, lib, config, ... }:
{
  options = {
    timewarrior.enable = lib.mkEnableOption "enable timewarrior";
  };
  config = lib.mkIf config.timewarrior.enable {
    home.packages = with pkgs; [
      timewarrior
    ];
  };
}
