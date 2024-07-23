{ pkgs, lib, config, ... }:
let
  az-cred-provider = pkgs.callPackage ./az-cred-provider.nix {};
in
{
  options = {
    az-cred-provider.enable = lib.mkEnableOption "enable az-cred-provider";
  };
  config = lib.mkIf config.az-cred-provider.enable {
    home.packages = [
      az-cred-provider
    ];
    home.sessionVariables.NUGET_PLUGIN_PATHS = "${az-cred-provider}/lib/nuget/plugins/netcore/CredentialProvider.Microsoft/CredentialProvider.Microsoft.dll";
  };
}
