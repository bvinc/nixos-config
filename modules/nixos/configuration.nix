{ pkgs, ... }: {
  # Prevent /boot from filling up
  boot.loader.grub.configurationLimit = 5;
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 30d";
  };

  boot.tmp.cleanOnBoot = true;

  nixpkgs.config.allowUnfree = true;

  # use faster dbus implementation
  services.dbus.implementation = "broker";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable firmware upgrades
  services.fwupd.enable = true;
}
