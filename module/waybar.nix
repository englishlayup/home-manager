{ ... }:
{
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
          "idle_inhibitor"
          "pulseaudio"
          "backlight"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "hyprland/submap"
          "hyprland/language"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "tray"
          "clock"
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
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 50;
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
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
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
      @define-color base00 #181818;
      @define-color base01 #2b2e37;
      @define-color base02 #3b3e47;
      @define-color base03 #585858;
      @define-color base04 #b8b8b8;
      @define-color base05 #d8d8d8;
      @define-color base06 #e8e8e8;
      @define-color base07 #f8f8f8;
      @define-color base08 #ab4642;
      @define-color base09 #dc9656;
      @define-color base0A #f7ca88;
      @define-color base0B #a1b56c;
      @define-color base0C #86c1b9;
      @define-color base0D #7cafc2;
      @define-color base0E #ba8baf;
      @define-color base0F #a16946;

      * {
        transition: none;
        box-shadow: none;
      }

      #waybar {
        font-family: 'Source Code Pro', sans-serif;
        font-size: 1.2em;
        font-weight: 400;
        color: @base04;
        background: @base01;
      }

      #workspaces {
        margin: 0 4px;
      }

      #workspaces button {
        margin: 4px 0;
        padding: 0 4px;
        color: @base05;
      }

      #workspaces button.visible {
      }

      #workspaces button.active {
        border-radius: 4px;
        background-color: @base02;
      }

      #workspaces button.urgent {
        color: rgba(238, 46, 36, 1);
      }

      #tray {
        margin: 4px 4px 4px 4px;
        border-radius: 4px;
        background-color: @base02;
      }

      #tray * {
        padding: 0 6px;
        border-left: 1px solid @base00;
      }

      #tray *:first-child {
        border-left: none;
      }

      #mode, #battery, #cpu, #memory, #network, #pulseaudio, #idle_inhibitor, #backlight, #custom-storage, #custom-updates, #custom-weather, #custom-mail, #clock, #temperature, #language{
        margin: 4px 2px;
        padding: 0 6px;
        background-color: @base02;
        border-radius: 4px;
        min-width: 20px;
      }

      #pulseaudio.muted {
        color: @base0F;
      }

      #pulseaudio.bluetooth {
        color: @base0C;
      }

      #clock {
        margin-left: 0px;
        margin-right: 4px;
        background-color: transparent;
      }

      #temperature.critical {
        color: @base0F;
      }

      #window {
        font-size: 0.9em;
        font-weight: 400;
        font-family: sans-serif;
      }

      #language {
        font-size: 0.9em;
        font-weight: 500;
        letter-spacing: -1px;
      }
    '';
  };
}
