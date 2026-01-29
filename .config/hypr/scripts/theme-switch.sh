#!/bin/bash
# =================================================================================================
# Hyprland Theme Switcher
# Unified theme switching for Hyprland, Kitty, Waybar, Rofi, Neovim, Alacritty
# ================================================================================================

set -euo pipefail

readonly THEME="$1"
readonly CONFIG_DIR="$HOME/.config"

# Validate Hyprland theme file
if [[ -z "$THEME" ]]; then
  notify-send "Error" "No theme specified!" -u critical
  exit 1
fi

# Validate Hyprland theme file
if [[ ! -f "$CONFIG_DIR/hypr/themes/$THEME.conf" ]]; then
  notify-send "Error" "Hyprland theme '$THEME' not found!" -u critical
  exit 1
fi

# 1. WALLPAPER (with smooth transition)
if [[ -f "$HOME/Pictures/wallpapers/$THEME.png" ]]; then
  swww img "$HOME/Pictures/wallpapers/$THEME.png" \
    --transition-type grow \
    --transition-duration 1.5 || true
else
  notify-send "Warning" "Wallpaper '$THEME.png' not found" -u low
fi

# 2. HYPRLAND (window decorations)
ln -sf "$CONFIG_DIR/hypr/themes/$THEME.conf" "$CONFIG_DIR/hypr/themes/current.conf"
hyprctl reload

if [[ ! -f "$HOME/.config/kitty/themes/$THEME.conf" ]]; then
  notify-send "Warning" "Kitty theme $THEME not found!" -u low
fi

# 3. KITTY (terminal colors - supports reload)
if [[ -f "$CONFIG_DIR/kitty/themes/$THEME.conf" ]]; then
  ln -sf "$CONFIG_DIR/kitty/themes/$THEME.conf" "$CONFIG_DIR/kitty/themes/current.conf"
  killall -SIGUSR1 kitty 2>/dev/null || true
else
  notify-send "Warning" "Kitty theme '$THEME.conf' not found" -u low
fi

# 4. WAYBAR (status bar - supports hot reload)
if [[ -f "$CONFIG_DIR/waybar/themes/$THEME.css" ]]; then
  ln -sf "$CONFIG_DIR/waybar/themes/$THEME.css" "$CONFIG_DIR/waybar/themes/current.css"
  if command -v waybar-msg >/dev/null 2>&1; then
    waybar-msg cmd reload 2>/dev/null || true
  else
    killall waybar 2>/dev/null || true
    sleep 0.2
    waybar &>/dev/null &
  fi
else
  notify-send "Warning" "Waybar theme '$THEME.css' not found" -u low
fi

# 5. ROFI (launcher - requires restart)
if [[ -f "$CONFIG_DIR/rofi/themes/$THEME.rasi" ]]; then
  ln -sf "$CONFIG_DIR/rofi/themes/$THEME.rasi" "$CONFIG_DIR/rofi/current.rasi"
fi

# 6. NEOVIM (live reload via SIGUSR1)
echo "$THEME" >"$CONFIG_DIR/nvim/themes/current"
pkill -USR1 nvim 2>/dev/null || true

# 7. ALACRITTY (terminal - requires restart)
if command -v alacritty >/dev/null 2>&1 && [[ -f "$CONFIG_DIR/alacritty/themes/$THEME.toml" ]]; then
  ln -sf "$CONFIG_DIR/alacritty/themes/$THEME.toml" "$CONFIG_DIR/alacritty/themes/current.toml"
fi

# Success notification
notify-send "Theme" "'$THEME' applied successfully!" -i preferences-desktop-theme
