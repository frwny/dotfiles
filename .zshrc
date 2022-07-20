#load autocomplete
autoload -U compinit
compinit

#set default editor

#paths
export PATH=/Users/Yegor.Milyeav/bin:$PATH
export EDITOR="vim"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home/
export NEXUS_USER=IqiHMqCY
export NEXUS_TOKEN=7mQdYbxzFaOOdwW0PoN2XVPVjakETEGnWxUq68fZ_mhE

#syntax highlighting
source /Users/Yegor.Milyeav/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

#prompt and colours
autoload -U colors && colors 
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\ \ \1/p'
}
setopt PROMPT_SUBST
# PROMPT=%F{4}">> "%f
export PROMPT='%{$fg[yellow]%} %{${fg[blue]}%}%1~%{${fg[cyan]}%}%{${fg[magenta]}%}$(parse_git_branch) %{${fg[default]}%}'

#aliases
alias tmux="tmux -2"
alias suspend="systemctl suspend"
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"
alias ls="ls -h"
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
export PATH="$PATH:/Users/Yegor.Milyeav/.npm-global/lib/node_modules/grunt-cli/bin"
export PATH="/Users/Yegor.Milyeav/Library/Python/2.7/bin:$PATH"
export PATH="$PATH:/Users/Yegor.Milyeav/Library/Python/3.8/bin"
export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.8/bin"
export PATH="$PATH:/Users/Yegor.Milyeav/Library/Python/3.7/bin"
export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.7/bin"
export SSL_CERT_FILE=/private/tescoconfig/tescocert/cert.pem  
