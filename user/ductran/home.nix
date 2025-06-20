{ config, pkgs, ... }:
{
  imports = [
    ../../module/dunst.nix
    ../../module/fish.nix
    ../../module/hyprland.nix
    ../../module/hyprpaper.nix
    ../../module/waybar.nix
    ../../module/wofi.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ductran";
  home.homeDirectory = "/home/ductran";

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
    neovim
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

  # Environment variables for Qt theming
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide = {
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
