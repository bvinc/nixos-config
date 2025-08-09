# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./openrgb.nix
    ../../modules/nixos/configuration.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # boot.kernelParams = [
  #   "i915.force_probe=!56a0"
  #   "xe.force_probe=56a0"
  # ];

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    graphics.extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      vpl-gpu-rt
      intel-compute-runtime
    ];
    graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      vaapiIntel
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."swap" = {
    device = "/dev/nvme0n1p3";
  };
  boot.initrd.luks.devices."root" = {
    allowDiscards = true;
  };

  networking.hostName = "xenu"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.libinput.mouse.accelProfile = "flat";

  # Enable sound.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brain = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.enableDebugInfo = true;

  # To allow third-party un-packaged non-static binaries to run
  programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.fstrim.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 51413 ];
  networking.firewall.allowedUDPPorts = [ 51413 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  # Enable flakes support
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable podman for toolbox
  virtualisation.podman.enable = true;
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Needed for sway in home manager
  security.polkit.enable = true;

  # # Enable triple buffering patch for GNOME
  # nixpkgs.overlays = [
  #   # GNOME 46: triple-buffering-v4-46
  #   (final: prev: {
  #     gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
  #       mutter = gnomePrev.mutter.overrideAttrs (old: {
  #         src = pkgs.fetchFromGitLab {
  #           domain = "gitlab.gnome.org";
  #           owner = "vanvugt";
  #           repo = "mutter";
  #           rev = "triple-buffering-v4-46";
  #           hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
  #         };
  #       });
  #     });
  #   })
  # ];

  # nixpkgs.overlays = [
  #   # GNOME 46: triple-buffering-v4-46
  #   (final: prev: {
  #     gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
  #       mutter = gnomePrev.mutter.overrideAttrs (old: {
  #         src = pkgs.fetchFromGitLab {
  #           domain = "gitlab.gnome.org";
  #           owner = "GNOME";
  #           repo = "mutter";
  #           rev = "fdsa";
  #           hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
  #         };
  #       });
  #     });
  #   })
  # ];

  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N
  '';

}
