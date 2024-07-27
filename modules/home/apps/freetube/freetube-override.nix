{ pkgs , fetchurl }:
pkgs.freetube.overrideAttrs rec {
  version = "0.21.2";

  src = fetchurl {
    url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v${version}-beta/freetube_${version}_amd64.AppImage";
    sha256 = "sha256-Mk8qHDiUs2Nd8APMR8q1wZhTtxyzRhBAeXew9ogC3nk=";
  };
}
