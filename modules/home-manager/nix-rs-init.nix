{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nix-rs-init.enable = lib.mkEnableOption "Enable nix-rs-init Rust scaffolding tool";

  config = lib.mkIf config.nix-rs-init.enable {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "nix-rs-init";
        runtimeInputs = [
          pkgs.cargo
          pkgs.direnv
        ];
        text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          dir="."
          kind="--bin"
          do_cargo=1

          for arg in "$@"; do
            case "$arg" in
              --lib) kind="--lib" ;;
              --bin) kind="--bin" ;;
              --no-cargo) do_cargo=0 ;;
              -h|--help)
                echo "Usage: nix-rs-init [DIR] [--lib|--bin] [--no-cargo]"
                exit 0
                ;;
              *)
                dir="$arg"
                ;;
            esac
          done

          mkdir -p "$dir"
          cd "$dir"

          if [[ $do_cargo -eq 1 && ! -f Cargo.toml ]]; then
            cargo init $kind --vcs=git
          fi

          [[ -f .gitignore ]] || cat > .gitignore <<'EOF'
          /target
          /.direnv
          EOF

          [[ -f .envrc ]] || echo 'use flake' > .envrc

          [[ -f flake.nix ]] || cat > flake.nix <<'EOF'
          {
            inputs = {
              fenix = {
                url = "github:nix-community/fenix";
                inputs.nixpkgs.follows = "nixpkgs";
              };
              nixpkgs.url = "nixpkgs/nixos-unstable";
            };

            outputs = { self, fenix, nixpkgs }: {
              packages.x86_64-linux.default = fenix.packages.x86_64-linux.minimal.toolchain;
              nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                  ({ pkgs, ... }: {
                    nixpkgs.overlays = [ fenix.overlays.default ];
                    environment.systemPackages = with pkgs; [
                      (fenix.complete.withComponents [
                        "cargo"
                        "clippy"
                        "rust-src"
                        "rustc"
                        "rustfmt"
                      ])
                      rust-analyzer-nightly
                    ];
                  })
                ];
              };
            };
          }
          EOF

          if command -v direnv >/dev/null; then
            direnv allow . || true
          fi

          echo "Initialized Rust project in $dir"
        '';
      })
    ];
  };
}
