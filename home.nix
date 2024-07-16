{ config, pkgs, lib, ... }:


{
  imports = [
    ./dark_mode.nix
    ./firefox.nix
    ./vscode.nix
    ./shell.nix
  ];

  home.stateVersion = "24.05";

  home = {
    packages = with pkgs; [
      extremetuxracer
      gcc
      gnome3.gnome-terminal
      gnome3.gnome-tweaks
      gnome3.dconf-editor
      grc
      llvm
      lutris-free
      nixpkgs-fmt # nix formatter
      spotify
      steam
      traceroute
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
  };
}


