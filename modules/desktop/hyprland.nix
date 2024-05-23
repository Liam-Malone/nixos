{
  config,
  inputs,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  imports = with inputs; [
    # hypridle.homeManagerModules.default
    # hyprlock.homeManagerModules.default
    # hyprpaper.homeManagerModules.default
  ];
  home.packages = with pkgs; [
    hyprpicker
    hyprlock
    hypridle
  ];
  wayland.windowManager.hyprland = {
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [
        "--all"
      ];
    };
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
    settings = {
      monitor = [
        "eDP-1,1920x1080@60,0x0,1"
        "HDMI-A-1,2550x1440@144,auto,1,mirror,eDP-1 "
        ",preferred,auto,1,mirror,eDP-1"
      ];
      exec-once = [
        "wl-clipboard-history -t"
        "wl-paste -p --watch wl-copy -p ''"
        "swww init"
      ];
      env = [
        "HYPRCURSOR_THEME,${config.gtk.cursorTheme.name}"
        "HYPRCURSOR_SIZE,24"
        "WLR_NO_HARDWARE_CURSORS,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,Hyprland;xcb"
      ];
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;
        numlock_by_default = true;

        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          middle_button_emulation = true;
          drag_lock = false;
          tap-to-click = true;
        };
        sensitivity = 0;
      };
      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgba(00ffb2ff) rgba(00ff66ff) 90deg";
        "col.inactive_border" = "rgba(595959ff)";
        layout = "dwindle";
      };

      misc = {
        disable_hyprland_logo = false;
        disable_splash_rendering = false;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          xray = true;
          new_optimizations = "on";
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;

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

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_is_master = true;
      };

      gestures = {
        workspace_swipe = true;
      };

      windowrule = [
        "idleinhibit fullscreen, firefox"
        "idleinhibit fullscreen, floorp"
        "idleinhibit fullscreen, ghostty"
        "idleinhibit focus, firefox"
        "idleinhibit focus, floorp"
        "idleinhibit focus, mpv"
        "idleinhibit focus, ^(emacs)$"
        "idleinhibit focus, ^(Emacs)$"
        "idleinhibit focus, ^(discord)$"
        "idleinhibit focus, ^(Discord)$"
        "idleinhibit focus, ^(spotify)$"
        "float, polkit-kde-authentication-agent-1"
        "float, ^(praat)$"
        "float, ^(network)$"
        "float, ^(nm-)$"
        "float, ^(Network)$"
        "float, Rofi"
        "float, Gimp"
        "float, Nautilus"
        "float, notification"
        "float, ^(launcher)$"
        "tile, Spotify"
        "tile, Minecraft"
        "workspace 2, KeePassXC"
        "workspace 3, firefox"
        "workspace 3, floorp"
        "workspace 4, Spotify"
        "workspace 6, discord"
        "workspace 6, Signal"
        "workspace 10, Minecraft"
      ];

      "$mainMod" = "SUPER";
      "$altMod" = "ALT";
      "$ctrlMod" = "CTRL";


      # used for screenshots
      "$screenshotarea" = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copy area; hyprctl keyword animation 'fadeOut,1,4,default'";
      # for locking screen
      "$lock" = "${pkgs.systemd}/bin/loginctl lock-session;${pkgs.hyprlock}/bin/hyprlock";

      bind = [
        # "$mainMod, grave, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable
        "$altMod, Return, exec, ghostty"
        "$mainMod, Return, exec, ghostty" # for apps that yoink alt- binds
        "$altMod SHIFT, Return, exec, alacritty"
        "$mainMod SHIFT, D, exec, discord --enable-blink-features=MiddleClickAutoscroll"
        "$mainMod SHIFT, E, exec, emacsclient -c -a 'emacs'"
        "$mainMode SHIFT, F, exec, focus-linux"
        "$mainMod, SPACE, exec, pkill wofi || wofi"
        "$mainMod, E, exec, nautilus"
        "$mainMod, S, exec, spotify"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, C, killactive,"
        "$mainMod control, Q, exec, $lock"
        "$mainMod, F4, exit,"
        "$mainMod, V, togglefloating, "
        "$mainMod SHIFT, S, togglesplit," # dwindle
        "$mainMod, F, fullscreen,"

        # Screenshot
        ", Print, exec, $screenshotarea"
        "SHIFT, Print, exec, grimblast --notify --cursor copy output"

        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod, comma, focusmonitor, -1"
        "$mainMod, period, focusmonitor, +1"
        
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"
        "$mainMod SHIFT, comma, movecurrentworkspacetomonitor, -1"
        "$mainMod SHIFT, period, movecurrentworkspacetomonitor, +1"

        "$mainMod, right, resizeactive, 10 0"
        "$mainMod, left, resizeactive, -10 0"
        "$mainMod, up, resizeactive, 0 -10"
        "$mainMod, down, resizeactive, 0 10"

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
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod SHIFT CTRL, right, movetoworkspace, +1"
        "$mainMod SHIFT CTRL, left, movetoworkspace, -1"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Tab through existing workspaces
        "$mainMod, Tab, workspace, e+1"
        "$mainMod SHIFT, Tab, workspace, e-1"

        "$mainMod CTRL, right, workspace, +1"
        "$mainMod CTRL, left, workspace, -1"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
      ];

      binde = [
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"      
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

    };
    extraConfig = ''
        bind = $mainMod, R, submap, resize
        submap = resize
        bind=, escape,submap,reset

        binde=, left, resizeactive, -10 0
        bindr=, left, submap, reset
        binde=, right, resizeactive, 10 0
        bindr=, right, submap, reset
        binde=, up, resizeactive, 0 10
        bindr=, up, submap, reset
        binde=, down, resizeactive, 0 -10
        bindr=, down, submap, reset

        binde=, H, resizeactive, -10 0
        bindr=, H, submap, reset
        binde=, J, resizeactive, 0 -10
        bindr=, J, submap, reset
        binde=, K, resizeactive, 0 10
        bindr=, K, submap, reset
        binde=, L, resizeactive, 10 0
        bindr=, L, submap, reset

        submap=reset

        bind = $mainMod, B, submap, browser_select
        submap = browser_select

        bind =, B, exec, brave --enable-blink-features=MiddleClickAutoscroll
        bind =, B, submap, reset

        bind = SHIFT, F, exec, firefox
        bind = SHIFT, F, submap, reset

        bind =, F, exec, floorp
        bind =, F, submap, reset

        bind =, C, exec, floorp -p limalone -no-remote
        bind =, C, submap, reset

        bind=, escape,submap,reset
        submap=reset

        bind = $mainMod SHIFT, V, submap, video_stuff
        submap = video_stuff
        bind = , O, exec, obs
        bind = , O, submap, reset
        bind = , V, exec , kdenlive
        bind = , V, submap, reset

        bind=, escape,submap,reset
        submap = reset
        '';
#        plugin {
#          hyprexpo {
#            columns = 3
#            gapSize = 4
#            workspace_method = "center current"
#            enable_gesture = true
#            gesture_distance = 300
#            gesture_negative = true
#          }
#        }
  };
  lib.inputMethod.fcitx5.waylandFrontend = true;
  programs.hyprlock = {
    enable = true;
    settings = {
      general = { 
        disable_loading_bar = true;
        hide_cursor = true;
        no_fade_in = false;
        grace = 10;
      };
      background = [
        {
          path = "/home/liamm/pictures/desert.png";
          blur_passes = 2;
          blur_size = 8;
        }
      ];
      input-field = [
      {
          # size = "200, 50";
          outline_thickness = 3;
          outer_color = "#fe0b00";
          inner_color = "#0c0c0c";
          font_color = "#efefef";
          check_color = "#0eff0d";
          fail_color = "#ff009e";
          capslock_color = "#bb00ee";
          placeholder_text = "<i>Input Password...</i>";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
      }
      ];
      label = [
        {
          text = "$TIME";
          text_align = "center";
          color = "";
          font_size = 28;
          font_family = builtins.head osConfig.fonts.fontconfig.defaultFonts.sansSerif;
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock"; # avoid starting multiple sessions
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on"; # to avoid having to hit key twice to turn on display
      };
      listeners = [
        {
          timeout = 120;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r"; # monitor backlight restor.
        }
        {
          timeout = 120;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
        }
        {
          timeout = 180;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 300;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 300;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend"; # suspend pc
        }
      ];
    };
  };
}
