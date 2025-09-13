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

          for arg in "$@"; do
            case "$arg" in
              *)
                dir="$arg"
                ;;
            esac
          done

          mkdir -p "$dir"
          cd "$dir"

          [[ -f .gitignore ]] || cat > .gitignore <<'EOF'
          /target
          /.direnv
          EOF

          [[ -f .envrc ]] || echo 'use flake' > .envrc

          [[ -f flake.nix ]] || cat > flake.nix <<'EOF'
          {
            description = "Rust dev env with fenix";

            inputs = {
              nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
              fenix.url = "github:nix-community/fenix";
              fenix.inputs.nixpkgs.follows = "nixpkgs";
              flake-utils.url = "github:numtide/flake-utils";
            };

            outputs = { self, nixpkgs, fenix, flake-utils, ... }:
              flake-utils.lib.eachDefaultSystem (system:
                let
                  pkgs = import nixpkgs { inherit system; };
                  toolchain = fenix.packages.''${system}.stable.toolchain.withComponents [
                        "cargo"
                        "clippy"
                        "rust-src"
                        "rustc"
                        "rustfmt"
                  ];
                  ra = fenix.packages.''${system}.rust-analyzer;
                in {
                  devShells.default = pkgs.mkShell {
                    buildInputs = [ toolchain ra ];
                  };
                });
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
