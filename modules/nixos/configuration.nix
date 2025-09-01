{
  pkgs,
  config,
  ...
}:
{

  imports = [
    ./gnome.nix
    # ./hyprland.nix
    # ./kde.nix
    # ./sway.nix
  ];

  # Prevent /boot from filling up
  boot.loader.systemd-boot.configurationLimit = 5;
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
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = "github:bvinc/nixos-config#" + config.networking.hostName;
  };

  # Disable root password
  users.users.root.hashedPassword = "*";

  # Disable password login
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;

  # Auto-discover printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gdb
    git
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gsconnect
    killall
    signal-desktop
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  services.udev.packages = [ pkgs.gnome-settings-daemon ];
}
