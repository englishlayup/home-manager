{ ... }:
let
  theme = import ../theme/gruvbox-dark.nix;
in
{
  wayland.windowManager.hyprland = {
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
        rounding = 5;
        rounding_power = 2;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(${theme.scheme.base00}ee)";
        };
      };

      # Disable animations
      animations.enabled = false;

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
        follow_mouse = 2;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
        };
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
        ## Screenshot a region
        "$mainMod, PRINT, exec, hyprshot --freeze -m region"
        ## Screenshot a window
        ", PRINT, exec, hyprshot --freeze -m window"
        ## Screenshot a monitor
        "$shiftMod, PRINT, exec, hyprshot --freeze -m output"

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
        "match:class ^($browser).*, workspace 2"
        "match:class ^($note-app).*, workspace 3,"
        "match:title YouTube, workspace 4"
        "match:title YouTube Music, workspace 4"
        "match:title Nebula, workspace 4"
        "match:class com.$clipboard, float on"
        "match:class com.$clipboard, size 622 652"
        "match:class com.$clipboard, stay_focused on"
        "match:class .*(NetworkManager|nm-applet|nm-connection-editor|blueman|pavucontrol|pwvucontrol|xdg-desktop-portal-gtk).*, float"
        "match:class .*(NetworkManager|nm-applet|nm-connection-editor|blueman).*, size 500 600"
        "match:class .*(pavucontrol|pwvucontrol|xdg-desktop-portal-gtk).*, size 800 600"
        "match:class .*, suppress_event maximize"
        # "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # Picture in picture
        "match:title Picture in picture, float on"
        "match:title Picture in picture, pin on"
        "match:title Picture in picture, no_initial_focus on"
        "match:title Picture in picture, border_size 0"
        "match:title Picture in picture, opacity 1.0 0.6"
        "match:title Picture in picture, keep_aspect_ratio on"
        "match:title Picture in picture, move 100%-w-0 100%-w-0"
        "match:title Picture in picture, size 640 360"
      ];
    };
  };
}
