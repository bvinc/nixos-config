{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, unstable, ... }@inputs: {
    nixosConfigurations.xenu = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.brain = import ./home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
        {
          nixpkgs.overlays = [
            (final: prev: {
              mutter = unstable.mutter;
              # gnome-shell = prev.gnome-shell.overrideAttrs (oldAttrs: rec {
              #   buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ unstable.mutter ];
              # });
              gnome-shell = unstable.gnome.gnome-shell;
            })
          ];
        }
      ];
    };
  };
}
