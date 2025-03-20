{ pkgs-unstable, lib, config, ... }:
{
  options = {
    bruno.enable = lib.mkEnableOption "enable bruno";
  };
  config = lib.mkIf config.bruno.enable {
    home.packages = with pkgs-unstable; [
      # (bruno.overrideAttrs (oldAttrs: {
      #   postInstall = lib.optionalString (oldAttrs ? postInstall) oldAttrs.postInstall + ''
      #     mkdir -p "$out/share/applications"
      #     cp ${./bruno.desktop} "$out/share/applications"
      #   '';
      #   })
      # )
      bruno
      bruno-cli
    ];
  };
}
