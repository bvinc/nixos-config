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
    ./tailscale.nix
  ];

  # Prevent /boot from filling up
  boot.loader.systemd-boot.configurationLimit = 5;
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 30d";
  };

  hardware.bluetooth.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
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

  # Define a user account.
  users.users.brain = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHH2gxXw0dRdxbnkjGGcag/pLVkNLYq4LswQKVs3PmdA brain@xenu"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMI0j9Dcs3iUKjaWctqWqVApkubmwohKJ+75UDIUkuO brain@werm"

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjs1Q2CfVzmr3V4Amm9LqDafPEBTHA6nCxQASShRvg2 termius"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDW4KzsqCEux5L1fcW4bnr7L4ByD2N4L+97MT7OUWuiqd98qIN5sRWPDZG4ZBxJvmRZK7qLDgpP3TwNik31blOI= termius2"
    ];
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

    # gnome video codec stuff
    gnome-video-effects
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base

    killall
    signal-desktop
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  services.udev.packages = [ pkgs.gnome-settings-daemon ];
}
