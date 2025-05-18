{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "0.0.3";
in
buildGoModule {
  pname = "glunch";
  version = version;

  src = fetchFromGitHub {
    owner = "andreasuvoss";
    repo = "glunch";
    rev = "v${version}";
    hash = "sha256-OzxyzsuYnKDII3PMK63cMoFXGTmS5Ph+vxTFnerzj+U=";
  };

  vendorHash = null;

  meta = {
    description = "Get the lunch menu at work";
    mainProgram = "glunch";
    platforms = lib.platforms.unix;
  };
}
