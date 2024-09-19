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

  # Enable firmware upgrades
  services.fwupd.enable = true;
}
