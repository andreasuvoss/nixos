{
  lib,
  config,
  ...
}:
{
  options = {
    rider.enable = lib.mkEnableOption "enable rider";
  };
  # This is only Rider configuration, Rider itself will be installed through Distrobox
  config = lib.mkIf config.rider.enable {
    home.file.".ideavimrc" = {
      text = builtins.readFile ./.ideavimrc;
      executable = false;
    };
  };
}
