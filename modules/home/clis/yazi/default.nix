_:
let
  theme = builtins.readFile ./theme.toml;
in
{
  home.file.".config/yazi/flavors/dracula.yazi/flavor.toml" = {
    text = builtins.readFile ./flavors/dracula.yazi/flavor.toml;
    executable = false;
  };
  programs.yazi = {
    enable = true;
    theme = builtins.fromTOML theme;
  };
}
