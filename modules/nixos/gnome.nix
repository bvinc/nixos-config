{ pkgs, ... }: {
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "gnome";

  services.xserver.desktopManager.gnome = {
    enable = true;

    extraGSettingsOverrides = ''
      [org.gnome.desktop.peripherals.mouse]
        accel-profile = "flat"
        speed = 1.00
    '';
  };
}
