{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.codex.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable the codex command (wrapper for OpenAI CLI via npx and Node.js 22).";
  };

  config = mkIf config.codex.enable {
    home.packages = [
      pkgs.nodejs_22
      (pkgs.writeShellApplication {
        name = "codex";
        runtimeInputs = [ pkgs.nodejs_22 ];
        text = ''
          exec npx @openai/codex "$@"
        '';
      })
    ];
  };
}
