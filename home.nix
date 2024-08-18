{ config, pkgs, lib, ... }:


{
  imports = [
    ./dark_mode.nix
    ./firefox.nix
    ./fish.nix
    ./sway.nix
    ./vscode.nix
  ];

  home.stateVersion = "24.05";

  home = {
    enableDebugInfo = true;
    packages = with pkgs; [
      curl
      extremetuxracer
      file
      gcc
      gnome3.gnome-terminal
      gnome3.gnome-tweaks
      gnome3.dconf-editor
      grc
      killall
      llvm
      lutris-free
      nixpkgs-fmt # nix formatter
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


