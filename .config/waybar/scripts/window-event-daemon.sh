#!/bin/bash

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
[[ -S "$socket" ]] || exit 1

socat -U - UNIX-CONNECT:"$socket" | while IFS= read -r line; do
  case "$line" in
    activewindowv2*|workspacev2*|focusedmonv2*|openwindow*|closewindow*)
      pkill -x -RTMIN+8 waybar
      ;;
  esac
done
