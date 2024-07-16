{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, stdenv ? pkgs.stdenv
, fetchurl ? pkgs.fetchurl
}:
stdenv.mkDerivation rec {
  pname = "artifacts-credprovider";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/microsoft/artifacts-credprovider/releases/download/v${version}/Microsoft.NuGet.CredentialProvider.tar.gz";
    sha256 = "sha256-2Rl8RHlv5FPZUIUMOWKuq0bmKTs3qInA8uKbQ2I70kg";
  };

  nativeBuildInputs = [];

  installPhase = ''
    export HOME=$(pwd)

    mkdir -p $out/lib/nuget/plugins
    tar -xzvf $src --strip-components 1 -C $out/lib/nuget/plugins
  '';
}
