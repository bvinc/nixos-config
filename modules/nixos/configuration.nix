{ pkgs, ... }: {

  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./kde.nix
    ./sway.nix
  ];

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

  # https://nixos.org/manual/nixos/stable/index.html#sec-upgrading-automatic
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Disable root password
  users.users.root.hashedPassword = "*";

  # Disable password login
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;
}
