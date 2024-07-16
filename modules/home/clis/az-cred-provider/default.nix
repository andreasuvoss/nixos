{ pkgs, ... }:
let
  az-cred-provider = pkgs.callPackage ./az-cred-provider.nix {};
in
{
  home.packages = [
    az-cred-provider
  ];
  home.sessionVariables.NUGET_PLUGIN_PATHS = "${az-cred-provider}/lib/nuget/plugins/netcore/CredentialProvider.Microsoft/CredentialProvider.Microsoft.dll";
}
