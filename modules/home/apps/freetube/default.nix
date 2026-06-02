{ pkgs, pkgs-unstable, lib, config, ... }:
{
  options = {
    freetube.enable = lib.mkEnableOption "enable freetube";
  };
  config = lib.mkIf config.freetube.enable {
    programs.freetube = {
      enable = true;
      package = pkgs-unstable.freetube.overrideAttrs(old: {
        patches = (old.patches or []) ++ [
          (pkgs.fetchpatch {
            url = "github.com/FreeTubeApp/FreeTube/commit/cda95536d170310c59393dcf6024b818f8e08e5e.patch";
            hash = "sha256-ppfFjNH1DoiTq+xGmqQwJraYIh6UEsAtlSfNBO1O2AM=";
          })
        ];
      });

    };
    # home.packages = [
    #   pkgs-unstable.freetube
    # ];
  };
}