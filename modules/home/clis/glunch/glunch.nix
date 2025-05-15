{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "glunch";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "andreasuvoss";
    repo = "glunch";
    rev = "v0.0.1";
    hash = "sha256-8xBNkmNtRsYuQ3eY7/Z4x/e44+Sfg4YgbJucJryk+FU=";
  };

  vendorHash = "sha256-m5mBubfbXXqXKsygF5j7cHEY+bXhAMcXUts5KBKoLzM=";

  meta = {
    description = "Get the lunch menu at work";
    mainProgram = "glunch";
    platforms = lib.platforms.unix;
  };
}
