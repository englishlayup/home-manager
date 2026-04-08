# Package lists - just data, no logic
{ pkgs }:
with pkgs;
{
  cli = [
    tmux
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
    fd
    ripgrep
    fzf
    jq
    xxd
    translate-shell
    imagemagick
    ffmpeg
    lshw
    hwinfo
    inxi
    lm_sensors
    smartmontools
    usbutils
    lazygit
    zsh
    moreutils
  ];

  dev = [
    # Language servers
    lua-language-server
    clang-tools
    gopls
    ty
    ruff
    bash-language-server
    buildifier
    shellcheck
    nixfmt
    starpls
    nil
    vscode-langservers-extracted
    templ
    tailwindcss-language-server
    tailwindcss_4
    inotify-tools
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
    gnumake
    ninja
    # Database
    sqlite
    # Debugger
    lldb
    delve
  ];

  desktop = [
    rustdesk-flutter
  ];

  personal = [
    anki-bin
    musescore
    mpv
  ];

  productivity = [
    libreoffice-qt6-fresh
    sioyek
    xournalpp
    gimp3
  ];
}
