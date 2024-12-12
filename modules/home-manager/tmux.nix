{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "tmux-256color";
    plugins = with pkgs; [
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_theme night
          set -g @tokyo-night-tmux_transparent 1
        '';
      }
    ];
    extraConfig = ''
      # DESIGN TWEAKS
      
      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      set -g base-index 1
      set -g pane-base-index 1
    '';
  };
}
