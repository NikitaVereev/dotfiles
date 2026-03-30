#!/bin/bash
# =============================================================================
# Theme Switcher
# Unified theme switching for Hyprland, Kitty, Ghostty, Waybar, Rofi, Neovim
# Usage: theme-switch.sh <theme-name>
# =============================================================================

set -euo pipefail

readonly THEME="${1:-}"
readonly CONFIG_DIR="$HOME/.config"
readonly SCRIPT_NAME="Theme Switcher"

# ── Logging ───────────────────────────────────────────────────────────────────
log_info() {
  echo "[INFO] $1"
}

log_error() {
  notify-send "$SCRIPT_NAME" "$1" -u critical
  echo "[ERROR] $1" >&2
}

log_warn() {
  echo "[WARN] $1" >&2
}

# ── Validation ────────────────────────────────────────────────────────────────

if [[ -z "$THEME" ]]; then
  log_error "No theme specified!"
  echo "Usage: $0 <theme-name>"
  exit 1
fi

if [[ ! -f "$CONFIG_DIR/hypr/themes/$THEME.conf" ]]; then
  log_error "Theme '$THEME' not found in $CONFIG_DIR/hypr/themes/"
  exit 1
fi

# ── 1. Wallpaper ──────────────────────────────────────────────────────────────

if [[ -f "$HOME/Pictures/wallpapers/$THEME.png" ]]; then
  if ! awww img "$HOME/Pictures/wallpapers/$THEME.png" \
    --transition-type grow \
    --transition-duration 1.5 2>/dev/null; then
    log_warn "Failed to apply wallpaper"
  fi
else
  log_warn "Wallpaper '$THEME.png' not found in ~/Pictures/wallpapers/"
fi

# ── 2. Hyprland ───────────────────────────────────────────────────────────────

if ! ln -sf "$THEME.conf" "$CONFIG_DIR/hypr/themes/current.conf" 2>/dev/null; then
  log_error "Failed to create Hyprland theme symlink"
  exit 1
fi

if ! hyprctl reload 2>/dev/null; then
  log_warn "Failed to reload Hyprland"
fi

# ── 3. Kitty ──────────────────────────────────────────────────────────────────

if [[ -f "$CONFIG_DIR/kitty/themes/$THEME.conf" ]]; then
  if ! ln -sf "$THEME.conf" "$CONFIG_DIR/kitty/themes/current.conf" 2>/dev/null; then
    log_warn "Failed to create Kitty theme symlink"
  else
    killall -SIGUSR1 kitty 2>/dev/null || true
  fi
else
  log_warn "Kitty theme '$THEME' not found"
fi

# ── 4. Waybar ─────────────────────────────────────────────────────────────────

if [[ -f "$CONFIG_DIR/waybar/themes/$THEME.css" ]]; then
  if ! ln -sf "$THEME.css" "$CONFIG_DIR/waybar/themes/current.css" 2>/dev/null; then
    log_warn "Failed to create Waybar theme symlink"
  else
    if command -v waybar-msg >/dev/null 2>&1; then
      waybar-msg cmd reload 2>/dev/null || true
    else
      killall waybar 2>/dev/null || true
      sleep 0.2
      waybar &>/dev/null &
    fi
  fi
else
  log_warn "Waybar theme '$THEME' not found"
fi

# ── 5. Rofi ───────────────────────────────────────────────────────────────────

if [[ -f "$CONFIG_DIR/rofi/themes/$THEME.rasi" ]]; then
  if ! ln -sf "themes/$THEME.rasi" "$CONFIG_DIR/rofi/current.rasi" 2>/dev/null; then
    log_warn "Failed to create Rofi theme symlink"
  fi
else
  log_warn "Rofi theme '$THEME' not found"
fi

# ── 6. Neovim ─────────────────────────────────────────────────────────────────

if ! echo "$THEME" > "$CONFIG_DIR/nvim/themes/current" 2>/dev/null; then
  log_warn "Failed to write Neovim theme config"
else
  pkill -USR1 nvim 2>/dev/null || true
fi

# ── 7. Starship ───────────────────────────────────────────────────────────────

if [[ -f "$CONFIG_DIR/starship/themes/$THEME.toml" ]]; then
  if ! ln -sf "$THEME.toml" "$CONFIG_DIR/starship/themes/current.toml" 2>/dev/null; then
    log_warn "Failed to create Starship theme symlink"
  fi
else
  log_warn "Starship theme '$THEME' not found"
fi

# ── 8. SwayNC ─────────────────────────────────────────────────────────────────

if [[ -f "$CONFIG_DIR/swaync/themes/$THEME.css" ]]; then
  if ! ln -sf "$THEME.css" "$CONFIG_DIR/swaync/themes/current.css" 2>/dev/null; then
    log_warn "Failed to create SwayNC theme symlink"
  else
    swaync-client --reload-css 2>/dev/null || true
  fi
else
  log_warn "SwayNC theme '$THEME' not found"
fi

# ── Done ──────────────────────────────────────────────────────────────────────

notify-send "$SCRIPT_NAME" "Theme '$THEME' applied successfully" -i preferences-desktop-theme
