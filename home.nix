{
  config,
  pkgs,
  unstable,
  lib,
  ...
}:

{
  imports = [
    ./modules/home-manager/codex.nix
    ./modules/home-manager/dark_mode.nix
    ./modules/home-manager/firefox.nix
    ./modules/home-manager/fish.nix
    ./modules/home-manager/nix-rs-init.nix
    ./modules/home-manager/sway.nix
    ./modules/home-manager/vscode.nix
  ];

  home.stateVersion = "24.05";

  home = {
    # enableDebugInfo = true;
    packages =
      (with pkgs; [
        bottles
        calibre
        curl
        dconf-editor
        direnv
        extremetuxracer
        file
        gcc
        gnome-terminal
        gnome-tweaks
        google-chrome
        grc
        intel-gpu-tools
        jq
        jujutsu
        killall
        llvm
        lm_sensors
        lutris-free
        nixfmt-rfc-style # nix formatter
        openai
        pciutils
        ripgrep
        slack
        steam
        traceroute
        transmission_4-gtk
        unzip
        vlc
        wget

        (pkgs.writeShellApplication {
          name = "codex";
          runtimeInputs = [ pkgs.nodejs_22 ];
          text = ''
            exec npx @openai/codex "$@"
          '';
        })
        (pkgs.writeShellApplication {
          name = "claude-code";
          runtimeInputs = [ pkgs.nodejs_22 ];
          text = ''
            exec npx @anthropic-ai/claude-code "$@"
          '';
        })

      ])
      ++ (with unstable; [
        code-cursor
        cursor-cli
        spotify
        unityhub
      ]);
  };

  codex.enable = true;
  nix-rs-init.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Brian Vincent";
      email = "brainn@gmail.com";
    };
  };

  programs.zsh.enable = true;

  dconf = {
    enable = true;
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.extensionUuid
        blur-my-shell.extensionUuid
        gsconnect.extensionUuid
      ];
    };
  };

  dconf.settings = {
    # Blank Screen Delay
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 (15 * 60);
    };

    # Custom Keyboard Shortcuts
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Alt><Control>t";
      command = "kgx";
      name = "Open Console";
    };

    # Fix alt-tab
    "org/gnome/desktop/wm/keybindings" = {
      "switch-applications" = [ ];
      "switch-application-backward" = [ ];
      "switch-windows" = [
        "<Alt>Tab"
        "<Super>Tab"
      ];
      "switch-windows-backward" = [
        "<Shift><Alt>Tab"
        "<Super><Shift>Tab"
      ];
    };

    # Night light on, sunset to sunrise, warmest settings
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = lib.hm.gvariant.mkUint32 2700;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = true;
      idle-brightness = lib.hm.gvariant.mkUint32 30;
      sleep-display-ac = lib.hm.gvariant.mkUint32 (60 * 60);
      sleep-display-battery = lib.hm.gvariant.mkUint32 (30 * 60);
      sleep-inactive-ac-timeout = lib.hm.gvariant.mkInt32 1800; # 30 minutes
    };

    "org/gnome/desktop/screensaver" = {
      lock-delay = lib.hm.gvariant.mkUint32 1800; # 30 minutes
    };
  };
}
