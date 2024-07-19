{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    sway
    waybar
    rofi
    lxappearance
    gnome-themes-extra
    mako
  ];

  # services.gnome.gnomeSettingsDaemon.enable = true;

  # xdg.configFile = {
  #   ".config/sway/config" = swayConfig;
  #   ".config/waybar/config" = waybarConfig;
  #   ".config/waybar/style.css" = waybarStyle;
  #   ".config/mako/config" = makoConfig;
  # };

  # home.sessionVariables = {
  #   XDG_CURRENT_DESKTOP = "sway";
  # };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      floating.criteria = [
        {
          class = ".*";
        }
      ];
    };
  };

  # programs.waybar = {
  #   enable = true;
  #   settings = waybarConfig;
  #   style = waybarStyle;
  # };

  # programs.rofi = {
  #   enable = true;
  #   configFile = builtins.readFile ./rofi/config.rasi;
  # };
}
