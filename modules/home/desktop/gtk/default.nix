{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    gtk-theme.enable = lib.mkEnableOption "enable gtk-theme";
  };
  config = lib.mkIf config.gtk-theme.enable {

    home.pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
    gtk = {
      enable = true;
      # iconTheme = {
      #   name = "Dracula";
      #   package = pkgs.dracula-icon-theme;
      # };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
    home.sessionVariables.GTK_THEME = "Dracula";
  };
}
