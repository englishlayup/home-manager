# Shared base configuration - CLI tools, editor, shell
{ pkgs, config, ... }:
let
  packages = import ./module/packages.nix { inherit pkgs; };
  zsh-syntax-highlighting = pkgs.fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = "master";
    sha256 = "sha256-VMne38IQwqB4jwGUI2f3eEiSkT2ww7+G5ch7w+65GT0=";
  };
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
      "nvim" = {
        source = ./nvim;
        recursive = true;
      };
      "tmux" = {
        source = ./tmux;
        recursive = true;
      };
      "fish" = {
        source = ./fish;
        recursive = true;
      };
      "nixpkgs/config.nix".text = "{ allowUnfree = true; }";
    };
    dataFile = {
      "zsh/plugins/zsh-syntax-highlighting" = {
        source = zsh-syntax-highlighting;
        recursive = true;
      };
    };
  };

  programs.home-manager.enable = true;
  programs.fish.enable = true;
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = builtins.readFile ./zsh/.zshrc;
  };

  programs.starship = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
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
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.bat.enable = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
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
