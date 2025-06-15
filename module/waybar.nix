{ ... }:
let
  theme = import ../theme/gruvbox-dark.nix
in {
  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 20;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "backlight"
          "hyprland/submap"
          "hyprland/language"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
          persistent-workspaces = {
            "*" = 4;
          };
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 40;
          separate-outputs = true;
        };

        "hyprland/language" = {
          format = "{}";
          max-length = 18;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        memory.format = "{}% ";

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

        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 🗲";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        pulseaudio = {
          format = "{volume}%{icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
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
        background: #${colors.base01};
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
}
