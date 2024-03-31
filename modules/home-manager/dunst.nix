{ config, pkgs, lib, ... }:

{
  services.dunst = {
    enable = true;
    iconTheme = pkgs.arc-icon-theme;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "top-right";
        transparency = 10;
        frame_color = "#22bbff";
        font = "FiraCodeNerdFont";
      };

      urgency_low = {
        background = "#37474f";
        foreground = "#ecefff";
        timeout = 5;
      };
      urgency_normal = {
        background = "#37474f";
        foreground = "#ecefff";
        timeout = 5;
      };
      urgency_high = {
        background = "#cc474f";
        foreground = "#ecefff";
        timeout = 5;
      };
    };
  };
}
