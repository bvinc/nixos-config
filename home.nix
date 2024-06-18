{ config, pkgs, ... }:


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
}


