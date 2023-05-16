#load autocomplete
autoload -U compinit
compinit

#set default editor

#paths
export EDITOR="vim"

#syntax highlighting
#source /Users/Yegor.Milyaev/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[path]=none
#ZSH_HIGHLIGHT_STYLES[path_prefix]=none

#prompt and colours
autoload -U colors && colors 
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\ \ \1/p'
}
setopt PROMPT_SUBST
# PROMPT=%F{4}">> "%f
export PROMPT='%{$fg[yellow]%}➤ %{${fg[blue]}%}%1~%{${fg[cyan]}%}%{${fg[magenta]}%}$(parse_git_branch) %{${fg[default]}%}'

#aliases
#alias vim="/opt/nvim-macos/bin/nvim"
alias tmux="tmux -2"
alias suspend="systemctl suspend"
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"
alias ls="ls -Gh"
alias ll="ls -Ghla"
alias grep="grep --color=auto"
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
