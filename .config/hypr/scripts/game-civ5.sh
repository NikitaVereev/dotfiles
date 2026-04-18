#!/usr/bin/env bash

cp ~/.config/hypr/modules/monitors.conf ~/.config/hypr/modules/monitors.conf.bak

sed -i 's/monitor = eDP-1,.*/monitor = eDP-1,disabled/' ~/.config/hypr/modules/monitors.conf

hyprctl reload
