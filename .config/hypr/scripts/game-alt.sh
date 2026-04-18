#!/usr/bin/env bash

cp ~/.config/hypr/modules/binds.conf ~/.config/hypr/modules/binds.conf.bak

sed -i 's/\$mainMod = Mod1/\$mainMod = Mod4/' ~/.config/hypr/modules/binds.conf

hyprctl reload
