#!/bin/bash
# =============================================================================
# Theme Switcher
# Unified theme switching for Hyprland, Kitty, Ghostty, Waybar, Rofi, Neovim
# Usage: theme-switch.sh <theme-name>
# =============================================================================

set -euo pipefail

readonly THEME="${1:-}"
readonly CONFIG_DIR="$HOME/.config"

# ── Validation ────────────────────────────────────────────────────────────────

if [[ -z "$THEME" ]]; then
  notify-send "Theme Switcher" "No theme specified!" -u critical
  exit 1
fi

if [[ ! -f "$CONFIG_DIR/hypr/themes/$THEME.conf" ]]; then
  notify-send "Theme Switcher" "Theme '$THEME' not found!" -u critical
  exit 1
fi

# ── 1. Wallpaper ──────────────────────────────────────────────────────────────

if [[ -f "$HOME/Pictures/wallpapers/$THEME.png" ]]; then
  swww img "$HOME/Pictures/wallpapers/$THEME.png" \
    --transition-type grow \
    --transition-duration 1.5 || true
else
  notify-send "Theme Switcher" "Wallpaper '$THEME.png' not found" -u low
fi

# ── 2. Hyprland ───────────────────────────────────────────────────────────────

ln -sf "$CONFIG_DIR/hypr/themes/$THEME.conf" "$CONFIG_DIR/hypr/themes/current.conf"
hyprctl reload

# ── 3. Kitty ──────────────────────────────────────────────────────────────────

if [[ -f "$CONFIG_DIR/kitty/themes/$THEME.conf" ]]; then
  ln -sf "$CONFIG_DIR/kitty/themes/$THEME.conf" "$CONFIG_DIR/kitty/themes/current.conf"
  killall -SIGUSR1 kitty 2>/dev/null || true
else
  notify-send "Theme Switcher" "Kitty theme '$THEME' not found" -u low
fi

# ── 4. Waybar ─────────────────────────────────────────────────────────────────

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
  notify-send "Theme Switcher" "Waybar theme '$THEME' not found" -u low
fi

# ── 5. Rofi ───────────────────────────────────────────────────────────────────

if [[ -f "$CONFIG_DIR/rofi/themes/$THEME.rasi" ]]; then
  ln -sf "$CONFIG_DIR/rofi/themes/$THEME.rasi" "$CONFIG_DIR/rofi/current.rasi"
else
  notify-send "Theme Switcher" "Rofi theme '$THEME' not found" -u low
fi

# ── 6. Neovim ─────────────────────────────────────────────────────────────────

echo "$THEME" >"$CONFIG_DIR/nvim/themes/current"
pkill -USR1 nvim 2>/dev/null || true

# ── 7. Starship ───────────────────────────────────────────────────────────────

if [[ -f "$CONFIG_DIR/starship/themes/$THEME.toml" ]]; then
  ln -sf "$CONFIG_DIR/starship/themes/$THEME.toml" "$CONFIG_DIR/starship/themes/current.toml"
else
  notify-send "Theme Switcher" "Starship theme '$THEME' not found" -u low
fi

# ── 8. Ghostty ────────────────────────────────────────────────────────────────

if [[ -f "$CONFIG_DIR/ghostty/themes/$THEME" ]]; then
  sed -i "s/^theme = .*/theme = $THEME/" "$CONFIG_DIR/ghostty/config"
  pkill -USR2 ghostty 2>/dev/null || true
else
  notify-send "Theme Switcher" "Ghostty theme '$THEME' not found" -u low
fi

# ── Done ──────────────────────────────────────────────────────────────────────

notify-send "Theme Switcher" "'$THEME' applied" -i preferences-desktop-theme
