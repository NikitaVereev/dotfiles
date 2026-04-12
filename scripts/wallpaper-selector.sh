#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# Wallpaper Selector — Rofi menu with thumbnail previews
# Usage: wallpaper-selector.sh [--apply-current]
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# ── Config ─────────────────────────────────────────────────────────────────────
# Auto-detect dotfiles directory from this script's location
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WALLPAPERS_DIR="$DOTFILES_DIR/wallpapers"
ORIGINALS_DIR="$WALLPAPERS_DIR/original"
GENERATED_DIR="$WALLPAPERS_DIR/generated"
CACHE_DIR="$WALLPAPERS_DIR/cache"
CURRENT_WALLPAPER_FILE="$WALLPAPERS_DIR/current_wallpaper.txt"
CURRENT_THEME_FILE="$DOTFILES_DIR/themes/palettes/current.toml"
SCRIPT_NAME="Wallpaper Selector"

# ── Helpers ────────────────────────────────────────────────────────────────────
log_info()  { printf '\033[0;36m→\033[0m %s\n' "$1"; }
log_ok()    { printf '\033[0;32m✓\033[0m %s\n' "$1"; }
log_err()   { printf '\033[0;31m✗\033[0m %s\n' "$1"; }
log_warn()  { printf '\033[1;33m!\033[0m %s\n' "$1"; }

# Known theme suffixes — used to strip theme name from wallpaper filename
KNOWN_THEMES=(gruvbox catppuccin everforest kanagawa oxocarbon bloodmoon)

IMAGE_EXTS=(.jpg .jpeg .png .gif)

# ── Current theme ──────────────────────────────────────────────────────────────
get_current_theme() {
    if [[ -L "$CURRENT_THEME_FILE" ]]; then
        readlink "$CURRENT_THEME_FILE" | sed 's/\.toml$//'
    else
        echo "gruvbox"
    fi
}

# ── Thumbnails ─────────────────────────────────────────────────────────────────
generate_thumbnail() {
    local input="$1" output="$2" size="${3:-200}"

    if command -v magick &>/dev/null; then
        magick "$input" -thumbnail "${size}x${size}^" -gravity center \
            -extent "${size}x${size}" "$output" 2>/dev/null
    elif command -v convert &>/dev/null; then
        convert "$input" -thumbnail "${size}x${size}^" -gravity center \
            -extent "${size}x${size}" "$output" 2>/dev/null
    else
        log_err "ImageMagick not found"
        return 1
    fi
}

generate_thumbnails() {
    local theme="$1"
    local src="$GENERATED_DIR/$theme"
    local dst="$CACHE_DIR/$theme"

    [[ -d "$src" ]] || return 0
    mkdir -p "$dst"

    for ext in "${IMAGE_EXTS[@]}"; do
        for img in "$src"/*"$ext"; do
            [[ -f "$img" ]] || continue
            local base="${img##*/}"
            local thumb="$dst/${base%.*}.png"

            if [[ ! -f "$thumb" ]] || [[ "$img" -nt "$thumb" ]]; then
                generate_thumbnail "$img" "$thumb" 200 || true
            fi
        done
    done
}

# ── Wallpaper name helpers ─────────────────────────────────────────────────────
# "gruvebox_1_gruvbox" → "gruvebox_1"
strip_theme_suffix() {
    local name="$1"
    for theme in "${KNOWN_THEMES[@]}"; do
        name="${name%_$theme}"
    done
    echo "$name"
}

# ── Find image by trying extensions ────────────────────────────────────────────
find_image() {
    local base="$1"
    for ext in jpg jpeg png gif; do
        [[ -f "${base}.${ext}" ]] && echo "${base}.${ext}" && return 0
    done
    return 1
}

# ── Apply wallpaper ────────────────────────────────────────────────────────────
apply_wallpaper() {
    local theme="$1" name="$2"

    # Validate wallpaper name: alphanumeric, underscores, hyphens, dots
    if [[ ! "$name" =~ ^[a-zA-Z0-9_.-]+$ ]]; then
        log_err "Invalid wallpaper name: '$name'"
        return 1
    fi

    local img
    img=$(find_image "$GENERATED_DIR/$theme/$name") || {
        log_err "Wallpaper '$name' not found for theme '$theme'"
        return 1
    }

    echo "$name" > "$CURRENT_WALLPAPER_FILE"

    if command -v awww &>/dev/null; then
        if awww img "$img" --transition-type grow --transition-duration 1.5 2>/dev/null; then
            log_ok "Applied: $name ($theme)"
        else
            log_err "Failed to apply wallpaper"
            return 1
        fi
    else
        log_err "awww not found. Install with: yay -S awww"
        return 1
    fi
}

# ── Apply current wallpaper for a (possibly new) theme ─────────────────────────
apply_current_wallpaper() {
    local theme="$1"

    if [[ ! -f "$CURRENT_WALLPAPER_FILE" ]]; then
        log_info "Wallpapers: No saved wallpaper, applying first available..."
        local img
        for img in "$GENERATED_DIR/$theme"/*.png; do
            [[ -f "$img" ]] || continue
            apply_wallpaper "$theme" "${img##*/}" && return 0
        done
        log_warn "No wallpapers found for theme '$theme'"
        return 1
    fi

    local wallpaper_name original_name new_name
    wallpaper_name=$(cat "$CURRENT_WALLPAPER_FILE")
    original_name=$(strip_theme_suffix "$wallpaper_name")
    new_name="${original_name}_${theme}"

    if find_image "$GENERATED_DIR/$theme/$new_name" &>/dev/null; then
        apply_wallpaper "$theme" "$new_name"
    else
        log_warn "Wallpapers: $new_name not found for $theme"
        log_info "Run theme-manager.py $theme to generate wallpapers"
    fi
}

# ── Build and show Rofi menu ───────────────────────────────────────────────────
show_menu() {
    local theme
    theme=$(get_current_theme)

    local src="$GENERATED_DIR/$theme"
    [[ -d "$src" ]] || {
        log_err "No wallpapers for theme '$theme'"
        log_info "Run theme-manager.py $theme to generate wallpapers"
        return 1
    }

    generate_thumbnails "$theme"

    # Build wallpaper list with thumbnails via temp file
    # Format: name\0icon\0x1f/path (rofi icon format)
    local tmpfile
    tmpfile=$(mktemp)
    local has_items=false

    for ext in "${IMAGE_EXTS[@]}"; do
        for img in "$src"/*"$ext"; do
            [[ -f "$img" ]] || continue
            local base="${img##*/}"
            local name="${base%.*}"
            local thumb="$CACHE_DIR/$theme/${name}.png"
            if [[ -f "$thumb" ]]; then
                printf '%s\0icon\x1f%s\n' "$name" "$thumb" >> "$tmpfile"
            else
                printf '%s\n' "$name" >> "$tmpfile"
            fi
            has_items=true
        done
    done

    if [[ "$has_items" != "true" ]]; then
        log_err "No wallpapers found"
        rm -f "$tmpfile"
        return 1
    fi

    local choice
    choice=$(
        rofi -dmenu \
            -i \
            -p "🖼️  Select Wallpaper" \
            -show-icons \
            -theme-str 'window { width: 600px; }' \
            -theme-str 'listview { lines: 8; }' \
            -theme-str 'element-icon { size: 120px; }' \
            -theme-str 'element-text { horizontal-align: 0.0; padding: 8px; }' \
            < "$tmpfile" \
            2>/dev/null
    ) || { rm -f "$tmpfile"; return 0; }

    rm -f "$tmpfile"
    [[ -n "$choice" ]] && apply_wallpaper "$theme" "$choice"
}

# ── Main ───────────────────────────────────────────────────────────────────────
main() {
    if [[ "${1:-}" == "--apply-current" ]]; then
        apply_current_wallpaper "$(get_current_theme)"
        return
    fi

    command -v rofi &>/dev/null || { log_err "rofi not found"; exit 1; }
    command -v awww &>/dev/null || { log_err "awww not found (yay -S awww)"; exit 1; }

    [[ -d "$GENERATED_DIR" ]] || {
        log_err "Wallpapers directory not found"
        log_info "Run theme-manager.py first to generate wallpapers"
        exit 1
    }

    show_menu
}

main "$@"
