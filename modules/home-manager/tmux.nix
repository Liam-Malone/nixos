{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.bash}/bin/bash";
    clock24 = true;
    terminal = "tmux-256color";
    plugins = with pkgs; [
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.catpuccin;
        extraConfig = ''
          set -g @catpuccin_flavour 'frappe'
          set -g @catpuccin_date_time "%H:%M"
        '';
      }
    ];
  };
}
