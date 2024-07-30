{ pkgs, lib, config, ... }:
{
  options = {
    keychain.enable = lib.mkEnableOption "enable keychain";
  };
  config = lib.mkIf config.keychain.enable {
    home.packages = with pkgs; [
      keychain
    ];
  };
}
