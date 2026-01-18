# Fish shell initialization
fish_hybrid_key_bindings
set -g theme_color_scheme gruvbox-dark

# Tool integrations
fnm env --use-on-cd --version-file-strategy=recursive --shell fish | source
uv generate-shell-completion fish | source
uvx --generate-shell-completion fish | source
