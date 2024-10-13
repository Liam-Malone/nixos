{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "~/pictures/lil-penguin.png";
        type = "kitty-direct";
        width = 18;
        height = 9;
        padding = { 
          top = 2;
          left = 1;
          right = 3;
        };
      };
      display = {
        separator = " -> ";
      };
      modules = [
        "title"
        {
          type = "custom";
          format = "────────── Env ──────────";
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
        "break"
        "colors"
        "break"
        "break"
      ];
    };
  };
}
