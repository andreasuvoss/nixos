{...}:
{
  home.file.".config/swappy/config" = {
    text = builtins.readFile ./config;
    executable = false;
  };
}
