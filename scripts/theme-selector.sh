#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# Theme Selector - Rofi Menu for Theme Selection
# Usage: theme-selector.sh
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# Config
DOTFILES_DIR="$HOME/.dotfiles"
PALETTES_DIR="$DOTFILES_DIR/themes/palettes"
THEME_MANAGER="$DOTFILES_DIR/scripts/theme-manager.py"
SCRIPT_NAME="Theme Selector"

# Colors
C="\033[0;36m"
G="\033[0;32m"
R="\033[0;31m"
N="\033[0m"

log_info() { echo -e "${C}→${N} $1"; }
log_ok() { echo -e "${G}✓${N} $1"; }
log_err() { echo -e "${R}✗${N} $1"; }

# ── Get Available Themes ───────────────────────────────────────────────────────
get_themes() {
    find "$PALETTES_DIR" -maxdepth 1 -name "*.toml" -type f \
        | sed 's|.*/||' \
        | sed 's|\.toml$||' \
        | grep -v '^current$' \
        | sort
}

# ── Get Theme Description ──────────────────────────────────────────────────────
get_theme_description() {
    local theme="$1"
    local palette_file="$PALETTES_DIR/$theme.toml"
    
    if [[ -f "$palette_file" ]]; then
        # Read name from TOML
        grep '^name = ' "$palette_file" | sed 's/name = "//' | sed 's/"$//'
    else
        echo "$theme"
    fi
}

# ── Build Rofi Menu ────────────────────────────────────────────────────────────
build_menu() {
    local themes
    themes=$(get_themes)
    
    # Get current theme
    local current_theme=""
    if [[ -L "$PALETTES_DIR/current.toml" ]]; then
        current_theme=$(readlink "$PALETTES_DIR/current.toml" | sed 's/.toml//')
    fi
    
    while IFS= read -r theme; do
        local desc
        desc=$(get_theme_description "$theme")
        
        # Add marker for current theme
        if [[ "$theme" == "$current_theme" ]]; then
            echo -e "${theme}\t${desc} ✓ (current)"
        else
            echo -e "${theme}\t${desc}"
        fi
    done <<< "$themes"
}

# ── Show Rofi Menu ─────────────────────────────────────────────────────────────
show_menu() {
    local menu_items
    menu_items=$(build_menu)
    
    # Create temporary file for menu
    local tmp_file
    tmp_file=$(mktemp)
    
    echo "$menu_items" > "$tmp_file"
    
    # Show Rofi
    local choice
    choice=$(cat "$tmp_file" | rofi -dmenu \
        -i \
        -p "󰔯  Select Theme" \
        -theme-str 'window { width: 600px; }' \
        -theme-str 'listview { lines: 10; }' \
        -theme-str 'element-text { horizontal-align: 0.0; }' \
        2>/dev/null)
    
    rm -f "$tmp_file"
    
    if [[ -n "$choice" ]]; then
        # Extract theme name (first field before tab)
        local theme_name
        theme_name=$(echo "$choice" | cut -f1 | tr -d ' ')

        if [[ -n "$theme_name" ]]; then
            apply_theme "$theme_name"
        fi
    fi
}

# ── Apply Theme ────────────────────────────────────────────────────────────────
apply_theme() {
    local theme="$1"
    
    log_info "Applying theme: $theme"
    
    # Check if theme exists
    if [[ ! -f "$PALETTES_DIR/$theme.toml" ]]; then
        log_err "Theme '$theme' not found!"
        notify-send "$SCRIPT_NAME" "Theme '$theme' not found!" -u critical
        return 1
    fi
    
    # Apply theme using theme-manager.py
    if "$THEME_MANAGER" "$theme" 2>&1; then
        log_ok "Theme '$theme' applied successfully!"
        notify-send "$SCRIPT_NAME" "Theme '$theme' applied successfully!" -i preferences-desktop-theme
    else
        log_err "Failed to apply theme '$theme'"
        notify-send "$SCRIPT_NAME" "Failed to apply theme '$theme'" -u critical
        return 1
    fi
}

# ── Main ───────────────────────────────────────────────────────────────────────
main() {
    # Check if theme-manager.py exists
    if [[ ! -x "$THEME_MANAGER" ]]; then
        log_err "theme-manager.py not found or not executable!"
        notify-send "$SCRIPT_NAME" "theme-manager.py not found!" -u critical
        exit 1
    fi
    
    # Check if themes exist
    local theme_count
    theme_count=$(get_themes | wc -l)
    
    if [[ "$theme_count" -eq 0 ]]; then
        log_err "No themes found in $PALETTES_DIR"
        notify-send "$SCRIPT_NAME" "No themes found!" -u critical
        exit 1
    fi
    
    # Show menu
    show_menu
}

main "$@"
