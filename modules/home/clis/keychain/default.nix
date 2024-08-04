{ pkgs, lib, config, ... }:
{
  options = {
    keychain.enable = lib.mkEnableOption "enable keychain";
    keychain.keyfile = lib.mkOption {
      type = lib.types.str;
      default = "id_rsa";
      description = "Name of the keyfile to load";
    };
  };
  config = lib.mkIf config.keychain.enable {
    home.packages = with pkgs; [
      keychain
    ];
  };
}
