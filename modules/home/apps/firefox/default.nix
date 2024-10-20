{ pkgs-unstable, lib, config, ... }:
let 
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  options = {
    firefox.enable = lib.mkEnableOption "enables firefox";
    firefox.workExtensions = lib.mkEnableOption "enables extensions used for work";
  };
  config = lib.mkIf config.firefox.enable {
    # Thanks https://github.com/scientiac/scifox !
    home.file.".mozilla/firefox/anvo/chrome" = {
        source = ./chrome;
        recursive = true;
    };
    home.file.".mozilla/firefox/work/chrome" = {
        source = ./chrome;
        recursive = true;
    };
    programs.firefox = {
      enable = true;
      package = pkgs-unstable.wrapFirefox pkgs-unstable.firefox-unwrapped {
        extraPolicies = {
          DisableTelemetry = true;
          ExtensionUpdate = true;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          DontCheckDefaultBrowser = true;
          DisplayBookmarksToolbar = "never";
          DisplayMenuBar = "default-off";
          SearchBar = "unified";
          SearchEngines = {
            Default = "Startpage";
            PreventInstalls = true;
          };
          ExtensionSettings = {
            "*".installation_mode = "blocked";
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
              default_area = "menupanel";
            };
            "{20fc2e06-e3e4-4b2b-812b-ab431220cada}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/startpage-private-search/latest.xpi";
              installation_mode = "force_installed";
              default_area = "menupanel";
            };
            "addon@darkreader.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
              installation_mode = "force_installed";
              default_area = "menupanel";
            };
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
              installation_mode = "force_installed";
              default_area = "menupanel";
            };
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
              installation_mode = "force_installed";
              default_area = "menupanel";
            };
            "{3c078156-979c-498b-8990-85f7987dd929}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
              installation_mode = "force_installed";
              default_area = "navbar";
            };
            "{0fbf0ce4-d020-4eb2-a833-0d4f2aadc895}" = lib.mkIf config.firefox.workExtensions {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/level_up_for_d365_power_apps/latest.xpi";
              installation_mode = "force_installed";
              default_area = "menupanel";
            };
            "ATBC@EasonWong" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/adaptive-tab-bar-colour/latest.xpi";
              installation_mode = "force_installed";
              default_area = "menupanel";
            };
            # "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
            #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
            #   installation_mode = "force_installed";
            # };
          };
          Preferences = {
            "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
            "extensions.pocket.enabled" = lock-false;
            "extensions.screenshots.disabled" = lock-true;
            "browser.startup.page" = 3;
            "browser.starup.homepage" = "chrome://browser/content/blanktab.html";
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.enabled" = false;
            "browser.bookmarks.defaultLocation" = "unifiled_____";
            "browser.search.defaultenginename" = "Startpage";
            "browser.search.order.1" = "Startpage";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "layers.acceleration.force-enabled" = true;
            "gfx.webrender.all" = true;
            "svg.context-properties.content.enabled" = true;
          };
        };
      };
      profiles = {
        anvo = {
          id = 0;
          name = "anvo";
          isDefault = ! config.firefox.workExtensions; # Make this the default profile in case this is personal machine
        };
        work = {
          id = 1;
          name = "work";
          isDefault = config.firefox.workExtensions;
        };
      };
    };
  };
}
