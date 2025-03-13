{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      jnoortheen.nix-ide
      ms-python.python
      ms-vscode-remote.remote-ssh
      rust-lang.rust-analyzer
      yzhang.markdown-all-in-one
    ];
    userSettings = {
      "telemetry.telemetryLevel" = "off";
      "editor.inlayHints.enabled" = "offUnlessPressed";
      "rust-analyzer.check.command" = "clippy";
      "workbench.colorTheme" = "Panda Syntax";
      "editor.formatOnSave" = true;
      "rust-analyzer.imports.granularity.group" = "module";
    };
  };
}
