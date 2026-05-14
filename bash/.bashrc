export EDITOR="nvim"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export PATH="$HOME/.local/scripts:$PATH"

# source global shell alias & variables files
[ -f "$XDG_CONFIG_HOME/shell/alias" ] && source "$XDG_CONFIG_HOME/shell/alias"
[ -f "$XDG_CONFIG_HOME/shell/vars" ] && source "$XDG_CONFIG_HOME/shell/vars"

# opts
shopt -s histappend checkwinsize autocd globstar dotglob extglob nocaseglob cdspell
stty stop undef

# history
HISTSIZE=1000000
HISTFILESIZE=1000000
HISTFILE="$XDG_CACHE_HOME/bash_history"
HISTCONTROL=ignoreboth
PROMPT_COMMAND="history -a; history -n"

# vi mode
set -o vi
bind '"\C-a": beginning-of-line'
bind '"\C-e": end-of-line'
bind '"\C-l": clear-screen'
bind -m vi-insert '"\C-a": beginning-of-line'
bind -m vi-insert '"\C-e": end-of-line'
bind -m vi-insert '"\C-l": clear-screen'

# completion
bind 'TAB:menu-complete'
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set mark-directories on'
bind 'set match-hidden-files on'

# vi mode indicator + cursor shape
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string \1\e[6 q\e[32m\2[I]\1\e[0m\2 '
bind 'set vi-cmd-mode-string \1\e[2 q\e[31m\2[N]\1\e[0m\2 '

# prompt
__build_prompt() {
  local ec=$?
  PS1=""
  (( ec != 0 )) && PS1+="[\[\e[31m\]${ec}\[\e[0m\]] "
  [[ -n "$SSH_CLIENT" ]] && PS1+="\[\e[36m\]\h\[\e[0m\] "
  [[ -n "$IN_NIX_SHELL" ]] && PS1+="\[\e[36m\]nix \[\e[0m\]"
  PS1+="\[\e[38;2;142;192;124m\]\w\[\e[0m\] \n\$ "
}
PROMPT_COMMAND="__build_prompt; $PROMPT_COMMAND"
