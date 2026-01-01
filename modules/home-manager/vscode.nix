{ pkgs, ... }:
let
  # Panda Syntax theme (publisher: tinkertrain) from the VS Code Marketplace.
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
  xdg.mimeApps.defaultApplications = {
    "text/x-csharp" = [ "code.desktop" ];
    "text/x-nix" = [ "code.desktop" ];
    "text/x-python" = [ "code.desktop" ];
    "application/javascript" = [ "code.desktop" ];
    "text/typescript" = [ "code.desktop" ];
    "application/json" = [ "code.desktop" ];
    "application/yaml" = [ "code.desktop" ];
    "text/markdown" = [ "code.desktop" ];
    "text/x-shellscript" = [ "code.desktop" ];
    "text/x-rust" = [ "code.desktop" ];
    "text/x-go" = [ "code.desktop" ];
    "text/x-java" = [ "code.desktop" ];
    "text/x-c" = [ "code.desktop" ];
    "text/x-c++" = [ "code.desktop" ];
    "application/xml" = [ "code.desktop" ];
    "text/plain" = [ "code.desktop" ];
  };

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default = {
      enableUpdateCheck = false;
      extensions =
        (with pkgs.vscode-extensions; [
          dracula-theme.theme-dracula
          jnoortheen.nix-ide
          ms-python.python
          ms-vscode-remote.remote-ssh
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          yzhang.markdown-all-in-one
        ])
        ++ pandaTheme;
      userSettings = {
        "editor.formatOnSave" = true;
        "editor.inlayHints.enabled" = "offUnlessPressed";
        "rust-analyzer.check.command" = "clippy";
        "rust-analyzer.imports.granularity.group" = "module";
        "telemetry.telemetryLevel" = "off";
        "workbench.colorTheme" = "Panda Syntax";
      };
    };
  };
}
