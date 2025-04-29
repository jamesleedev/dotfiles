export GOPATH=$HOME/go

typeset -gU path fpath

path=(
    $HOME/.local/bin/
    /usr/local/go/bin
    $HOME/go/bin
    $path
)

export path

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}

