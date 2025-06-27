{ ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_hybrid_key_bindings
      set -g theme_color_scheme gruvbox-dark
      fnm env --use-on-cd --version-file-strategy=recursive --shell fish | source
    '';
    shellAbbrs = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      tree = "eza --tree --icons";
      cat = "bat";
      cd = "z";

      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";

      tf = "trans -brief fr:";
    };
    functions = {
      cdg = {
        description = "cd relative to git root";
        body = ''
          if test (count $argv) -eq 1
              cd (git rev-parse --show-toplevel 2>/dev/null)/$argv[1]
          else if test (count $argv) -eq 0
              cd (git rev-parse --show-toplevel 2>/dev/null)
          end
        '';
      };
      tmp = {
        description = "create temporary workspace";
        body = ''
          if string match "$argv[1]" = "view"
              cd /tmp/workspaces && cd (ls -t | fzf --preview 'ls -A {}') && return 0
          end
          set r /tmp/workspaces/(xxd -l3 -ps /dev/urandom)
          mkdir -p $r && pushd $r
          git init $r
        '';
      };
      fish_prompt = {
        description = "Write out the prompt";
        body = ''
          set -l last_pipestatus $pipestatus
          set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

          if not set -q __fish_git_prompt_show_informative_status
              set -g __fish_git_prompt_show_informative_status 1
          end
          if not set -q __fish_git_prompt_hide_untrackedfiles
              set -g __fish_git_prompt_hide_untrackedfiles 1
          end
          if not set -q __fish_git_prompt_color_branch
              set -g __fish_git_prompt_color_branch magenta --bold
          end
          if not set -q __fish_git_prompt_showupstream
              set -g __fish_git_prompt_showupstream informative
          end
          if not set -q __fish_git_prompt_color_dirtystate
              set -g __fish_git_prompt_color_dirtystate blue
          end
          if not set -q __fish_git_prompt_color_stagedstate
              set -g __fish_git_prompt_color_stagedstate yellow
          end
          if not set -q __fish_git_prompt_color_invalidstate
              set -g __fish_git_prompt_color_invalidstate red
          end
          if not set -q __fish_git_prompt_color_untrackedfiles
              set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
          end
          if not set -q __fish_git_prompt_color_cleanstate
              set -g __fish_git_prompt_color_cleanstate green --bold
          end

          set -l color_cwd
          set -l suffix
          if functions -q fish_is_root_user; and fish_is_root_user
              if set -q fish_color_cwd_root
                  set color_cwd $fish_color_cwd_root
              else
                  set color_cwd $fish_color_cwd
              end
              set suffix '#'
          else
              set color_cwd $fish_color_cwd
              set suffix '$'
          end

          # Hostname
          if test -n "$SSH_CLIENT"
              set_color brcyan
              echo -n (prompt_hostname)
              echo -n ' '
          end

          # PWD
          set_color $color_cwd
          echo -n (prompt_pwd)
          set_color normal

          printf '%s ' (fish_vcs_prompt)

          set -l status_color (set_color $fish_color_status)
          set -l statusb_color (set_color --bold $fish_color_status)
          set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
          echo -n $prompt_status
          set_color normal

          echo -n "$suffix "
        '';
      };
    };
  };
  xdg.configFile."fish/completions/bazel.fish".source = ../fish/completions/bazel.fish;
}
