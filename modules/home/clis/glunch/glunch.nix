{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "0.0.2";
in
buildGoModule {
  pname = "glunch";
  version = version;

  src = fetchFromGitHub {
    owner = "andreasuvoss";
    repo = "glunch";
    rev = "v${version}";
    hash = "sha256-Djs/yXqDWKM7iSQdNAOkwykzNQ7ImrrENeGrSUxNd8U=";
  };

  vendorHash = null;

  meta = {
    description = "Get the lunch menu at work";
    mainProgram = "glunch";
    platforms = lib.platforms.unix;
  };
}
