#!/bin/bash
# =============================================================================
# Layout Switcher
# Switches keyboard layout and shows a brief notification
# =============================================================================

hyprctl switchxkblayout all next

LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[0].active_keymap')

case "$LAYOUT" in
  *Russian*) LABEL="  RU" ;;
  *)         LABEL="  EN" ;;
esac

notify-send "$LABEL" "" \
  --urgency=low \
  --expire-time=1200 \
  --app-name="layout-switch" \
  --hint=boolean:transient:true
