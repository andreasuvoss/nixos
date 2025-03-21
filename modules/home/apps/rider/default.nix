{
  pkgs-unstable,
  lib,
  config,
  ...
}:
{
  options = {
    rider.enable = lib.mkEnableOption "enable rider";
  };
  config = lib.mkIf config.rider.enable {
    home.file.".ideavimrc" = {
      text = builtins.readFile ./.ideavimrc;
      executable = false;
    };
    # home.packages = with pkgs-unstable; [
    #   (jetbrains.plugins.addPlugins jetbrains.rider [
    #     "ideavim"
    #     (pkgs-unstable.stdenv.mkDerivation rec {
    #       name = "dracula";
    #       version = "1.16.0";
    #       src = pkgs-unstable.fetchzip {
    #         url = "https://downloads.marketplace.jetbrains.com/files/12275/522043/Dracula_Theme-${version}.zip";
    #         hash = "sha256-lI2uzguZ6oRwQiDMbHpi9ZqpwCxGsVE/7P4ZGF+ovp0=";
    #       };
    #       buildInputs = [ pkgs-unstable.unzip ];
    #       dontUnpack = false;
    #       installPhase = ''
    #         mkdir -p $out && cp -r . $out
    #       '';
    #     })
    #     (pkgs-unstable.stdenv.mkDerivation rec {
    #       name = "azure-toolkit-for-rider";
    #       version = "4.2.4";
    #       src = pkgs-unstable.fetchzip {
    #         url = "https://downloads.marketplace.jetbrains.com/files/11220/625006/azure-toolkit-for-rider-${version}.zip";
    #         hash = "sha256-0xKfWBC1WP0fa9+Xi2Kq7VPEQzfwKWKTvnW4THV3EOo=";
    #       };
    #       buildInputs = [ pkgs-unstable.unzip ];
    #       dontUnpack = false;
    #       installPhase = ''
    #         mkdir -p $out && cp -r . $out
    #       '';
    #     })
    #   ])
    # ];
  };
}
