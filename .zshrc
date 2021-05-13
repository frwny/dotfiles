#load autocomplete
autoload -U compinit
compinit

#set default editor

#paths
export PATH=/home/frowny/bin:$PATH
export BSPWM_SOCKET=/tmp/bspwm_0_0-socket
export BROWSER="firefox-nightly"
export EDITOR="vim"

#powerline
#. /usr/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh

#syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#prompt and colours
autoload -U colors && colors 
#PROMPT=%F{4}">> "%f
PROMPT="%{${fg[red]}%}[%~]%{${fg[cyan]}%} > %{${fg[default]}%}"

#aliases
alias tmux="tmux -2"
alias suspend="systemctl suspend"
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"
alias ls="ls -h"
alias grep="grep --color=auto"
alias mount="mount |column -t"
alias c="clear"
alias bar=
alias xres="xrdb -merge ~/.Xresources"
alias image="feh -B white -."
alias mkdir="mkdir -p"
alias rm="rm -r"
alias cp="cp -r"
alias tether="sudo dhcpcd enp0s26u1u1"
alias pong="ping -c 3 google.com"
alias newconnect="nmcli dev wifi connect -a"
alias connect="nmcli --ask con up"
alias disconnect="nmcli con down"
alias wifilist="nmcli dev wifi"
alias music="mpdas -d && mpd"
alias mountcd="sudo mount -t iso9660 -o loop /dev/sr0 /mnt/cdrom"
alias winedir="cd ~/.wine/drive_c/Program\ Files\ \(x86\)/"



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
