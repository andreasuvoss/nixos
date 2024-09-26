{ pkgs, lib, config, ... }:
{
  options = {
    sshfs.enable = lib.mkEnableOption "enable sshfs";
  };
  config = lib.mkIf config.sshfs.enable {
    home.packages = with pkgs; [
      sshfs
    ];
  };
}
