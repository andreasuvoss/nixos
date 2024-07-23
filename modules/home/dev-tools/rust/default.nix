{ pkgs, lib, config, ...}:
{
  options = {
    rust.enable = lib.mkEnableOption "enable rust";
  };
  config = lib.mkIf config.rust.enable {
    home.packages = with pkgs; [
      rustc
      cargo
    ];
  };
}
