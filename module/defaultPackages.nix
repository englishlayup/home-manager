{
  pkgs,
  lib,
  exclude_packages ? [ ],
}:
let
  allPackages = with pkgs; [
    # CLI Utils
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
    wl-clipboard
    imagemagick
    ffmpeg
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
    starpls
    nil
    htmx-lsp
    vscode-langservers-extracted
    templ
    tailwindcss-language-server
    tree-sitter
    ## some nvim plugins need a C compiler
    clang
    ## Package manager
    uv
    fnm
    go
    ## Build tool
    cmake
    ninja
    gnumake
    # GUI Application
    obsidian
    anki-bin
    libreoffice-qt6-fresh
    ## Musescore and dependencies
    musescore
    mpv-unwrapped
    ## Theme
    nwg-look # GTK theme configurator
    gruvbox-gtk-theme # Gruvbox GTK theme package
    gruvbox-dark-icons-gtk # Gruvbox icon theme (optional)
    libsForQt5.qt5ct # Qt5 configuration tool
    qt6Packages.qt6ct # Qt6 configuration tool
    bibata-cursors
    ## Screenshot
    slurp
    grim
    hyprshot
    gimp3
    hyprpicker
    ## PDF viewer
    zathura
    xournalpp
  ];
  filteredPackages = lib.lists.subtractLists exclude_packages allPackages;
in
{
  homePackages = filteredPackages;
}
