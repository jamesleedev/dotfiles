# === Setup ===
# Setup dirs
ZDOTDIR=${ZDOTDIR:-$HOME}

# Use vim mode
bindkey -v

# setup run-help
unalias run-help 2>/dev/null
autoload -Uz run-help

# sets editor based on ssh
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# keytimeout in 1/100th of a second
KEYTIMEOUT=1

# Setup Antidote if necessary
if [[ ! -d $HOME/.antidote ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote $HOME/.antidote
fi

# === Options ===
## 16.2.1 Changing Directories
setopt auto_cd
setopt auto_pushd
setopt pushd_minus

## 16.2.2 Completion
setopt always_to_end
setopt complete_in_word
unsetopt list_beep

## 16.2.3 Expansion and Globbing
setopt extendedglob

## 16.2.4 History
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000

setopt extended_history
setopt hist_expire_dups_first
setopt share_history

## 16.2.6 Input/Output
unsetopt flow_control



# === ZLE ===
# Turn off highlight on paste
zle_highlight=(paste:none)

# === Completion ===
source $ZDOTDIR/completions.zsh

# === Keybinds ===
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char

# === Custom Misc ===
# bindkey -s ^f "tmux-sessioniser\n"

# catppuccin mocha
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# added by nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# === Functions ===
# Get current branch name, will make this more robust later, don't use if copying configs
function get_current_git_branch() {
    echo $(git branch --show-current)
}

# Small alias for my standard zstd opts
function zstd5l () {
  if [[ -n $1 ]]; then
    echo "Input file: $1"
    zstd -5 --long -v --progress -T0 --auto-threads=logical $1 -o $1.zst
  else
    echo 'Input file is required.'
  fi
}

# === Aliases ===
# cd
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# ls
alias ls="ls --color=auto"
alias la="ls -lAh --color=auto"
alias lat="ls -lAhtr"  # reverse so most recent edited is the first line above new prompt

# git
alias g="git"
alias gst="git status"
alias ga="git add"
alias gaa="git add --all"
alias gcm="git commit -m"
alias gcmsg="git commit -m"
alias gp="git push"
alias gpsup='git push -u origin "$(get_current_git_branch)"'
alias gptag="git push --tags"
alias gpl="git pull"
alias gl="git log --oneline"
alias glog="git log --abbrev-commit --decorate"
alias glogg="git log --graph --abbrev-commit --pretty=oneline --decorate"
alias gt="git tag"
alias gtls="git describe --tags --abbrev=0"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gbd="git branch -d"
alias gbD="git branch -D"
alias gdiff="git diff HEAD"
alias gdiff1="git diff HEAD~1"

# cat
alias cat="bat"

# === Prompt ===
# Starship
eval "$(starship init zsh)"

# === Hooks ===
# Allows foot to spawn new window in current directory by setting OSC-7
function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    local DIRECTORY=${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
    printf '\e]7;file://%s%s\e\\' $HOST $DIRECTORY
}

function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd

#
# function preexec-osc0-last-command() {
#     emulate -L zsh
#     echo -en "\e]0;$1\a";
# }
# add-zsh-hook -Uz preexec preexec-osc0-last-command
#

# === Plugins ===

source $HOME/.antidote/antidote.zsh
antidote load

ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

# autosuggest plugin keybinds 
bindkey '^ ' autosuggest-accept

# autosuggest cycle through suggestions
# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

# taken from https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh
# Start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

bindkey -M emacs "^[[A" up-line-or-beginning-search
bindkey -M viins "^[[A" up-line-or-beginning-search
bindkey -M vicmd "^[[A" up-line-or-beginning-search
if [[ -n "${terminfo[kcuu1]}" ]]; then
  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M emacs "^[[B" down-line-or-beginning-search
bindkey -M viins "^[[B" down-line-or-beginning-search
bindkey -M vicmd "^[[B" down-line-or-beginning-search
if [[ -n "${terminfo[kcud1]}" ]]; then
  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
