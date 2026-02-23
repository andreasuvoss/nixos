{ lib, config, ... }:
{
  options = {
    rclone.enable = lib.mkEnableOption "enable rclone" ;
  };
  config = lib.mkIf config.rclone.enable {
    programs.rclone = {
      enable = true;
    };
  };
}
