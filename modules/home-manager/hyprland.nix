{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  home.packages = with pkgs; [ hyprpicker ];
  wayland.windowManager.hyprland = {
    enable = true;
    # plugins = [];
    systemd = {
      enable = true;
      # extraCommands = [];
      # variables = ["-all"];
    };
    settings = {
      monitor = [
        (lib.mkIf (osConfig.networking.hostName == "nixlaptop") "eDP-1,1920x1080@60,0x0,1")
        (lib.mkIf (osConfig.networking.hostName == "nixgamer") "DP-1,2560x1440@144,1920x0,1")
        ",preferred,auto,1"
      ];
      # Trays and similar are systemd service bound to graphical-session.target
      exec-once = [ "hyprctl setcursor ${config.gtk.cursorTheme.name} 24" ];
      env = [ "XCURSOR_SIZE,24" ];
      input = {
        kb_layout = "ie";
        kb_variant = "";
        kb_model = "pc104";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };
      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = config.variables.gaps.inner.int;
        gaps_out = config.variables.gaps.outer.int;
        border_size = config.variables.border.width.wide.int;
        "col.active_border" = "rgb(${config.colorScheme.palette.base09})";
        # "col.active_border" = "rgb(${config.colorScheme.palette.base09}) rgb(${config.colorScheme.palette.base06}) 45deg";
        "col.inactive_border" = "rgb(${config.colorScheme.palette.base00})";
        layout = "dwindle";
      };

      misc = {
        # Get rid of anime girl jumpscare
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = config.variables.border.radius.int;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgb(${config.colorScheme.palette.base00})";
      };

      animations = {
        enabled = true;

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true;
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = true;
      };

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mainMod" = "SUPER";

      bind =
        let
          scriptDir = ./scripts;
        in
        [
          ",XF86MonBrightnessUp  , exec, ${scriptDir}/brightness.sh increase"
          ",XF86MonBrightnessDown, exec, ${scriptDir}/brightness.sh decrease"
          ",XF86AudioRaiseVolume , exec, ${scriptDir}/volume.sh increase"
          ",XF86AudioLowerVolume , exec, ${scriptDir}/volume.sh decrease"
          ",XF86AudioMute        , exec, ${scriptDir}/volume.sh toggle"
          ",XF86AudioMicMute     , exec, ${scriptDir}/mic.sh toggle"
          ",Caps_Lock            , exec, ${scriptDir}/capsLock.sh"

          "$mainMod, t, exec, wezterm"
          "$mainMod, Space, exec, anyrun"
          "$mainMod, p, exec, ${scriptDir}/screencap.sh"
          "$mainMod, w, exec, ${scriptDir}/win-vm.sh"
          "$mainMod, i, exec, ${scriptDir}/sleep-toggle.sh"
          "$mainMod, r, exec, ${pkgs.ironbar}/bin/ironbar reload"
          "$mainMod, b, exec, flatpak run org.mozilla.firefox"
          "$mainMod, e, exec, flatpak run org.mozilla.Thunderbird"
          "$mainMod, l, exec, swaylock"
          "$mainMod, c, killactive,"
          "$mainMod, m, exit,"
          "$mainMod, v, togglefloating,"
          "$mainMod, f, fullscreen, # fullscreen"
          "$mainMod, s, togglesplit, # dwindle"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Helps ensure that workspace 1 is always on main monitor for each pc
    };
    xwayland.enable = true;
  };
}
