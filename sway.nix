{ config, pkgs, ... }:

let
  swayConfig = builtins.readFile ./sway/config;
  waybarConfig = builtins.readFile ./waybar/config;
  waybarStyle = builtins.readFile ./waybar/style.css;
  makoConfig = builtins.readFile ./mako/config;
in
{
  home.packages = with pkgs; [
    sway
    waybar
    rofi
    lxappearance
    gnome-themes-extra
    gnome-settings-daemon
    mako
  ];

  services.gnome.gnomeSettingsDaemon.enable = true;

  xdg.configFile = {
    ".config/sway/config" = swayConfig;
    ".config/waybar/config" = waybarConfig;
    ".config/waybar/style.css" = waybarStyle;
    ".config/mako/config" = makoConfig;
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
  };

  programs.sway = {
    enable = true;
    configFile = swayConfig;
  };

  programs.waybar = {
    enable = true;
    configFile = waybarConfig;
    styleFile = waybarStyle;
  };

  programs.rofi = {
    enable = true;
    configFile = builtins.readFile ./rofi/config.rasi;
  };
}
