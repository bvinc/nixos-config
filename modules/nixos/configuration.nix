{ pkgs, ... }: {
  # Prevent /boot from filling up
  boot.loader.grub.configurationLimit = 5;
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 30d";
  };

  # Enable firmware upgrades
  services.fwupd.enable = true;
}
