{ config, pkgs, lib, ... }:


{
  imports = [
    ./modules/home-manager/dark_mode.nix
    ./modules/home-manager/firefox.nix
    ./modules/home-manager/fish.nix
    ./modules/home-manager/sway.nix
    ./modules/home-manager/vscode.nix
  ];

  home.stateVersion = "24.11";

  home = {
    enableDebugInfo = true;
    packages = with pkgs; [
      cmake
      curl
      expat
      extremetuxracer
      file
      freetype
      gcc
      gnome-terminal
      gnome-tweaks
      dconf-editor
      grc
      gtk4
      killall
      llvm
      lutris-free
      nixpkgs-fmt # nix formatter
      openssl
      pkg-config
      ripgrep
      spotify
      steam
      traceroute
      unzip
      wget
    ];
  };

  programs.git.enable = true;
  programs.zsh.enable = true;

  dconf.settings = {
    # Blank Screen Delay
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 [ 900 ]; # 15 minutes
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
      "switch-windows" = [ "<Alt>Tab" "<Super>Tab" ];
      "switch-windows-backward" = [ "<Shift><Alt>Tab" "<Super><Shift>Tab" ];
    };

    # Night light on, sunset to sunrise, warmest settings
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = lib.hm.gvariant.mkUint32 [ 1700 ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = lib.hm.gvariant.mkInt32 [ 1800 ]; # 30 minutes
    };

    "org/gnome/desktop/screensaver" = {
      lock-delay = lib.hm.gvariant.mkUint32 [ 1800 ]; # 30 minutes
    };
  };
}


