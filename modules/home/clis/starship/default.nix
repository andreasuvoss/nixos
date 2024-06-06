{...}:
let
  config = builtins.readFile ./starship.toml;
in
{
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML config;
  };
}
