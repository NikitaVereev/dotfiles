#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# Wallpaper Selector - Rofi menu with thumbnail previews
# Usage: wallpaper-selector.sh
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# Config
WALLPAPERS_DIR="$HOME/.dotfiles/wallpapers"
ORIGINALS_DIR="$WALLPAPERS_DIR/original"
GENERATED_DIR="$WALLPAPERS_DIR/generated"
CACHE_DIR="$WALLPAPERS_DIR/cache"
CURRENT_WALLPAPER_FILE="$WALLPAPERS_DIR/current_wallpaper.txt"
CURRENT_THEME_FILE="$HOME/.dotfiles/themes/palettes/current.toml"
SCRIPT_NAME="Wallpaper Selector"

# Colors
C="\033[0;36m"
G="\033[0;32m"
R="\033[0;31m"
Y="\033[1;33m"
N="\033[0m"

log_info() { echo -e "${C}→${N} $1"; }
log_ok() { echo -e "${G}✓${N} $1"; }
log_err() { echo -e "${R}✗${N} $1"; }
log_warn() { echo -e "${Y}!${N} $1"; }

# ── Get Current Theme ────────────────────────────────────────────────────────────
get_current_theme() {
    if [[ -L "$CURRENT_THEME_FILE" ]]; then
        readlink "$CURRENT_THEME_FILE" | sed 's/.toml//'
    else
        echo "gruvbox"  # default
    fi
}

# ── Generate Thumbnail ──────────────────────────────────────────────────────────
generate_thumbnail() {
    local input="$1"
    local output="$2"
    local size="${3:-300}"
    
    if command -v magick &>/dev/null; then
        magick "$input" -thumbnail "${size}x${size}^" -gravity center -extent "${size}x${size}" "$output" 2>/dev/null
    elif command -v convert &>/dev/null; then
        convert "$input" -thumbnail "${size}x${size}^" -gravity center -extent "${size}x${size}" "$output" 2>/dev/null
    else
        log_err "ImageMagick not found. Install with: sudo pacman -S imagemagick"
        return 1
    fi
}

# ── Generate All Thumbnails ─────────────────────────────────────────────────────
generate_all_thumbnails() {
    local theme="$1"
    local source_dir="$GENERATED_DIR/$theme"
    
    if [[ ! -d "$source_dir" ]]; then
        return 0
    fi
    
    mkdir -p "$CACHE_DIR/$theme"
    
    # Find all images
    shopt -s nullglob
    for img in "$source_dir"/*.jpg "$source_dir"/*.jpeg "$source_dir"/*.png "$source_dir"/*.gif; do
        [[ -f "$img" ]] || continue
        local basename
        basename=$(basename "$img")
        local thumb="$CACHE_DIR/$theme/${basename%.*}.png"

        # Generate if not exists or source is newer
        if [[ ! -f "$thumb" ]] || [[ "$img" -nt "$thumb" ]]; then
            generate_thumbnail "$img" "$thumb" 200 || true
        fi
    done
    shopt -u nullglob
}

# ── Get Original Wallpaper Name ─────────────────────────────────────────────────
# Extracts original name from generated name
# Examples:
#   "gruvebox_1_gruvbox" -> "gruvebox_1"
#   "gruvebox_1_catppuccin" -> "gruvebox_1"
#   "bloodmoon_gruvbox" -> "bloodmoon"
get_original_name() {
    local generated_name="$1"
    
    # Remove last _<theme> suffix (e.g., _gruvbox, _catppuccin, etc.)
    # Pattern: remove everything after last underscore if it's a known theme
    echo "$generated_name" | sed 's/_gruvbox$//' | sed 's/_catppuccin$//' | sed 's/_everforest$//' | sed 's/_kanagawa$//' | sed 's/_oxocarbon$//'
}

# ── Apply Wallpaper ─────────────────────────────────────────────────────────────
apply_wallpaper() {
    local theme="$1"
    local name="$2"
    
    local img="$GENERATED_DIR/$theme/${name}"
    
    # Try different extensions
    for ext in jpg jpeg png gif; do
        if [[ -f "${img}.${ext}" ]]; then
            img="${img}.${ext}"
            break
        fi
    done
    
    if [[ ! -f "$img" ]]; then
        log_err "Wallpaper '$name' not found for theme '$theme'"
        return 1
    fi
    
    # Save current wallpaper
    echo "$name" > "$CURRENT_WALLPAPER_FILE"
    
    # Apply with awww (Hyprland wallpaper daemon)
    if command -v awww &>/dev/null; then
        awww img "$img" --transition-type grow --transition-duration 1.5 2>/dev/null && \
            log_ok "Applied: $name ($theme)" || \
            log_err "Failed to apply wallpaper"
    else
        log_err "awww not found. Install with: yay -S awww"
        return 1
    fi
}

# ── Build Rofi Menu ─────────────────────────────────────────────────────────────
build_menu() {
    local theme="$1"
    local source_dir="$GENERATED_DIR/$theme"
    local thumb_dir="$CACHE_DIR/$theme"

    if [[ ! -d "$source_dir" ]]; then
        log_err "No wallpapers for theme '$theme'"
        return 1
    fi

    # Generate thumbnails
    generate_all_thumbnails "$theme"

    # Build menu with icons
    shopt -s nullglob
    for img in "$source_dir"/*.jpg "$source_dir"/*.jpeg "$source_dir"/*.png "$source_dir"/*.gif; do
        [[ -f "$img" ]] || continue
        local basename
        basename=$(basename "$img")
        local name="${basename%.*}"
        local thumb="$thumb_dir/${basename%.*}.png"

        if [[ -f "$thumb" ]]; then
            echo -e "${name}\0icon\x1f${thumb}"
        else
            echo -e "${name}"
        fi
    done
    shopt -u nullglob
}

# ── Show Rofi Menu ──────────────────────────────────────────────────────────────
show_menu() {
    local theme
    theme=$(get_current_theme)

    log_info "Theme: $theme"

    # Check if source directory exists
    local source_dir="$GENERATED_DIR/$theme"
    local thumb_dir="$CACHE_DIR/$theme"

    if [[ ! -d "$source_dir" ]]; then
        log_err "No wallpapers for theme '$theme'"
        log_info "Run theme-manager.py $theme to generate wallpapers"
        return 1
    fi

    # Generate thumbnails
    generate_all_thumbnails "$theme"

    # Build and show menu directly with rofi
    shopt -s nullglob
    {
        for img in "$source_dir"/*.jpg "$source_dir"/*.jpeg "$source_dir"/*.png "$source_dir"/*.gif; do
            [[ -f "$img" ]] || continue
            local basename
            basename=$(basename "$img")
            local name="${basename%.*}"
            local thumb="$thumb_dir/${basename%.*}.png"

            if [[ -f "$thumb" ]]; then
                echo -e "${name}\0icon\x1f${thumb}"
            else
                echo -e "${name}"
            fi
        done
    } | rofi -dmenu \
        -i \
        -p "🖼️  Select Wallpaper" \
        -theme-str 'window { width: 800px; height: 600px; }' \
        -theme-str 'listview { columns: 4; lines: 5; }' \
        -theme-str 'element-icon { size: 180px; }' \
        -theme-str 'element-text { horizontal-align: 0.5; }' \
        2>/dev/null | while read -r choice; do
            if [[ -n "$choice" ]]; then
                apply_wallpaper "$theme" "$choice"
            fi
        done
    shopt -u nullglob
}

# ── Apply Current Wallpaper with New Theme ──────────────────────────────────────
apply_current_wallpaper() {
    local new_theme="$1"
    
    # Check if there's a saved wallpaper
    if [[ ! -f "$CURRENT_WALLPAPER_FILE" ]]; then
        log_info "Wallpapers: No saved wallpaper, applying first available..."
        # Apply first available
        local source_dir="$GENERATED_DIR/$new_theme"
        if [[ -d "$source_dir" ]]; then
            shopt -s nullglob
            for img in "$source_dir"/*.png; do
                [[ -f "$img" ]] || continue
                local basename
                basename=$(basename "$img")
                local name="${basename%.*}"
                apply_wallpaper "$new_theme" "$name"
                shopt -u nullglob
                return 0
            done
            shopt -u nullglob
        fi
        return 1
    fi
    
    # Read saved wallpaper name
    local wallpaper_name
    wallpaper_name=$(cat "$CURRENT_WALLPAPER_FILE")

    # Get original wallpaper name (remove theme suffix)
    local original_name
    original_name=$(get_original_name "$wallpaper_name")

    # Build new name for new theme
    local new_wallpaper_name="${original_name}_${new_theme}"
    
    # Check if wallpaper exists for new theme
    local new_img="$GENERATED_DIR/$new_theme/${new_wallpaper_name}"
    local found=false
    
    for ext in jpg jpeg png gif; do
        if [[ -f "${new_img}.${ext}" ]]; then
            new_img="${new_img}.${ext}"
            found=true
            break
        fi
    done
    
    if [[ "$found" == true ]]; then
        # Apply wallpaper
        echo "$new_wallpaper_name" > "$CURRENT_WALLPAPER_FILE"
        log_info "Wallpapers: Applying $new_wallpaper_name..."
        if command -v awww &>/dev/null; then
            awww img "$new_img" --transition-type grow --transition-duration 1.5 2>/dev/null && \
                log_ok "Applied: $new_wallpaper_name ($new_theme)" || \
                log_err "Failed to apply wallpaper"
        fi
    else
        log_warn "Wallpapers: $new_wallpaper_name not found for $new_theme"
        log_info "Run theme-manager.py $new_theme to generate wallpapers"
    fi
}

# ── Main ────────────────────────────────────────────────────────────────────────
main() {
    # Check for --apply-current flag (used by theme-manager.py)
    if [[ "${1:-}" == "--apply-current" ]]; then
        local theme
        theme=$(get_current_theme)
        apply_current_wallpaper "$theme"
        return $?
    fi
    
    # Check dependencies
    if ! command -v rofi &>/dev/null; then
        log_err "rofi not found"
        exit 1
    fi
    
    # Check if wallpapers directory exists
    if [[ ! -d "$GENERATED_DIR" ]]; then
        log_err "Wallpapers directory not found"
        log_info "Run theme-manager.py first to generate wallpapers"
        exit 1
    fi
    
    show_menu
}

main "$@"
