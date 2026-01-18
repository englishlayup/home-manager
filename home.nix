# Shared base configuration - CLI tools, editor, shell
{ pkgs, ... }:
let
  packages = import ./module/packages.nix { inherit pkgs; };
in
{
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  home.packages = packages.cli ++ packages.dev;

  home.sessionVariables = {
    EDITOR = "nvim";
    CC = "${pkgs.clang}/bin/clang";
    CXX = "${pkgs.clang}/bin/clang++";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/scripts"
    "$HOME/go/bin"
  ];

  home.file = {
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

  xdg = {
    enable = true;
    configFile = {
      "nvim" = { source = ./nvim; recursive = true; };
      "tmux" = { source = ./tmux; recursive = true; };
      "fish" = { source = ./fish; recursive = true; };
      "nixpkgs/config.nix".text = ''{ allowUnfree = true; }'';
    };
  };

  programs.home-manager.enable = true;
  programs.fish.enable = true;

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

  programs.bat.enable = true;

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
