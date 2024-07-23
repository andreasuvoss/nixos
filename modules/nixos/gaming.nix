{config, lib, ...}: {
  options = {
    gaming.enable = lib.mkEnableOption "enables libraries needed for gaming";
  };
  config = {
  };
}
