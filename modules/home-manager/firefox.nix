{ pkgs, ... }:

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
  programs.browserpass.enable = true;
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DontCheckDefaultBrowser = true;
      ExtensionSettings = {
        # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # 1Password:
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      Preferences = {
        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
        "browser.formfill.enable" = lock-false;
        "browser.newtabpage.activity-stream.discoverystream.personalization.enabled" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = lock-false;
        "browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        "browser.newtabpage.activity-stream.showWeather" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.telemetry" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.urlbar.quicksuggest.impressionCaps.nonSponsoredEnabled" = lock-false;
        "browser.urlbar.quicksuggest.impressionCaps.sponsoredEnabled" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "dom.private-attribution.submission.enabled" = lock-false;
        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.disabled" = lock-true;
        "network.trr.confirmation_telemetry_enabled" = lock-false;
        "security.app_menu.recordEventTelemetry" = lock-false;
        "security.certerrors.recordEventTelemetry" = lock-false;
        "security.protectionspopup.recordEventTelemetry" = lock-false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        "toolkit.telemetry.updatePing.enabled" = lock-false;
        "toolkit.telemetry.user_characteristics_ping.opt-out" = lock-true;
      };
      WebsiteFilter = {
        Block = [
          "*://*.reddit.com/"
          "*://*.reddit.com/r/all/*"
          "*://*.reddit.com/r/popular/*"
        ];
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

  home.file.".mozilla/managed-storage/uBlock0@raymondhill.net.json".text =
    builtins.toJSON {
      name = "uBlock0@raymondhill.net";
      description = "_";
      type = "storage";
      data = {
        adminSettings = {
          userFilters = ''
            www.youtube.com###related
            www.youtube.com##.ytp-pause-overlay
            www.youtube.com##.ytp-endscreen-content
            www.youtube-nocookie.com###related
            www.youtube-nocookie.com##.ytp-pause-overlay
            www.youtube-nocookie.com##.ytp-endscreen-content
            www.youtube.com##ytd-reel-shelf-renderer.ytd-structured-description-content-renderer.style-scope
          '';
        };
      };
    };
}
