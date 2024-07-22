{ config, pkgs, ... }:
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
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
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
            default_area = "navbar";
          };
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
            installation_mode = "force_installed";
            default_area = "menupanel";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
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
        };
      };
    };
    profiles = {
      anvo = {
        id = 0;
        name = "anvo";
        isDefault = true;
      };
    };
  };
}
