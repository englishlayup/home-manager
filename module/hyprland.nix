{ ... }:
let
  theme = import ../theme/gruvbox-dark.nix;
in
{
  wayland.windowManager.hyprland = {
    systemd.enable = false;
    enable = true;
    settings = {
      # Monitors
      monitor = [
        "eDP-1,highres@highrr,auto,auto"
        "Virtual-1,highres@highrr,auto,1"
        ",preferred,auto,1"
      ];

      # Programs
      "$terminal" = "ghostty";
      "$fileManager" = "yazi";
      "$clipboard" = "clipse";
      "$menu" = "wofi --show drun";
      "$browser" = "brave";
      "$note-app" = "obsidian";
      "$lockCmd" = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.

      # Autostart
      exec-once = [
        "nm-applet --indicator &"
        "blueman-applet &"
        "systemctl --user start hyprpolkitagent"
        "clipse -listen"
        "wl-paste --type text --watch clipse -store-text"
        "wl-paste --type image --watch clipse -store-image"
        "~/.local/scripts/set-random-wallpaper.sh"
        "$browser"
        "$note-app"
        "$terminal"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      # General settings
      general = {
        gaps_in = 2;
        gaps_out = 5;
        border_size = 3;
        "col.active_border" = "rgba(${theme.scheme.base16}ee) rgba(${theme.scheme.base14}ee) 45deg";
        "col.inactive_border" = "rgba(${theme.scheme.base04}aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = false;
          range = 4;
          render_power = 3;
          color = "rgba(${theme.scheme.base00}ee)";
        };

        blur = {
          enabled = false;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # Animations
      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Master layout
      master = {
        new_status = "master";
      };

      # Misc settings
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = false;
      };

      # Input settings
      input = {
        kb_layout = "us,us";
        kb_variant = ",intl";
        kb_options = "caps:escape,grp:alt_shift_toggle";
        follow_mouse = 2;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
        };
      };

      # Gestures
      gestures = {
        workspace_swipe = false;
      };

      # Per-device config
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      # Main modifier key
      "$mainMod" = "SUPER";

      # Keybindings
      bind = [
        # Window management
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod, P, pseudo,"
        "$mainMod SHIFT, RETURN, exec, $lockCmd"
        "$mainMod, F, fullscreen, 1"
        "$mainMod, O, exec, ~/.local/scripts/toggle-pip-opacity.sh"

        # Screenshot
        ## Screenshot a window
        "$mainMod, PRINT, exec, hyprshot -m window"
        ## Screenshot a monitor
        ", PRINT, exec, hyprshot -m output"
        ## Screenshot a region
        "$shiftMod, PRINT, exec, hyprshot -m region"

        # Application launchers
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, B, exec, $browser"
        "$mainMod, D, exec, $menu"
        "$mainMod, E, exec, $terminal --class=com.$fileManager -e $fileManager"
        "$mainMod, V, exec, $terminal --class=com.$clipboard -e $clipboard"

        # Move focus (vim-like)
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Move windows (vim-like with shift)
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        # Switch workspaces
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

        # Move to workspace
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

        # Special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Volume and brightness keys
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      # Media keys
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Window rules
      windowrule = [
        "workspace 2, class:^($browser).*"
        "workspace 3, class:^($note-app).*"
        "workspace 4, initialTitle:YouTube"
        "workspace 4, initialTitle:YouTube Music"
        "workspace 4, initialTitle:Nebula"

        "float, class:com.$clipboard"
        "size 622 652, class:com.$clipboard"
        "stayfocused, class:com.$clipboard"
        "float, class:.*(NetworkManager|nm-applet|nm-connection-editor|blueman|pavucontrol|pwvucontrol|xdg-desktop-portal-gtk).*"
        "size 500 600, class:.*(NetworkManager|nm-applet|nm-connection-editor|blueman).*"
        "size 800 600, class:.*(pavucontrol|pwvucontrol|xdg-desktop-portal-gtk).*"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # Picture in picture
        "float, title:Picture in picture"
        "pin, title:Picture in picture"
        "noinitialfocus, title:Picture in picture"
        "noborder, title:Picture in picture"
        "opacity 1.0 0.6, title:Picture in picture"
        "keepaspectratio, title:Picture in picture"
        "move 100%-w-0 100%-w-0, title:Picture in picture"
        "size 640 360, title:Picture in picture"
      ];
    };
  };
}
