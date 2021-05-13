#!/bin/zsh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)


####### LEGACY SETTINGS ########
#panel | lemonbar -p -d -g "1366x25" -B "#FF002b36" -F "#FF002b36" -f "Inconsolata-g for Powerline:size=8" -f "FontAwesome-10" | sh
#hsetroot -solid "#586e75" &
#exec urxvt



if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrdb -merge ~/.Xresources &
xsetroot -cursor_name left_ptr &
xset b 40 350 40 &
xset m 0 3 &
xbindkeys &
autocutsel -fork &
autocutsel -selection PRIMARY -fork &
xmodmap ~/.Xmodmap &
compton -cb --inactive-dim 0.25 --no-dock-shadow --no-fading-openclose --config ~/.config/compton/compton.conf &
pulseaudio-ctl &
sxhkd -c ~/.config/bspwm/sxhkdrc &
sh ~/.fehbg &
polybar left &
polybar right &
exec bspwm
