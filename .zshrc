set -o vi

#load autocomplete
autoload -U compinit
compinit

#set default editor
export EDITOR="nvim"
export K9S_SKIN="everforest"

#paths
export PATH=$HOME/bin:$HOME/bin/colours:$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH
export GPG_TTY=$(tty)
export DOTNET_ROOT="/opt/homebrew/opt/dotnet@8/libexec"

source <(fzf --zsh)

if [ -d $HOME/bin/n-able/ ]; then
  for f in $HOME/bin/n-able/; do source $f; done
fi

#syntax highlighting
source $HOME/git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

#prompt and colours
# autoload -U colors && colors 
# function parse_git_branch() {
#     git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\ \ \1/p'
# }
# setopt PROMPT_SUBST
# PROMPT=%F{4}">> "%f
#export PROMPT='%{$fg[yellow]%}➤ %{${fg[cyan]}%}%1~%{${fg[cyan]}%}%{${fg[magenta]}%}$(parse_git_branch) %{${fg[default]}%}'

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


# fixing special keys. to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi


# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
plugins=(git)

source ~/.config/prompt.zsh
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
