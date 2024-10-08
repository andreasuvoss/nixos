{
  pkgs-unstable,
  lib,
  config,
  ...
}:
let
  riderVersion = "Rider2024.1";
in
{
  # home.file.".config/JetBrains/${riderVersion}/options/editor-font.xml" = {
  #   text = builtins.readFile ./options/editor-font.xml;
  #   executable = false;
  # };
  # home.file.".config/JetBrains/${riderVersion}/options/ui.lnf.xml" = {
  #   text = builtins.readFile ./options/ui.lnf.xml;
  #   executable = false;
  # };
  # home.file.".config/JetBrains/${riderVersion}/options/colors.scheme.xml" = {
  #   text = builtins.readFile ./options/colors.scheme.xml;
  #   executable = false;
  # };
  # home.file.".config/JetBrains/${riderVersion}/options/laf.xml" = {
  #   text = builtins.readFile ./options/laf.xml;
  #   executable = false;
  # };

  # This does not yet work as intended it might be copied to the wrong location
  options = {
    rider.enable = lib.mkEnableOption "enable rider";
  };
  config = lib.mkIf config.rider.enable {
    home.file.".ideavimrc" = {
      text = builtins.readFile ./.ideavimrc;
      executable = false;
    };
    home.packages = with pkgs-unstable; [
      (jetbrains.plugins.addPlugins jetbrains.rider [
        "ideavim"
        (pkgs.stdenv.mkDerivation {
          name = "dracula";
          version = "1.16.0";
          src = pkgs.fetchurl {
            url = "https://downloads.marketplace.jetbrains.com/files/12275/522043/Dracula_Theme-1.16.0.zip?updateId=522043&pluginId=12275&family=INTELLIJ";
            hash = "sha256-msTbx4r19ku5wF9fyLPi17hdTMPdP9fa0VlNAFzzJcg=";
          };
          dontUnpack = true;
          installPhase = ''
            mkdir -p $out
            cp $src $out
          '';
        })
      ])
    ];
  };
}
