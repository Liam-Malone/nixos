{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "tmux-256color";
    plugins = with pkgs; [
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catpuccin_flavour 'frappe'
          set -g @catpuccin_date_time "%H:%M"
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
      
      # copy mode
      setw -g mode-style 'fg=colour1 bg=colour18 bold'
     
      # messages
      set -g message-style 'fg=colour2 bg=colour0 bold'
    '';
  };
}
