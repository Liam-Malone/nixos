{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        # source = "nixos";
        source = "$HOME/pictures/smol-penguin.png";
        type = "kitty";
        # width = 18;
        # height = 9;
        # color = {
        #     "1" = "white";
        #     "2" = "green";
        # };
        padding = { 
          top = 1; # put this on 2 for picture source
          left = 1;
          right = 2;
        };
      };
      display = {
        separator = " -> ";
        color = {
            keys = "green";
        };
      };
      modules = [
        "title"
        {
          type = "custom";
          format = "────────── Env ──────────";
          color = "green";
        }
        {
          type = "os";
          key = "OS ";
        }
        {
          type = "wm";
          key = "WM ";
        }
        "editor"
        "break"
        {
          type = "custom";
          format = "────────── Sys ──────────";
        }
        "cpu"
        "gpu"
        {
          type = "memory";
          key = "MEM";
        }
        "vulkan"
        "disk"
        "battery"
        {
            type = "custom";
            format = "─────────────────────────";
        }
        "break"
        "colors"
        "break"
      ];
    };
  };
}
