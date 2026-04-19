#!/usr/bin/env bash

[ -f ~/.config/hypr/modules/monitors.conf.bak ] && mv ~/.config/hypr/modules/monitors.conf.bak ~/.config/hypr/modules/monitors.conf
[ -f ~/.config/hypr/modules/binds.conf.bak ] && mv ~/.config/hypr/modules/binds.conf.bak ~/.config/hypr/modules/binds.conf

hyprctl reload

notify-send "Reset game scripts"

