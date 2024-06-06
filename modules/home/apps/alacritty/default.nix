{...}:
let 
  config = builtins.readFile ./alacritty.toml;
in
{
  programs.alacritty = {
    enable = true;
    settings = builtins.fromTOML config;
  };
}
