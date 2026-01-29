#!/bin/bash
# =================================================================================================
# Hyprland Theme Selector
# Rofi-powered theme picker for theme-switch.sh
# =================================================================================================

readonly THEMES_DIR="$HOME/.config/hypr/themes"
readonly THEME_SWITCHER="$HOME/.config/hypr/scripts/theme-switch.sh"

# Dynamically discover themes from directory (no hardcoded list)
readonly THEMES=$(ls "$THEMES_DIR"/*.conf | sed 's|.*/||' | sed 's|\.conf$||' | tr '\n' '\n' | sort)

# Validate themes exist
if [[ -z "$THEMES" ]]; then
  notify-send "Error" "No themes found in '$THEMES_DIR'" -u critical
  exit 1
fi

# Rofi theme picker
readonly CHOICE=$(echo "$THEMES" | rofi -dmenu \
  -i \
  -p "Select Theme" \
  -theme "$HOME/.config/rofi/current.rasi" \
  -lines 8 \
  -width 30 \
  -location 0)

# Execute theme switcher
if [[ -n "$CHOICE" ]]; then
  "$THEME_SWITCHER" "$CHOICE"
fi
