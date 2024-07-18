{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations.xenu = nixpkgs.lib.nixosSystem {
        system = system;
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
            # nixpkgs.overlays = [
            #   (final: prev: {
            #     gnome.gnome-shell = unstable.packages.${system}.gnome.gnome-shell;
            #     gnome.mutter = unstable.packages.${system}.gnome.mutter;
            #   })
            # ];
            # nixpkgs.overlays = [
            #   # GNOME 46: triple-buffering-v4-46
            #   (final: prev: {
            #     gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
            #       mutter = gnomePrev.mutter.overrideAttrs (old: {
            #         src = prev.fetchFromGitLab {
            #           domain = "gitlab.gnome.org";
            #           owner = "GNOME";
            #           repo = "mutter";
            #           rev = "9239e8446cf43e82416cbc3fd11d9502daf78ec0";
            #           hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
            #         };
            #       });
            #     });
            #   })
            # ];
            # Enable triple buffering patch for GNOME
            nixpkgs.overlays = [
              # GNOME 46: triple-buffering-v4-46
              (final: prev: {
                gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
                  mutter = gnomePrev.mutter.overrideAttrs (old: {
                    src = pkgs.fetchFromGitLab {
                      domain = "gitlab.gnome.org";
                      owner = "vanvugt";
                      repo = "mutter";
                      rev = "fdsafd-46";
                      hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEff5b9mu3aS+jhH18+lpI=";
                    };
                  });
                });
              })
            ];

          }
        ];
      };
    };
}
