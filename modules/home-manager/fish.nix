{ pkgs, ... }:
{
  programs.bash.enable = true;
  programs.bash = {
    # Switch to fish if its an interactive shell
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      theme_gruvbox dark hard
      abbr nrs sudo nixos-rebuild switch --flake ~/.config/nixos-config
      if test -f "$HOME/.cargo/env.fish"; source "$HOME/.cargo/env.fish"; end
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "gruvbox";
        src = pkgs.fishPlugins.gruvbox.src;
      }

      # Manually packaging and enable a plugin
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
    ];
  };

  # grc's mtr colorizer breaks modern mtr: its parser waits for \r/\n line
  # endings that current mtr no longer emits, so wrapped `mtr` produces no
  # output. Exclude mtr from the grc fish plugin (everything else stays
  # colorized). The plugin reads $grc_plugin_ignore_execs when its conf.d
  # runs, so this file is named to sort before plugin-grc.fish.
  xdg.configFile."fish/conf.d/00-grc-ignore.fish".text = ''
    set -g grc_plugin_ignore_execs mtr
  '';
}
