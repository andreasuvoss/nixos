{ pkgs, lib, config, ... }:
{
  options = {
    taskwarrior.enable = lib.mkEnableOption "enable taskwarrior";
  };
  config = lib.mkIf config.taskwarrior.enable {
    home.packages = with pkgs; [
      taskwarrior3
    ];
  };
}
