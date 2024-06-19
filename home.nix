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
      gcc
      gnome3.gnome-terminal
      gnome3.gnome-tweaks
      grc
      llvm
      nixpkgs-fmt # nix formatter
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

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = lib.hm.gvariant.mkString ("<Alt><Control>t");
      command = lib.hm.gvariant.mkString ("gnome-terminal");
      name = lib.hm.gvariant.mkString ("Open terminal");
    };

  };
}


