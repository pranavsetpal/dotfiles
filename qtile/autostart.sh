#!/bin/sh
# sh ~/.config/polybar/launch.sh
pipewire &
pipewire-pulse &
wireplumber &

picom &

dunst &
