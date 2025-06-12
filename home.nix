{ config, pkgs, ... }:

let
  # Gruvbox Dark color scheme - easily switchable
  colors = {
    bg = "1d2021";
    bg1 = "3c3836";
    bg2 = "504945";
    bg3 = "665c54";
    fg = "ebdbb2";
    fg2 = "d5c4a1";
    fg3 = "bdae93";
    red = "fb4934";
    green = "b8bb26";
    yellow = "fabd2f";
    blue = "83a598";
    purple = "d3869b";
    aqua = "8ec07c";
    orange = "fe8019";

    # Modern accent colors
    accent = "8ec07c";
    accent2 = "83a598";
    surface = "32302f";
    overlay = "3c383680";
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "englishlayup";
  home.homeDirectory = "/home/englishlayup";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Terminal
    ghostty
    # CLI Utils
    dust
    dua
    git
    btop
    zoxide
    tldr
    wget
    curl
    tree
    unzip
    zip
    htop
    neofetch
    fd
    ripgrep
    fzf
    jq
    xxd
    # Dev tools
    ## Langauge server, debuger, formatter
    lua-language-server
    clang-tools
    gopls
    pyright
    ruff
    bash-language-server
    buildifier
    shellcheck
    delve
    nixfmt-rfc-style
    ## Package manager
    uv
    fnm
    go
    ## Build tool
    bazelisk
    gnumake
    # Application
    obsidian
    anki-bin
    qt6ct # Qt theming
    lxappearance # GTK theming
    wlogout
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/englishlayup/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    # hint Electron apps to use Wayland:
    NIXOS_OZONE_WL = "1";
  };

  home.sessionPath = [
    "$HOME/.local/scripts"
  ];

  services.syncthing.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_hybrid_key_bindings
      set -g theme_color_scheme gruvbox-dark
    '';
    shellAbbrs = {
      cd = "z";
    };
    functions = {
      cdg = {
        description = "cd relative to git root";
        body = ''
          if test (count $argv) -eq 1
              cd (git rev-parse --show-toplevel 2>/dev/null)/$argv[1]
          else if test (count $argv) -eq 0
              cd (git rev-parse --show-toplevel 2>/dev/null)
          end
        '';
      };
      tmp = {
        description = "create temporary workspace";
        body = ''
          if string match "$argv[1]" = "view"
              cd /tmp/workspaces && cd (ls -t | fzf --preview 'ls -A {}') && return 0
          end
          set r /tmp/workspaces/(xxd -l3 -ps /dev/urandom)
          mkdir -p $r && pushd $r
          git init $r
        '';
      };
      fish_prompt = {
        description = "Write out the prompt";
        body = ''
          set -l last_pipestatus $pipestatus
          set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

          if not set -q __fish_git_prompt_show_informative_status
              set -g __fish_git_prompt_show_informative_status 1
          end
          if not set -q __fish_git_prompt_hide_untrackedfiles
              set -g __fish_git_prompt_hide_untrackedfiles 1
          end
          if not set -q __fish_git_prompt_color_branch
              set -g __fish_git_prompt_color_branch magenta --bold
          end
          if not set -q __fish_git_prompt_showupstream
              set -g __fish_git_prompt_showupstream informative
          end
          if not set -q __fish_git_prompt_color_dirtystate
              set -g __fish_git_prompt_color_dirtystate blue
          end
          if not set -q __fish_git_prompt_color_stagedstate
              set -g __fish_git_prompt_color_stagedstate yellow
          end
          if not set -q __fish_git_prompt_color_invalidstate
              set -g __fish_git_prompt_color_invalidstate red
          end
          if not set -q __fish_git_prompt_color_untrackedfiles
              set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
          end
          if not set -q __fish_git_prompt_color_cleanstate
              set -g __fish_git_prompt_color_cleanstate green --bold
          end

          set -l color_cwd
          set -l suffix
          if functions -q fish_is_root_user; and fish_is_root_user
              if set -q fish_color_cwd_root
                  set color_cwd $fish_color_cwd_root
              else
                  set color_cwd $fish_color_cwd
              end
              set suffix '#'
          else
              set color_cwd $fish_color_cwd
              set suffix '$'
          end

          # Hostname
          if test -n "$SSH_CLIENT"
              set_color brcyan
              echo -n (prompt_hostname)
              echo -n ' '
          end

          # PWD
          set_color $color_cwd
          echo -n (prompt_pwd)
          set_color normal

          printf '%s ' (fish_vcs_prompt)

          set -l status_color (set_color $fish_color_status)
          set -l statusb_color (set_color --bold $fish_color_status)
          set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
          echo -n $prompt_status
          set_color normal

          echo -n "$suffix "
        '';
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitors
      monitor = [
        "eDP-1,highres@highrr,auto,auto"
        ",preferred,auto,1"
      ];

      # Programs
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
      "$browser" = "librewolf";
      "$lockCmd" = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.

      # Autostart
      exec-once = [
        "$terminal"
        "nm-applet --indicator &"
        "waybar & hyprpaper &"
        "systemctl --user start hyprpolkitagent"
        "clipse -listen"
        "hypridle"
        "wl-paste --type text --watch clipse -store-text"
        "wl-paste --type image --watch clipse -store-image"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      # General settings
      general = {
        gaps_in = 8;
        gaps_out = 16;
        border_size = 2;
        "col.active_border" = "rgb(${colors.accent}) rgb(${colors.accent2}) 45deg";
        "col.inactive_border" = "rgba(${colors.bg3}88)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
        no_border_on_floating = false;
      };

      # Decoration
      decoration = {
        rounding = 12;
        active_opacity = 0.98;
        inactive_opacity = 0.92;
        fullscreen_opacity = 1.0;

        shadow = {
          range = 20;
          render_power = 3;
          offset = "0 8";
        };

        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.02;
          contrast = 1.1;
          brightness = 1.2;
          vibrancy = 0.3;
          vibrancy_darkness = 0.5;
          popups = true;
          popups_ignorealpha = 0.6;
        };
      };

      # Animations
      # Smooth modern animations
      animations = {
        enabled = true;
        first_launch_animation = true;

        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];

        animation = [
          "windowsIn, 1, 3, easeOutCubic, popin 30%"
          "windowsOut, 1, 3, fluent_decel, popin 70%"
          "windowsMove, 1, 2, easeinoutsine, slide"
          "fade, 1, 3, easeOutCirc"
          "fadeIn, 1, 3, easeOutCirc"
          "fadeOut, 1, 3, easeOutCirc"
          "fadeSwitch, 1, 3, easeOutCirc"
          "fadeShadow, 1, 3, easeOutCirc"
          "fadeDim, 1, 3, fluent_decel"
          "border, 1, 2, easeOutCirc"
          "borderangle, 1, 30, fluent_decel, once"
          "workspaces, 1, 4, easeOutCubic, fade"
          "specialWorkspace, 1, 3, easeOutCubic, slidevert"
          "layers, 1, 2, easeOutCirc, fade"
        ];
      };

      # Dwindle layout
      # Enhanced dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = false;
        smart_resizing = true;
        force_split = 0;
        special_scale_factor = 0.8;
      };

      # Modern misc settings
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        vrr = 0;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        enable_swallow = true;
        swallow_regex = "^(ghostty)$";
        focus_on_activate = false;
      };

      # Master layout
      master = {
        new_status = "master";
      };

      # Input settings
      input = {
        kb_layout = "us";
        kb_options = "caps:escape";
        follow_mouse = 2;
        mouse_refocus = false;
        sensitivity = 0;
        accel_profile = "flat";

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
          tap-and-drag = true;
          drag_lock = false;
          middle_button_emulation = false;
          clickfinger_behavior = false;
          scroll_factor = 1.0;
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
        "$mainMod, J, togglesplit,"
        "$mainMod SHIFT, RETURN, exec, $lockCmd"

        # Application launchers
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, B, exec, $browser"
        "$mainMod, D, exec, $menu"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, exec, $terminal --class=clipse -e clipse"

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
        # Floating windows
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"

        # Transparency
        "opacity 0.90 0.90, class:^(ghostty)$"
        "opacity 0.95 0.95, class:^(Code)$"
        "opacity 0.85 0.85, class:^(wofi)$"

        # Workspace assignments
        "workspace 2, class:^(librewolf)$"
        "workspace 3, class:^(Code)$"

        # Animations
        "animation popin, class:^(wofi)$"
        "animation slide, class:^(waybar)$"

        # No shadows for certain windows
        "noshadow, floating:0"

        # Clipse rules
        "float, class:(clipse)"
        "size 622 652, class:(clipse)"
        "stayfocused, class:(clipse)"
        "center, class:(clipse)"
        "opacity 0.95 0.95, class:(clipse)"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Duc Tran";
    userEmail = "duc.tran2027@gmail.com";
    extraConfig = {
        push.autoSetupRemote = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg = {
    enable = true;
    configFile = {
      # Neovim configuration
      "nvim" = {
        source = ./nvim;
        recursive = true;
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 42;
        spacing = 0;
        margin-top = 8;
        margin-left = 16;
        margin-right = 16;

        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "network"
          "battery"
          "tray"
          "custom/power"
        ];

        "custom/launcher" = {
          format = " ";
          tooltip = false;
          on-click = "wofi --show drun";
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 40;
          separate-outputs = true;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y (%R)}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#${colors.accent}'><b>{}</b></span>";
              days = "<span color='#${colors.fg2}'><b>{}</b></span>";
              weeks = "<span color='#${colors.aqua}'><b>W{}</b></span>";
              weekdays = "<span color='#${colors.orange}'><b>{}</b></span>";
              today = "<span color='#${colors.red}'><b><u>{}</u></b></span>";
            };
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "婢 {volume}%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              "奄"
              "奔"
              "墳"
            ];
          };
          on-click = "pavucontrol";
          on-scroll-up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
          on-scroll-up = "brightnessctl set 5%+";
          on-scroll-down = "brightnessctl set 5%-";
        };

        network = {
          format-wifi = "直 {signalStrength}%";
          format-ethernet = "";
          format-disconnected = "睊";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          on-click = "nm-connection-editor";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip-format = "{timeTo}, {capacity}%";
        };

        tray = {
          spacing = 10;
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };

    style = ''
      * {
        font-family: 'JetBrains Mono Nerd Font', 'Font Awesome 6 Free';
        font-size: 13px;
        font-weight: 600;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: #${colors.bg};
        color: #${colors.fg};
      }

      #workspaces {
        background: #${colors.surface};
        margin: 5px 5px 5px 10px;
        padding: 0px 5px;
        border-radius: 16px;
        border: solid 0px #${colors.accent};
        font-weight: bold;
        font-style: normal;
      }

      #workspaces button {
        padding: 0px 5px;
        margin: 4px 3px;
        border-radius: 16px;
        border: solid 0px #${colors.accent};
        color: #${colors.fg3};
        background: transparent;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button.active {
        color: #${colors.bg};
        background: #${colors.accent};
        border-radius: 16px;
        min-width: 40px;
      }

      #workspaces button:hover {
        color: #${colors.accent};
        background: #${colors.bg2};
        border-radius: 16px;
      }

      #custom-launcher {
        color: #${colors.blue};
        background: #${colors.surface};
        border-radius: 16px;
        margin: 5px;
        margin-left: 10px;
        padding: 2px 17px;
        font-size: 15px;
      }

      #window {
        color: #${colors.fg2};
        background: #${colors.surface};
        border-radius: 16px;
        margin: 5px;
        padding: 2px 15px;
      }

      #clock {
        color: #${colors.fg};
        background: #${colors.surface};
        border-radius: 16px;
        margin: 5px;
        padding: 2px 15px;
      }

      #pulseaudio,
      #backlight,
      #network,
      #battery {
        color: #${colors.fg};
        background: #${colors.surface};
        border-radius: 16px;
        margin: 5px 2px;
        padding: 2px 12px;
      }

      #pulseaudio {
        color: #${colors.blue};
      }

      #backlight {
        color: #${colors.yellow};
      }

      #network {
        color: #${colors.green};
      }

      #battery {
        color: #${colors.aqua};
      }

      #battery.charging {
        color: #${colors.green};
      }

      #battery.warning:not(.charging) {
        color: #${colors.orange};
      }

      #battery.critical:not(.charging) {
        color: #${colors.red};
      }

      #tray {
        background: #${colors.surface};
        border-radius: 16px;
        margin: 5px;
        padding: 2px 5px;
      }

      #custom-power {
        color: #${colors.red};
        background: #${colors.surface};
        border-radius: 16px;
        margin: 5px;
        margin-right: 10px;
        padding: 2px 12px;
      }
    '';
  };

  # Hypridle configuration (idle management)
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };
      listener = [
        {
          timeout = 150; # 2.5min.
          on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }
        {
          timeout = 150; # 2.5min.
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
        }
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 330; # 5.5min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };

  # Hyprpaper configuration (wallpaper)
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/.config/wallpaper.jpg" # Add your wallpaper here
      ];

      wallpaper = [
        ",~/.config/wallpaper.jpg"
      ];
    };
  };


  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Modern Wofi configuration
  programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 32;
      gtk_dark = true;
      layer = "overlay";
    };

    style = ''
      window {
        margin: 0px;
        border: 2px solid #${colors.accent};
        background-color: rgba(${colors.bg}, 0.95);
        border-radius: 16px;
        backdrop-filter: blur(20px);
      }

      #input {
        all: unset;
        min-height: 36px;
        padding: 4px 20px;
        margin: 4px;
        border: none;
        color: #${colors.fg};
        font-weight: bold;
        background: linear-gradient(90deg, rgba(${colors.bg2}, 0.7), rgba(${colors.surface}, 0.7));
        border-radius: 12px;
        font-size: 14px;
      }

      #input:focus {
        box-shadow: 0 0 0 2px #${colors.accent};
      }

      #inner-box {
        margin: 4px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #${colors.fg};
        font-size: 13px;
      }

      #entry {
        padding: 8px 12px;
        margin: 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #entry:selected {
        background: linear-gradient(90deg, rgba(${colors.accent}, 0.3), rgba(${colors.accent2}, 0.3));
        color: #${colors.fg};
      }

      #entry:hover {
        background: rgba(${colors.bg2}, 0.5);
      }

      #entry:selected #text {
        font-weight: bold;
      }
    '';
  };

  # Modern Hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
        grace = 2;
        no_fade_in = false;
        no_fade_out = false;
        ignore_empty_input = true;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 4;
          blur_size = 8;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 60";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgb(${colors.accent})";
          inner_color = "rgba(${colors.surface}, 0.8)";
          font_color = "rgb(${colors.fg})";
          fade_on_empty = false;
          placeholder_text = "<span foreground=\"##${colors.fg3}\">Enter Password...</span>";
          hide_input = false;
          rounding = 20;
          check_color = "rgb(${colors.green})";
          fail_color = "rgb(${colors.red})";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_transition = 300;
          capslock_color = "rgb(${colors.yellow})";
          numlock_color = -1;
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # Time
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          color = "rgb(${colors.fg})";
          font_size = 90;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, 16";
          halign = "center";
          valign = "center";
        }
        # Date
        {
          monitor = "";
          text = "cmd[update:60000] echo \"<span>$(date '+%A, %d %B %Y')</span>\"";
          color = "rgb(${colors.fg2})";
          font_size = 20;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
        # User
        {
          monitor = "";
          text = "Welcome back, $USER";
          color = "rgb(${colors.fg3})";
          font_size = 14;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, -200";
          halign = "center";
          valign = "center";
        }
      ];

      shape = [
        {
          monitor = "";
          size = "360, 200";
          color = "rgba(${colors.surface}, 0.4)";
          rounding = 20;
          border_size = 2;
          border_color = "rgba(${colors.accent}, 0.5)";
          rotate = 0;
          xray = false;
          position = "0, -100";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Modern Dunst
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "none";
        width = "(0, 400)";
        height = 300;
        origin = "top-right";
        offset = "20x20";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = "yes";
        transparency = 10;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#${colors.accent}";
        separator_color = "frame";
        sort = "yes";
        font = "JetBrains Mono Nerd Font 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        enable_recursive_icon_lookup = true;
        icon_theme = "Adwaita";
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 128;
        sticky_history = "yes";
        history_length = 20;
        browser = "librewolf";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 12;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        background = "#${colors.surface}";
        foreground = "#${colors.fg2}";
        timeout = 10;
      };

      urgency_normal = {
        background = "#${colors.surface}";
        foreground = "#${colors.fg}";
        timeout = 10;
      };

      urgency_critical = {
        background = "#${colors.red}";
        foreground = "#${colors.bg}";
        frame_color = "#${colors.red}";
        timeout = 0;
      };
    };
  };
}
