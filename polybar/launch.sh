#!/bin/sh
killall -q polybar
if type "xrandr" > /dev/null; then
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		MONITOR=$m polybar --reload &
	done
else
	polybar --reload &
fi
