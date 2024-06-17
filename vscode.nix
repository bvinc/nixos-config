{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      yzhang.markdown-all-in-one
    ];
    userSettings = {
      "telemetry.telemetryLevel" = "off";
    };
  };
}
