{ pkgs, ... }: {
  # Enable firmware upgrades
  services.fwupd.enable = true;
}
