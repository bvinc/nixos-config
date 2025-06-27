{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # local-mutter = {
    #   url = "path:/home/brain/src/mutter";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      unstable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations.werm = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./hosts/werm/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.brain = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          { }
        ];
      };
      nixosConfigurations.xenu = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./hosts/xenu/configuration.nix
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
            #   # GNOME 46: triple-buffering-v4-46
            #   (final: prev: {
            #     gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
            #       mutter = local-mutter;
            #     });
            #   })
            # ];

            # nixpkgs.overlays = [
            #   # GNOME 46: triple-buffering-v4-46
            #   (final: prev: {
            #     gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
            #       mutter = gnomePrev.mutter.overrideAttrs (old: {
            #         src = local-mutter.src;
            #         mesonFlags = local-mutter.mesonFlags;
            #       });
            #     });
            #   })
            # ];

          }
        ];
      };
    };
}
