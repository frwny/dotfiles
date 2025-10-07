# Nova theme
set -g @nova-nerdfonts true
set -g @nova-nerdfonts-left 
set -g @nova-nerdfonts-right 
set -g @nova-padding 0 

set -g @nova-pane "#I  #W"

set -g @nova-pane-active-border-style "#A7C080"
set -g @nova-pane-border-style "#3D484D"
set -g @nova-status-style-bg "#2D353B"
set -g @nova-status-style-fg "#859289"
set -g @nova-status-style-active-bg "#A7C080"
set -g @nova-status-style-active-fg "#2D353B"
set -g @nova-status-style-double-bg "#2D353B"

set -g @nova-segment-kube "󰆧  #(/bin/bash ~/.config/tmux/plugins/kube-tmux/kube.tmux 250 red black | cut -d / -f2- | cut -d# -f1)"
set -g @nova-segment-kube-colors "#A7C080 #2D353B"

set -g @nova-segments-0-right "kube"

