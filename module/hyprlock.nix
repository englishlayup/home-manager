{ ... }:
let
  theme = import ../theme/gruvbox-dark.nix;
in
{
  # Hyprlock configuration (lockscreen with fingerprint)
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
      };

      auth = {
        fingerprint = {
          enabled = true;
        };
      };

      animations = {
        enabled = true;
        bezier = "linear, 1, 1, 0, 0";
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      background = [
        {
          monitor = "";
          blur_passes = 2;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "20%, 5%";
          outline_thickness = 3;
          inner_color = "rgba(0, 0, 0, 0.0)"; # no fill
          outer_color = "rgba(${theme.scheme.base0D}ee) rgba(${theme.scheme.base0B}ee) 45deg"; # blue to green gradient
          check_color = "rgba(${theme.scheme.base0B}ee) rgba(${theme.scheme.base14}ee) 120deg"; # green gradient for success
          fail_color = "rgba(${theme.scheme.base08}ee) rgba(${theme.scheme.base12}ee) 40deg"; # red gradient for failure
          font_color = "rgb(${theme.scheme.base04})"; # secondary text color
          fade_on_empty = false;
          font_family = "JetBrains Mono Nerd Font";
          placeholder_text = "Input password...";
          fail_text = "$PAMFAIL";
          # uncomment to use a letter instead of a dot to indicate the typed password
          # dots_text_format = "*";
          # dots_size = 0.4;
          dots_spacing = 0.3;
          # uncomment to use an input indicator that does not show the password length (similar to swaylock's input indicator)
          # hide_input = true;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # TIME
        {
          monitor = "";
          text = "$TIME"; # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
          font_size = 90;
          font_family = "JetBrains Mono Nerd Font";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        # DATE
        {
          monitor = "";
          text = "cmd[update:60000] date +\"%A, %d %B %Y\""; # update every 60 seconds
          font_size = 25;
          font_family = "JetBrains Mono Nerd Font";
          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
        # LAYOUT
        {
          monitor = "";
          text = "$LAYOUT[en,ru]";
          font_size = 24;
          onclick = "hyprctl switchxkblayout all next";
          position = "250, -20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
