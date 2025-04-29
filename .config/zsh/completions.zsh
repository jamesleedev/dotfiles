# === Completion ===
# Load complist module for vim keybinds when navigating completion menu
zmodload zsh/complist

# Enables menu to select completions
zstyle ':completion:*' menu select

# Sets completer precedence
zstyle ':completion:*' completer _extensions _expand _complete _ignored _approximate

# Use cache for completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "~/.cache/zsh/.zcompcache"

# Group completions
zstyle ':completion:*' group-name ''

# Actual styling
zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- %d --%f'
zstyle ':completion:*:descriptions' format '%F{magenta}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{yellow}?- %d (errors: %e) -?%f'


# The following lines were added by compinstall

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2
zstyle :compinstall filename '/home/james/.zshrc'

autoload -Uz compinit
# End of lines added by compinstall

# Change location of dump file to cache
compinit -d ${XDG_CACHE_HOME:-$HOME/.cache}/.zcompdump

