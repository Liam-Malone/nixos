{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      general.live_config_reload = false;
      font = {
        normal.family = "FiraCodeNerdFontMono";
        size = 16;
      };
      window = {
        dimensions = {
          lines = 20;
          columns = 200;
        };
        padding = {
          x = 8;
          y = 8;
        };
        decorations = "None";
        opacity = 0.80;
        blur = true;
      };
      colors = {
        primary = {
          background =  "#0c0c0c";
          foreground =  "#cccccc";
        };
        normal = {
          black =      "#0c0c0c"; 
          red =        "#c50f1f"; 
          green =      "#13a10e"; 
          yellow =     "#c19c00"; 
          blue =       "#0037da"; 
          magenta =    "#881798"; 
          cyan =       "#3a96dd"; 
          white =      "#cccccc"; 
        };
        bright = {
          black =      "#767676"; 
          red =        "#e74856"; 
          green =      "#16c60c"; 
          yellow =     "#f9f1a5"; 
          blue =       "#3b78ff"; 
          magenta =    "#b4009e"; 
          cyan =       "#61d6d6"; 
          white =      "#f2f2f2"; 
        };
        draw_bold_text_with_bright_colors = true;

      };
    };
  };
}
