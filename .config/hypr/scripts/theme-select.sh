#!/bin/bash
# =================================================================================================
# Hyprland Theme Selector
# Gallery-style rofi picker with wallpaper previews
# =================================================================================================

readonly THEMES_DIR="$HOME/.config/hypr/themes"
readonly THEME_SWITCHER="$HOME/.config/hypr/scripts/theme-switch.sh"
readonly WALLPAPERS_DIR="$HOME/Pictures/wallpapers"
readonly THUMBS_DIR="$HOME/.cache/rofi-theme-thumbnails"

# ── Thumbnails ────────────────────────────────────────────────────────────────

mkdir -p "$THUMBS_DIR"

for conf in "$THEMES_DIR"/*.conf; do
  theme=$(basename "$conf" .conf)
  [[ "$theme" == "current" ]] && continue

  wallpaper="$WALLPAPERS_DIR/$theme.png"
  thumb="$THUMBS_DIR/$theme.png"

  # Regenerate only if wallpaper is newer than existing thumbnail
  if [[ -f "$wallpaper" && (! -f "$thumb" || "$wallpaper" -nt "$thumb") ]]; then
    convert "$wallpaper" \
      -resize 320x320^ \
      -gravity center \
      -extent 320x320 \
      "$thumb" 2>/dev/null || true
  fi
done

# ── Theme Discovery ───────────────────────────────────────────────────────────

# Use find instead of ls for better handling of non-alphanumeric filenames
THEMES=$(find "$THEMES_DIR" -maxdepth 1 -name "*.conf" -type f \
  | sed 's|.*/||' \
  | sed 's|\.conf$||' \
  | grep -v '^current$' \
  | sort)

if [[ -z "$THEMES" ]]; then
  notify-send "Error" "No themes found in '$THEMES_DIR'" -u critical
  exit 1
fi

# ── Build Rofi Input ──────────────────────────────────────────────────────────
# Format: "name\0icon\x1f/path/to/thumb.png"

build_input() {
  while IFS= read -r theme; do
    thumb="$THUMBS_DIR/$theme.png"
    if [[ -f "$thumb" ]]; then
      printf '%s\0icon\x1f%s\n' "$theme" "$thumb"
    else
      printf '%s\n' "$theme"
    fi
  done <<< "$THEMES"
}

# ── Show Picker ───────────────────────────────────────────────────────────────

# Declare and assign separately to avoid masking return values (SC2155)
build_input | rofi -dmenu \
  -i \
  -p "󰔯  Change Theme" \
  -theme "$HOME/.config/rofi/theme-picker.rasi" > /tmp/rofi-choice.txt

CHOICE=$(cat /tmp/rofi-choice.txt)
rm -f /tmp/rofi-choice.txt

if [[ -n "$CHOICE" ]]; then
  "$THEME_SWITCHER" "$CHOICE"
fi
