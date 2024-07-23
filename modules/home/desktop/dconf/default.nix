{ lib, config, ...}:
{
  options = {
    dconf-theme.enable = lib.mkEnableOption "enable dconf-theme";
  };
  config = lib.mkIf config.dconf.enable {
    # packages here only used for dumping gnome config and converting to nix
    # home.packages = with pkgs; [
    #   # gnome.dconf-editor
    #   # dconf2nix
    # ];

    dconf.settings = {
      # "org/gnome/desktop/applications/terminal" = {
      #   exec = "alacritty";
      #   exec-arg  = "";
      # };
      "org/nemo/preferences" = {
        date-font-choice = "system-mono";
        date-format = "iso";
        default-folder-viewer = "list-view";
        show-advanced-permissions = false;
        show-bookmarks-in-to-menus = true;
        show-compact-view-icon-toolbar = false;
        show-computer-icon-toolbar = false;
        show-edit-icon-toolbar = false;
        show-full-path-titles = false;
        show-home-icon-toolbar = false;
        show-icon-view-icon-toolbar = false;
        show-list-view-icon-toolbar = false;
        show-new-folder-icon-toolbar = true;
        show-next-icon-toolbar = true;
        show-previous-icon-toolbar = true;
        show-search-icon-toolbar = false;
        show-up-icon-toolbar = false;
      };

      "menu-config" = {
        selection-menu-open-as-root = false;
        selection-menu-open-in-terminal = false;
      };

    };
  };
}
