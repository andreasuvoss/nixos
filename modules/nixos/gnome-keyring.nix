{config, lib, ...}: {
  options = {
    gnome-keyring.enable = lib.mkEnableOption "enables gnome-keyring";
  };
  config = {
  };
}
