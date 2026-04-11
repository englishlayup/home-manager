# main zsh settings. env in ~/.zprofile
# read second

# Default programs
export EDITOR="nvim"

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# history files
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

# add scripts to path
export PATH="$HOME/.local/scripts:$PATH"

export DATE=$(date "+%A, %B %e  %_I:%M%P")

export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30% --preview='([ -d {} ] && ls -la {}) bat -p --color=always {}'"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview" # separate opts for history widget

# source global shell alias & variables files
[ -f "$XDG_CONFIG_HOME/shell/alias" ] && source "$XDG_CONFIG_HOME/shell/alias"
[ -f "$XDG_CONFIG_HOME/shell/vars" ] && source "$XDG_CONFIG_HOME/shell/vars"

# load modules
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz edit-command-line
zle -N edit-command-line

# cmp opts
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
# zstyle ':completion:*' file-list true # more detailed list
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

# main opts
setopt append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
setopt auto_menu menu_complete # autocmp first menu match
setopt autocd # type a dir to cd
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
stty stop undef # disable accidental ctrl s

# history opts
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh_history" # move histfile to cache
HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved

# fzf setup
source <(fzf --zsh) # allow for fzf history widget

# binds
fzf-bindkey-widget() { bindkey | fzf --preview="man zshzle | col -b | grep -A5 \$(echo {} | awk '{print \$NF}')"; zle reset-prompt; }
zle -N fzf-bindkey-widget
bindkey "\e/" fzf-bindkey-widget # search zsh keybinds with alt+/
bindkey "\ee" edit-command-line  # open command line in $EDITOR with alt+e

# Terminal Integration
send_osc_preexec() { print -Pn "\e]0;$1\a"; }
send_osc_precmd() {
  local exit_code=$?

  # OSC 133 - shell integration
  print -Pn "\e]133;D;${exit_code}\a"
  print -Pn "\e]133;A\a"

  # OSC 7 - report cwd
  print -Pn "\e]7;file://${HOST}${PWD}\a"

  # OSC 0 - window title
  print -Pn "\e]0;zsh\a"
}

add-zsh-hook preexec send_osc_preexec
add-zsh-hook precmd send_osc_precmd

setopt PROMPT_SUBST # enable parameter expansion, command substitution and arithmetic expansion in prompts

# Git info setup with staged/unstaged indicators
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{yellow}+%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{blue}*%f'
zstyle ':vcs_info:git:*' formats ' (%%B%F{magenta}%b%f%%b%c%u)'
zstyle ':vcs_info:git:*' actionformats ' (%%B%F{magenta}%b%f%%b|%F{red}%a%f%c%u)'

add-zsh-hook precmd vcs_info

# Vi mode indicator (EDITOR=nvim causes zsh to use vi keymap)
VI_MODE_INDICATOR=""
zle-keymap-select() { # called when vi mode changes
  case $KEYMAP in
    vicmd)      VI_MODE_INDICATOR="%F{red}[N]%f ";    print -n "\e[2 q" ;; # normal mode, block cursor
    visual)     VI_MODE_INDICATOR="%F{yellow}[V]%f ";  print -n "\e[2 q" ;; # visual mode, block cursor
    viopp)      VI_MODE_INDICATOR="%F{cyan}[O]%f ";    print -n "\e[2 q" ;; # operator pending (after d/c/y), block cursor
    viins|main) VI_MODE_INDICATOR="%F{green}[I]%f ";   print -n "\e[6 q" ;; # insert mode, beam cursor
  esac
  zle reset-prompt # redraw prompt to update indicator
}
zle-line-init() { VI_MODE_INDICATOR="%F{green}[I]%f "; print -n "\e[6 q"; } # reset to insert mode on new prompt
zle -N zle-keymap-select # register as zle widget
zle -N zle-line-init     # register as zle widget

# Prompt helper functions
prompt_ssh() {
  [[ -n "$SSH_CLIENT" ]] && print -n "%F{cyan}%m%f "
}

prompt_nix() {
  [[ -n "$IN_NIX_SHELL" ]] && print -n "%F{cyan}󱄅 %f"
}

prompt_jobs() {
  local job_count=%j
  (( ${(%)job_count} > 0 )) && print -n "%F{#FF9500}⚙ ${(%)job_count} %f"
}

PROMPT='%(?..[%F{red}%?%f] )'                      # Exit status of last command if non-zero
PROMPT+='$(prompt_ssh)'                            # Hostname, only if in SSH session
PROMPT+='$(prompt_nix)'                            # Nix-shell indicator
PROMPT+='%F{#8ec07c}%~%f'                          # Current directory
PROMPT+='${vcs_info_msg_0_} '                      # Git info
PROMPT+='$(prompt_jobs)'                           # Background jobs count
PROMPT+=$'\n'                                      # Newline
PROMPT+='${VI_MODE_INDICATOR}'                     # vi mode: [N] in normal, hidden in insert
PROMPT+='%(!.#.$) '                                # $ or # suffix
echo -e "\n\x1b[38;5;137m\x1b[48;5;0m it's $(print -P '%D{%_I:%M%P}\n') \x1b[38;5;180m\x1b[48;5;0m $(uptime) \x1b[38;5;223m\x1b[48;5;0m $(uname -r) \033[0m" # current

# syntax highlighting
# requires zsh-syntax-highlighting package
source $XDG_DATA_HOME/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
