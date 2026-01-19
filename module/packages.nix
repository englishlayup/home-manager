# Package lists - just data, no logic
{ pkgs }:
with pkgs;
{
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
    nixfmt
    starpls
    nil
    htmx-lsp
    vscode-langservers-extracted
    templ
    tailwindcss-language-server
    tree-sitter
    cmake-language-server
    cmake-format
    # Compilers/runtimes
    clang
    uv
    fnm
    go
    # Build tools
    cmake
    ninja
    gnumake
    # Database
    sqlite
  ];

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

  personal = [
    anki-bin
    musescore
    mpv-unwrapped
  ];

  productivity = [
    obsidian
    libreoffice-qt6-fresh
    zathura
    xournalpp
    gimp3
  ];
}
