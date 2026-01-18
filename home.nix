{
  config,
  pkgs,
  lib,
  # Package categories to install. Override per-host in flake.nix
  # Options: "cli", "dev", "desktop", "personal", "productivity", or "all"
  packageCategories ? [ "all" ],
  ...
}:
let
  myPackages = import ./module/defaultPackages.nix {
    inherit pkgs lib;
    categories = packageCategories;
  };
in
{

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
  xdg = {
    enable = true;
    configFile = {
      # Neovim configuration
      "nvim" = {
        source = ./nvim;
        recursive = true;
      };
      "tmux" = {
        source = ./tmux;
        recursive = true;
      };
      # Fish shell
      "fish" = {
        source = ./fish;
        recursive = true;
      };
      # Hyprland ecosystem
      "hypr" = {
        source = ./hypr;
        recursive = true;
      };
      # Waybar
      "waybar" = {
        source = ./waybar;
        recursive = true;
      };
      # Dunst
      "dunst" = {
        source = ./dunst;
        recursive = true;
      };
      # Wofi
      "wofi" = {
        source = ./wofi;
        recursive = true;
      };
      # Ghostty
      "ghostty" = {
        source = ./ghostty;
        recursive = true;
      };
      # For `nix-env`, `nix-build`, `nix-shell` or any other Nix command
      "nixpkgs/config.nix".text = ''
        {
          allowUnfree = true;
        }
      '';
      "gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=Gruvbox-Dark
        gtk-icon-theme-name=Gruvbox-Plus-Dark
      '';
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "x-scheme-handler/terminal" = [ "ghostty.desktop" ];
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.

  # Configure GTK settings through Home Manager
  gtk = {
    enable = true;

    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 16;
    };

    font = {
      name = "Inter";
      size = 11;
    };

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme=1
    '';

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-button-images = 1;
      gtk-menu-images = 1;
    };
  };

  # Additional dconf settings for consistent theming
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Gruvbox-Dark";
      icon-theme = "Gruvbox-Plus-Dark";
      color-scheme = "prefer-dark";
    };
  };

  # Qt configuration
  qt = {
    enable = true;
    platformTheme.name = "qtct"; # Use qt5ct/qt6ct for theming
    style.name = "adwaita-dark"; # Fallback Qt style
  };

  home = {
    packages = myPackages.homePackages;
    # Environment variables for Qt theming
    sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "adwaita-dark";
      EDITOR = "nvim";
      # hint Electron apps to use Wayland:
      NIXOS_OZONE_WL = "1";
      TERMINAL = "ghostty";
      CC = "${pkgs.clang}/bin/clang";
      CXX = "${pkgs.clang}/bin/clang++";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.local/scripts"
      "$HOME/go/bin"
    ];

    file = {
      # Randomize wallpaper
      ".local/scripts/set-random-wallpaper.sh" = {
        text = ''
          #!/usr/bin/env bash

          WALLPAPER_DIR="$HOME/Sync/Wallpapers_clean/"
          CURRENT_WALL=$(hyprctl hyprpaper listloaded)
          # Get the name of the focused monitor with hyprctl
          FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
          # Get a random wallpaper that is not the current one
          WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

          # Apply the selected wallpaper
          hyprctl hyprpaper reload "$FOCUSED_MONITOR","$WALLPAPER"'';
        executable = true;
      };
      # Toggle pip opacity
      ".local/scripts/toggle-pip-opacity.sh" = {
        text = ''
          #!/usr/bin/env bash
          # Find the PIP window address
          PIP_WINDOW=$(hyprctl clients -j | jq -r '.[] | select(.title=="Picture in picture") | .address')
          hyprctl dispatch setprop address:$PIP_WINDOW opaque toggle > /dev/null'';
        executable = true;
      };
      # Long scripts
      ".local/scripts" = {
        source = ./scripts;
        recursive = true;
      };
      ".local/bin/gcc" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          exec ${pkgs.clang}/bin/clang "$@"
        '';
      };

      ".local/bin/g++" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          exec ${pkgs.clang}/bin/clang++ "$@"
        '';
      };
    };
  };

  systemd = {
    user = {
      services.set-random-wallpaper = {
        Unit = {
          Description = "Set a random wallpaper";
        };
        Service = {
          ExecStart = "${config.home.homeDirectory}/.local/scripts/set-random-wallpaper.sh";
          Type = "oneshot";
        };
      };
      timers.set-random-wallpaper = {
        Unit = {
          Description = "Change wallpaper every 10 minutes";
        };
        Timer = {
          OnBootSec = "1min";
          OnUnitActiveSec = "10min";
          Persistent = true;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };

  services.syncthing.enable = true;
  services.dunst.enable = true;
  services.hyprpaper.enable = true;
  services.hypridle.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fish.enable = true;
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
  programs.hyprlock.enable = true;
  programs.wofi.enable = true;
  programs.ghostty.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Duc Tran";
        email = "duc.tran2027@gmail.com";
      };
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      rerere.enabled = true;
      rerere.autoUpdate = true;
      branch.sort = "-committerdate";
      column.ui = "auto";
      alias.fpush = "push --force-with-lease";
    };
    lfs.enable = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
  };
}
