{ ... }:
let
  theme = import ../theme/gruvbox-dark.nix;
in
{
  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 37;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio#volume"
          "pulseaudio#mic"
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
            "1" = " ";
            "2" = " ";
            "3" = " ";
            "4" = " ";
            "5" = " ";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
          persistent-workspaces = {
            "*" = 5;
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
            activated = " ";
            deactivated = " ";
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
              months = "<span color='#${theme.scheme.base0D}'><b>{}</b></span>";
              days = "<span color='#${theme.scheme.base04}'><b>{}</b></span>";
              weeks = "<span color='#${theme.scheme.base0C}'><b>W{}</b></span>";
              weekdays = "<span color='#${theme.scheme.base09}'><b>{}</b></span>";
              today = "<span color='#${theme.scheme.base08}'><b><u>{}</u></b></span>";
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
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 🗲";
          format-plugged = "{capacity}%  ";
          format-alt = "{time} {icon}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };

        "pulseaudio#volume" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon}";
          format-muted = " ";
          format-icons = [
            ""
            " "
            " "
          ];
          on-click = "pavucontrol";
        };

        "pulseaudio#mic" = {
          format = "{format_source}";
          format-source = "{volume}% ";
          format-source-muted = " ";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };
      };
    };

    style = ''
         * {
        font-family: 'JetBrains Mono Nerd Font';
        font-size: 13px;
        font-weight: 600;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: #${theme.scheme.base01};
        color: #${theme.scheme.base05};
      }

      #workspaces {
        background: #${theme.scheme.base02};
        margin: 5px 5px 5px 10px;
        padding: 0px 5px;
        border-radius: 16px;
        border: solid 0px #${theme.scheme.base0D};
        font-weight: bold;
        font-style: normal;
      }

      #workspaces button {
        padding: 0px 5px;
        margin: 4px 3px;
        border-radius: 16px;
        border: solid 0px #${theme.scheme.base0D};
        color: #${theme.scheme.base04};
        background: transparent;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button.active {
        color: #${theme.scheme.base00};
        background: #${theme.scheme.base0D};
        border-radius: 16px;
        min-width: 40px;
      }

      #workspaces button:hover {
        color: #${theme.scheme.base0D};
        background: #${theme.scheme.base02};
        border-radius: 16px;
      }

      #custom-launcher {
        color: #${theme.scheme.base0D};
        background: #${theme.scheme.base02};
        border-radius: 16px;
        margin: 5px;
        margin-left: 10px;
        padding: 2px 17px;
        font-size: 15px;
      }

      #window {
        color: #${theme.scheme.base04};
        background: #${theme.scheme.base02};
        border-radius: 16px;
        margin: 5px;
        padding: 2px 15px;
      }

      #clock {
        color: #${theme.scheme.base05};
        background: #${theme.scheme.base02};
        border-radius: 16px;
        margin: 5px;
        padding: 2px 15px;
      }

      #language,
      #pulseaudio,
      #backlight,
      #network,
      #battery {
        color: #${theme.scheme.base05};
        background: #${theme.scheme.base02};
        border-radius: 16px;
        margin: 5px 2px;
        padding: 2px 12px;
      }

      #pulseaudio {
        color: #${theme.scheme.base0D};
      }

      #backlight {
        color: #${theme.scheme.base0A};
      }

      #network {
        color: #${theme.scheme.base0B};
      }

      #battery {
        color: #${theme.scheme.base0C};
      }

      #battery.charging {
        color: #${theme.scheme.base0B};
      }

      #battery.warning:not(.charging) {
        color: #${theme.scheme.base09};
      }

      #battery.critical:not(.charging) {
        color: #${theme.scheme.base08};
      }

      #tray {
        background: #${theme.scheme.base02};
        border-radius: 16px;
        margin: 5px;
        padding: 2px 5px;
      }

      #custom-power {
        color: #${theme.scheme.base08};
        background: #${theme.scheme.base02};
        border-radius: 16px;
        margin: 5px;
        margin-right: 10px;
        padding: 2px 12px;
      }
    '';
  };
}
