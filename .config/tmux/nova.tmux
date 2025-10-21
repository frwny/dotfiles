# Nova theme
set -g window-style 'fg=default,bg=#1e2326'
set -g window-active-style 'fg=default,bg=#272e33'
set -g @nova-pane-active-border-style '#4F585E,bg=#1e2326'
set -g @nova-pane-border-style '#4F585E,bg=#1e2326'

set -g @nova-nerdfonts true
set -g @nova-nerdfonts-left 
set -g @nova-nerdfonts-right 
set -g @nova-padding 0 

set -g @nova-pane "#I  #W"

set -g @nova-status-style-bg "#2D353B"
set -g @nova-status-style-fg "#859289"
set -g @nova-status-style-active-bg "#A7C080"
set -g @nova-status-style-active-fg "#2D353B"
set -g @nova-status-style-double-bg "#2D353B"

set -g @nova-segment-kube "󰆧  #(/bin/bash ~/.config/tmux/plugins/kube-tmux/kube.tmux 250 red black | cut -d / -f2- | cut -d# -f1)"
set -g @nova-segment-kube-colors "#A7C080 #2D353B"

set -g @nova-segments-0-right "kube"

