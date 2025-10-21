set -o vi

#load autocomplete
autoload -U compinit
compinit

#set default editor
export EDITOR="nvim"
export K9S_SKIN="everforest"

#paths
export PATH=$HOME/bin:/opt/homebrew/bin:$HOME/bin/colours:$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH
export GPG_TTY=$(tty)
export DOTNET_ROOT="/opt/homebrew/opt/dotnet@8/libexec"

source <(fzf --zsh)

# function directory
dir=$HOME/bin/n-able
if [ -d $dir ]; then
  for f in $(ls -1 $dir); do source ${dir}/${f}; done
fi

#syntax highlighting
source $HOME/git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/git/zsh-vi-mode/zsh-vi-mode.plugin.zsh
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# kitty aliases
alias icat="kitty +kitten icat"

#aliases
alias jukebox="mpv http://fig.whatbox.ca:3003 > /dev/null 2>&1 &"
alias gotop="gotop -c nord --celsius"
alias vim="nvim"
alias suspend="systemctl suspend"
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"
alias ls="ls -Gh"
alias ll="ls -Ghla"
alias grep="rg"
alias find="fd"
alias c="clear"
alias mkdir="mkdir -p"
alias rm="rm -r"
alias cp="cp -r"
alias pong="ping -c 3 google.com"

source ~/.config/prompt.zsh
