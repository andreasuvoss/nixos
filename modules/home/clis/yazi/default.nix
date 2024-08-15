{ lib, config, ... }:
let
  theme = builtins.readFile ./theme.toml;
in
{
  options = {
    yazi.enable = lib.mkEnableOption "enable yazi";
  };
  config = lib.mkIf config.yazi.enable {
    home.file.".config/yazi/flavors/dracula.yazi/flavor.toml" = {
      text = builtins.readFile ./flavors/dracula.yazi/flavor.toml;
      executable = false;
    };
    programs.yazi = {
      enable = true;
      theme = builtins.fromTOML theme;
      # TODO: https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/yazi.toml
    #   settings = {
    #     manager = {
    #       show_hidden = false;
    #       sort_dir_first = true;
    #     };
    #     opener = {
    #       edit = [
    #         {
    #           run = "${EDITOR:-vi} \"$@\"";
    #           desc = "$EDITOR";
    #           block = true;
    #           for = "unix";
    #         }
    #       ];
    #       open = [
    #         {
    #           run = "xdg-open \"$1\"";
    #           desc = "Open";
    #           for = "linux";
    #         }
    #       ];
    #       reveal = [
    #         {
    #           run = "xdg-open \"$(dirname \"$1\")\"";
    #           desc = "Reveal";
    #           for = "linux";
    #         }
    #       ];
    #       extract = [
    #         {
    #           run = "ya pub extract --list \"$@\"";
    #           desc = "Extract here";
    #           for = "unix";
    #         }
    #       ];
    #       play = [
    #         {
    #           run = "vlc \"$@\"";
    #           orphan = true;
    #           for = "unix";
    #         }
    #       ];
    #       gthumb = [
    #         {
    #           run = "gthumb \"$@\"";
    #           orphan = true;
    #           for = "unix";
    #         }
    #       ];
    #       gimp = [
    #         {
    #           run = "gimp \"$@\"";
    #           orphan = true;
    #           for = "unix";
    #         }
    #       ];
    #     };
    #     open = {
    #       rules = [
    #         {
    #           name = "*/";
    #           use = [ "open" "reveal" ];
    #         }
    #         {
    #           mime = "{audio,video}/*";
    #           use = [ "play" "reveal" ];
    #         }
    #         {
    #           mime = "text/*";
    #           use = [ "edit" "reveal" ];
    #         }
    #         {
    #           mime = "image/*";
    #           use = [ "open" "reveal" ];
    #         }
    #         {
    #           name = "*.xcf";
    #           use = "gimp";
    #         }
    #         { 
    #           mime = "application/{,g}zip"; 
    #           use = [ "extract" "reveal" ]; 
    #         }
	   #        { 
    #           mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}"; 
    #           use = [ "extract" "reveal" ]; 
    #         }
    #         { 
    #           mime = "application/{json,x-ndjson}"; 
    #           use = [ "edit" "reveal" ]; 
    #         }
	   #        { 
    #           mime = "*/javascript"; 
    #           use = [ "edit" "reveal" ]; 
    #         }
    #         { 
    #           mime = "inode/x-empty"; 
    #           use = [ "edit" "reveal" ]; 
    #         }
    #         {
    #           name = "*";
    #           use = [ "open" "reveal" ];
    #         }
    #       ];
    #     };
    #   };
    };
  };
}
