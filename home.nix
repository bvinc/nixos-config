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
      gnome3.gnome-tweaks
      gnome3.gnome-terminal
      grc
      nixpkgs-fmt
      steam
      traceroute
    ];
  };

  programs.git.enable = true;
  programs.zsh.enable = true;
}


