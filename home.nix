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
      nixpkgs-fmt
      steam
    ];
  };

  programs.git.enable = true;
  programs.zsh.enable = true;
}


