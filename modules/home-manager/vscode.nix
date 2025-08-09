{ pkgs, ... }:
let
  # Panda Syntax theme (publisher: tinkertrain) from the VS Code Marketplace.
  # Leave sha256 as lib.fakeHash initially; Nix will print the real hash on first build.
  pandaTheme = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "theme-panda";
      publisher = "tinkertrain";
      version = "1.4.0";
      sha256 = "sha256-3iCKgHVjD2qnVsLtSa7NVHBHnLl2jdHKpuQewO9TZuk=";
    }
  ];
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default = {
      enableUpdateCheck = false;
      extensions = (with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        jnoortheen.nix-ide
        ms-python.python
        ms-vscode-remote.remote-ssh
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        yzhang.markdown-all-in-one
      ]) ++ pandaTheme;
      userSettings = {
        "telemetry.telemetryLevel" = "off";
        "editor.inlayHints.enabled" = "offUnlessPressed";
        "rust-analyzer.check.command" = "clippy";
        "workbench.colorTheme" = "Panda Syntax";
        "editor.formatOnSave" = true;
        "rust-analyzer.imports.granularity.group" = "module";
      };
    };
  };
}
