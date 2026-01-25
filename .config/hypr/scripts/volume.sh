#!/bin/bash

case "$1" in
--inc)
  pamixer -i 5 --allow-boost --set-limit 150 # +5%, макс 150%
  ;;
--dec)
  pamixer -d 5 # -5%
  ;;
--toggle)
  pamixer -t # Мьют/размьют
  ;;
--mic-inc)
  pamixer --default-source -i 5 # Мик +5%
  ;;
--mic-dec)
  pamixer --default-source -d 5 # Мик -5%
  ;;
--toggle-mic)
  pamixer --default-source -t # Мик мьют
  ;;
*)
  pamixer --get-volume # По умолчанию
  ;;
esac
