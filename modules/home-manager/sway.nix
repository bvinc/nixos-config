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
      modifier = "Mod4";
      floating.criteria = [
        {
          class = ".*";
        }
      ];
      focus.followMouse = "no";
      terminal = "kgx";
      input = {
        "*" = {
          accel_profile = "flat"; # disable mouse acceleration
          pointer_accel = "1.0"; # set mouse sensitivity (between -1 and 1)
        };
      };
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
