{
  pkgs,
  lib,
  # List of category names to include, e.g. [ "cli" "dev" "desktop" ]
  # Use [ "all" ] to include everything
  categories ? [ "all" ],
}:
let
  # Define package categories
  packageSets = with pkgs; {
    # Core CLI utilities - include on all systems
    cli = [
      tmux
      yazi
      hyperfine
      delta
      eza
      dust
      dua
      git
      btop
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
      imagemagick
      ffmpeg
    ];

    # Development tools - LSPs, formatters, compilers
    dev = [
      # Language servers
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
      starpls
      nil
      htmx-lsp
      vscode-langservers-extracted
      templ
      tailwindcss-language-server
      tree-sitter
      cmake-language-server
      # Compilers/runtimes
      clang
      uv
      fnm
      go
      # Build tools
      cmake
      ninja
      gnumake
    ];

    # Desktop environment - Hyprland, themes, screenshots
    desktop = [
      wl-clipboard
      # Theme
      nwg-look
      gruvbox-gtk-theme
      gruvbox-dark-icons-gtk
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      bibata-cursors
      # Screenshot
      slurp
      grim
      hyprshot
      hyprpicker
    ];

    # Personal apps - exclude on work machines
    personal = [
      anki-bin
      musescore
      mpv-unwrapped
    ];

    # Productivity apps
    productivity = [
      obsidian
      libreoffice-qt6-fresh
      zathura
      xournalpp
      gimp3
    ];

    # Add more categories as needed:
    # server = [ ];
    # work = [ ];
  };

  # Resolve "all" to all category names
  resolvedCategories =
    if builtins.elem "all" categories then builtins.attrNames packageSets else categories;

  # Collect packages from selected categories
  selectedPackages = lib.lists.flatten (map (cat: packageSets.${cat} or [ ]) resolvedCategories);
in
{
  homePackages = selectedPackages;
}
