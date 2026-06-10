{ pkgs, pkgs-unstable, lib, config, ... }:
{
  options = {
    freetube.enable = lib.mkEnableOption "enable freetube";
  };
  config = lib.mkIf config.freetube.enable {
    programs.freetube = {
      enable = true;
      package = pkgs-unstable.freetube.overrideAttrs(old: rec {
        version = "0.24.1";
        src = pkgs-unstable.fetchFromGitHub {
            owner = "FreeTubeApp";
            repo = "FreeTube";
            tag = "v${version}-beta";
            hash = "sha256-oo5ozdP3d82jY8OOYrt568MoSfPmwBoitdtgESiRMlE=";
          };
        # patches = (old.patches or []) ++ [
        #   (pkgs.fetchpatch {
        #     url = "github.com/FreeTubeApp/FreeTube/commit/cda95536d170310c59393dcf6024b818f8e08e5e.patch";
        #     hash = "sha256-ppfFjNH1DoiTq+xGmqQwJraYIh6UEsAtlSfNBO1O2AM=";
        #   })
        # ];
      });
    };
  };
}