{ config, pkgs, ... }:

{
  imports = [
    ./module/dunst.nix
    ./module/fish.nix
    ./module/hypridle.nix
    ./module/hyprland.nix
    ./module/hyprlock.nix
    ./module/hyprpaper.nix
    ./module/waybar.nix
    ./module/wofi.nix
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
}
