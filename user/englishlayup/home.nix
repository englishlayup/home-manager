{ config, pkgs, ... }:
{
  imports = [
    ../../module/dunst.nix
    ../../module/fish.nix
    ../../module/hypridle.nix
    ../../module/hyprland.nix
    ../../module/hyprlock.nix
    ../../module/hyprpaper.nix
    ../../module/waybar.nix
    ../../module/wofi.nix
    ../../module/ghostty.nix
  ];
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
  # For `nix-env`, `nix-build`, `nix-shell` or any other Nix command
  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Terminal
    ghostty
    # CLI Utils
    yazi
    hyperfine
    delta
    eza
    dust
    dua
    git
    btop
    bat
    zoxide
    tldr
    wget
    curl
    unzip
    zip
    htop
    neofetch
    fd
    ripgrep
    fzf
    jq
    xxd
    translate-shell
    # Dev tools
    ## Language server, debuger, formatter
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
    libreoffice-qt6-fresh
    mpv-unwrapped
    musescore
    # Theme
    nwg-look # GTK theme configurator
    gruvbox-gtk-theme # Gruvbox GTK theme package
    gruvbox-dark-icons-gtk # Gruvbox icon theme (optional)
    libsForQt5.qt5ct # Qt5 configuration tool
    qt6ct # Qt6 configuration tool
    bibata-cursors
  ];

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

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
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

  # XDG settings for theme consistency
  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Gruvbox-Dark
    gtk-icon-theme-name=Gruvbox-Plus-Dark
  '';

  # Qt configuration
  qt = {
    enable = true;
    platformTheme.name = "qtct"; # Use qt5ct/qt6ct for theming
    style.name = "adwaita-dark"; # Fallback Qt style
  };

  home = {
    # Environment variables for Qt theming
    sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "adwaita-dark";
    };

    sessionVariables = {
      EDITOR = "nvim";
      # hint Electron apps to use Wayland:
      NIXOS_OZONE_WL = "1";
    };

    sessionPath = [
      "$HOME/.local/scripts"
      "$HOME/go/bin"
    ];

    # Randomize wallpaper
    file = {
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    userName = "Duc Tran";
    userEmail = "duc.tran2027@gmail.com";
    extraConfig = {
      push.autoSetupRemote = true;
    };
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
    config = {
      theme = "auto";
      "theme-dark" = "gruvbox-dark";
      "theme-light" = "gruvbox-light";
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
        source = ../../nvim;
        recursive = true;
      };
    };
  };
}
