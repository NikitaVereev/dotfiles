#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# Theme Selector — Rofi menu for theme switching
# Usage: theme-selector.sh
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# ── Config ─────────────────────────────────────────────────────────────────────
# Auto-detect dotfiles directory from this script's location
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PALETTES_DIR="$DOTFILES_DIR/themes/palettes"
THEME_MANAGER="$DOTFILES_DIR/scripts/theme-manager.py"
SCRIPT_NAME="Theme Selector"

# ── Helpers ────────────────────────────────────────────────────────────────────
log_info() { printf '\033[0;36m→\033[0m %s\n' "$1"; }
log_ok()   { printf '\033[0;32m✓\033[0m %s\n' "$1"; }
log_err()  { printf '\033[0;31m✗\033[0m %s\n' "$1"; }

# ── Theme listing ──────────────────────────────────────────────────────────────
get_themes() {
    # Portable: no GNU find -printf
    for f in "$PALETTES_DIR"/*.toml; do
        [[ -f "$f" ]] || continue
        local base
        base="${f##*/}"
        base="${base%.toml}"
        [[ "$base" != "current" ]] && echo "$base"
    done | sort
}

get_theme_name() {
    # Read human-readable name from palette TOML
    local palette_file="$PALETTES_DIR/$1.toml"
    if [[ -f "$palette_file" ]]; then
        sed -n 's/^name = "\(.*\)"/\1/p' "$palette_file"
    fi
}

get_current_theme() {
    if [[ -L "$PALETTES_DIR/current.toml" ]]; then
        readlink "$PALETTES_DIR/current.toml" | sed 's/\.toml$//'
    fi
}

# ── Build and show Rofi menu ───────────────────────────────────────────────────
show_menu() {
    local current
    current=$(get_current_theme)

    # Build menu lines: "<theme>\t<description> [✓ (current)]"
    local menu
    menu=$(
        while IFS= read -r theme; do
            local desc
            desc=$(get_theme_name "$theme")
            if [[ "$theme" == "$current" ]]; then
                printf '%s\t%s ✓ (current)\n' "$theme" "$desc"
            else
                printf '%s\t%s\n' "$theme" "$desc"
            fi
        done < <(get_themes)
    )

    # Show menu and capture selection
    local choice
    choice=$(
        echo "$menu" | rofi -dmenu \
            -i \
            -p "󰔯  Select Theme" \
            -theme-str 'window { width: 600px; }' \
            -theme-str 'listview { lines: 10; }' \
            -theme-str 'element-text { horizontal-align: 0.0; }' \
            2>/dev/null
    ) || return 0

    # Extract theme name (first column) and validate
    local theme
    theme=$(echo "$choice" | cut -f1 | tr -d ' ')

    # Validate: only alphanumeric, hyphens, underscores
    if [[ ! "$theme" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        log_err "Invalid theme name: '$theme'"
        return 1
    fi

    if [[ ! -f "$PALETTES_DIR/$theme.toml" ]]; then
        log_err "Theme '$theme' not found"
        notify-send "$SCRIPT_NAME" "Theme '$theme' not found" -u critical
        return 1
    fi

    apply_theme "$theme"
}

# ── Apply theme ────────────────────────────────────────────────────────────────
apply_theme() {
    local theme="$1"
    log_info "Applying theme: $theme"

    if "$THEME_MANAGER" "$theme"; then
        log_ok "Theme '$theme' applied"
        notify-send "$SCRIPT_NAME" "Theme '$theme' applied" -i preferences-desktop-theme
    else
        log_err "Failed to apply theme '$theme'"
        notify-send "$SCRIPT_NAME" "Failed to apply '$theme'" -u critical
        return 1
    fi
}

# ── Main ───────────────────────────────────────────────────────────────────────
main() {
    if [[ ! -x "$THEME_MANAGER" ]]; then
        log_err "theme-manager.py not found or not executable"
        notify-send "$SCRIPT_NAME" "theme-manager.py not found" -u critical
        exit 1
    fi

    local count
    count=$(get_themes | wc -l)
    if [[ "$count" -eq 0 ]]; then
        log_err "No themes found in $PALETTES_DIR"
        notify-send "$SCRIPT_NAME" "No themes found" -u critical
        exit 1
    fi

    show_menu
}

main "$@"
