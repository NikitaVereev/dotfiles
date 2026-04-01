#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# Theme Check Script
# Проверяет корректность применения тем ко всем приложениям
# Usage: check-themes.sh [theme-name]
# ═══════════════════════════════════════════════════════════════════════════════

set -uo pipefail

# Colors
C="\033[0;36m"
G="\033[0;32m"
R="\033[0;31m"
Y="\033[1;33m"
N="\033[0m"

# Counters
PASS=0
FAIL=0
WARN=0

# Theme name (default: gruvbox)
THEME="${1:-gruvbox}"

# Config directory
CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/.dotfiles"

# Helper functions
pass() { echo -e "${G}✓${N} $1"; ((PASS++)); }
fail() { echo -e "${R}✗${N} $1"; ((FAIL++)); }
warn() { echo -e "${Y}!${N} $1"; ((WARN++)); }
section() { echo -e "\n${C}▶${N} $1"; }

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

check_symlink() {
    local app="$1"
    local file="$2"
    local expected="$3"
    
    if [[ ! -L "$file" ]]; then
        fail "$app: $file is not a symlink"
        return 1
    fi
    
    local target
    target=$(readlink "$file")
    if [[ "$target" == "$expected" ]]; then
        pass "$app: symlink → $target"
        return 0
    else
        fail "$app: symlink → $target (expected: $expected)"
        return 1
    fi
}

check_file_exists() {
    local app="$1"
    local file="$2"
    
    if [[ -f "$file" ]]; then
        pass "$app: $file exists"
        return 0
    else
        fail "$app: $file not found"
        return 1
    fi
}

check_no_unreplaced_vars() {
    local app="$1"
    local file="$2"
    
    if [[ ! -f "$file" ]]; then
        return 1
    fi
    
    if grep -qE "\{\{.*\}\}" "$file"; then
        local count
        count=$(grep -oE "\{\{.*\}\}" "$file" | wc -l)
        fail "$app: $file has $count unreplaced variables"
        return 1
    else
        pass "$app: $file has no unreplaced variables"
        return 0
    fi
}

check_gruvbox_colors() {
    local app="$1"
    local file="$2"
    local pattern="$3"
    
    if [[ ! -f "$file" ]]; then
        return 1
    fi
    
    if grep -qE "$pattern" "$file"; then
        pass "$app: $file has Gruvbox colors"
        return 0
    else
        fail "$app: $file missing Gruvbox colors"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN CHECKS
# ═══════════════════════════════════════════════════════════════════════════════

echo -e "${C}╔════════════════════════════════════════════╗${N}"
echo -e "${C}║     Theme Check - $THEME                   ║${N}"
echo -e "${C}╚════════════════════════════════════════════╝${N}"

# ── Hyprland ───────────────────────────────────────────────────────────────────
section "Hyprland"
check_symlink "Hyprland" "$CONFIG_DIR/hypr/themes/current.conf" "${THEME}.conf"
check_file_exists "Hyprland" "$DOTFILES_DIR/.config/hypr/themes/${THEME}.conf"
check_no_unreplaced_vars "Hyprland" "$CONFIG_DIR/hypr/themes/current.conf"

# ── Waybar ─────────────────────────────────────────────────────────────────────
section "Waybar"
check_symlink "Waybar" "$CONFIG_DIR/waybar/themes/current.css" "${THEME}.css"
check_file_exists "Waybar" "$DOTFILES_DIR/.config/waybar/themes/${THEME}.css"
check_no_unreplaced_vars "Waybar" "$CONFIG_DIR/waybar/themes/current.css"
check_gruvbox_colors "Waybar" "$CONFIG_DIR/waybar/themes/current.css" "bg0.*282828|fg.*ebdbb2"

# ── Kitty ──────────────────────────────────────────────────────────────────────
section "Kitty"
check_symlink "Kitty" "$CONFIG_DIR/kitty/themes/current.conf" "${THEME}.conf"
check_file_exists "Kitty" "$DOTFILES_DIR/.config/kitty/themes/${THEME}.conf"
check_no_unreplaced_vars "Kitty" "$CONFIG_DIR/kitty/themes/current.conf"
check_gruvbox_colors "Kitty" "$CONFIG_DIR/kitty/themes/current.conf" "background.*282828|foreground.*ebdbb2"

# ── Neovim ─────────────────────────────────────────────────────────────────────
section "Neovim"
check_file_exists "Neovim" "$CONFIG_DIR/nvim/themes/current_theme"
if [[ -f "$CONFIG_DIR/nvim/themes/current_theme" ]]; then
    content=$(cat "$CONFIG_DIR/nvim/themes/current_theme")
    if [[ "$content" == "$THEME" ]]; then
        pass "Neovim: current_theme = $THEME"
    else
        fail "Neovim: current_theme = $content (expected: $THEME)"
    fi
fi
check_file_exists "Neovim" "$CONFIG_DIR/nvim/lua/plugins/colorschemes.lua"
if grep -q "ellisonleao/gruvbox.nvim" "$CONFIG_DIR/nvim/lua/plugins/colorschemes.lua"; then
    pass "Neovim: gruvbox.nvim plugin configured"
else
    warn "Neovim: gruvbox.nvim plugin not found in colorschemes.lua"
fi

# ── Rofi ───────────────────────────────────────────────────────────────────────
section "Rofi"
check_symlink "Rofi" "$CONFIG_DIR/rofi/themes/current.rasi" "${THEME}.rasi"
check_file_exists "Rofi" "$DOTFILES_DIR/.config/rofi/themes/${THEME}.rasi"
check_no_unreplaced_vars "Rofi" "$CONFIG_DIR/rofi/themes/current.rasi"
check_gruvbox_colors "Rofi" "$CONFIG_DIR/rofi/themes/current.rasi" "background.*282828|foreground.*ebdbb2"

# ── Starship ───────────────────────────────────────────────────────────────────
section "Starship"
check_symlink "Starship" "$CONFIG_DIR/starship/themes/current.toml" "${THEME}.toml"
check_file_exists "Starship" "$DOTFILES_DIR/.config/starship/themes/${THEME}.toml"
check_no_unreplaced_vars "Starship" "$CONFIG_DIR/starship/themes/current.toml"

# ── SwayNC ─────────────────────────────────────────────────────────────────────
section "SwayNC"
check_symlink "SwayNC" "$CONFIG_DIR/swaync/themes/current.css" "${THEME}.css"
check_file_exists "SwayNC" "$DOTFILES_DIR/.config/swaync/themes/${THEME}.css"
check_no_unreplaced_vars "SwayNC" "$CONFIG_DIR/swaync/themes/current.css"

# ── Tmux ───────────────────────────────────────────────────────────────────────
section "Tmux"
check_symlink "Tmux" "$CONFIG_DIR/tmux/themes/current.conf" "${THEME}.conf"
check_file_exists "Tmux" "$DOTFILES_DIR/.config/tmux/themes/${THEME}.conf"
check_no_unreplaced_vars "Tmux" "$CONFIG_DIR/tmux/themes/current.conf"

# ── Yazi ───────────────────────────────────────────────────────────────────────
section "Yazi"
check_symlink "Yazi" "$CONFIG_DIR/yazi/themes/current.toml" "${THEME}.toml"
check_file_exists "Yazi" "$DOTFILES_DIR/.config/yazi/themes/${THEME}.toml"
check_no_unreplaced_vars "Yazi" "$CONFIG_DIR/yazi/themes/current.toml"

# ── GTK ────────────────────────────────────────────────────────────────────────
section "GTK"
if command -v gsettings &>/dev/null; then
    gtk_theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null || echo "not set")
    if [[ "$gtk_theme" == *"${THEME}"* ]] || [[ "$gtk_theme" == *"Gruvbox"* ]]; then
        pass "GTK: theme = $gtk_theme"
    else
        warn "GTK: theme = $gtk_theme (expected: *${THEME}* or *Gruvbox*)"
    fi
else
    warn "GTK: gsettings not available"
fi

check_file_exists "GTK" "$HOME/.config/gtk-3.0/settings.ini"
if [[ -f "$HOME/.config/gtk-3.0/settings.ini" ]]; then
    if grep -q "gtk-theme-name=${THEME}" "$HOME/.config/gtk-3.0/settings.ini" || \
       grep -q "gtk-theme-name=Gruvbox" "$HOME/.config/gtk-3.0/settings.ini"; then
        pass "GTK 3.0: config correct"
    else
        warn "GTK 3.0: theme not set to $THEME or Gruvbox"
    fi
fi

# ── Theme Palette ──────────────────────────────────────────────────────────────
section "Theme Palette"
check_file_exists "Palette" "$DOTFILES_DIR/themes/palettes/${THEME}.toml"
if [[ -f "$DOTFILES_DIR/themes/palettes/${THEME}.toml" ]]; then
    if grep -q "gruvbox\|Gruvbox" "$DOTFILES_DIR/themes/palettes/${THEME}.toml"; then
        pass "Palette: ${THEME}.toml is Gruvbox"
    else
        warn "Palette: ${THEME}.toml may not be Gruvbox"
    fi
fi

check_symlink "Palette" "$DOTFILES_DIR/themes/palettes/current.toml" "${THEME}.toml"

# ── Theme Scripts ──────────────────────────────────────────────────────────────
section "Theme Scripts"
check_file_exists "Script" "$DOTFILES_DIR/scripts/theme-manager.py"
if [[ -x "$DOTFILES_DIR/scripts/theme-manager.py" ]]; then
    pass "theme-manager.py is executable"
else
    warn "theme-manager.py is not executable"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo -e "${C}════════════════════════════════════════${N}"
echo -e "  ${G}Passed${N}:   $PASS"
echo -e "  ${Y}Warnings${N}:  $WARN"
echo -e "  ${R}Failed${N}:    $FAIL"
echo -e "${C}════════════════════════════════════════${N}"

if [[ $FAIL -gt 0 ]]; then
    echo ""
    echo -e "${R}✗ FAILED${N} - Some checks failed!"
    echo ""
    echo "To fix:"
    echo "  1. Run: ~/.dotfiles/scripts/theme-manager.py $THEME"
    echo "  2. Re-run: ~/.dotfiles/scripts/check-themes.sh"
    echo ""
    exit 1
elif [[ $WARN -gt 0 ]]; then
    echo ""
    echo -e "${Y}⚠ PASSED (with warnings)${N}"
    echo ""
    echo "Optional fixes:"
    echo "  - Review warnings above"
    echo "  - Run: ~/.dotfiles/scripts/theme-manager.py $THEME"
    echo ""
    exit 0
else
    echo ""
    echo -e "${G}✓ PASSED${N} - All checks passed!"
    echo ""
    echo "Theme '$THEME' is correctly applied to all applications."
    echo ""
    exit 0
fi
