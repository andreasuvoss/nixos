{ pkgs, lib, ... }:
# let
#   inherit (lib) mkIf isDerivation;
#   inherit (builtins) filter attrValues;
#   azure-cli-ext = pkgs.azure-cli.withExtensions (filter (item: isDerivation item) (attrValues pkgs.azure-cli-extensions));
# in
{
  home.packages = with pkgs; [
    jq
    ripgrep
    yq
    bat
    tree-sitter
    nodejs_22
    gcc
    tree
    curl
    fastfetch
    taskwarrior3
    ripgrep
    stow
    gparted
    # azure-cli-ext
    azure-cli
  ];
}
