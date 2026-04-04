#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# Theme Checker — verifies theme is correctly applied to all applications
# Usage: check-themes.sh [theme-name]
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# ── Config ─────────────────────────────────────────────────────────────────────
# Auto-detect dotfiles directory from this script's location
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
THEME="${1:-gruvbox}"
CONFIG_DIR="$HOME/.config"
PASS=0
FAIL=0
WARN=0

# ── Helpers ────────────────────────────────────────────────────────────────────
pass()  { printf '\033[0;32m✓\033[0m %s\n' "$1"; ((PASS++)) || true; }
fail()  { printf '\033[0;31m✗\033[0m %s\n' "$1"; ((FAIL++)) || true; }
warn()  { printf '\033[1;33m!\033[0m %s\n' "$1"; ((WARN++)) || true; }
section() { printf '\n\033[0;36m▶\033[0m %s\n' "$1"; }

# ── Checks ─────────────────────────────────────────────────────────────────────
check_symlink() {
    local app="$1" file="$2" expected="$3"
    if [[ ! -L "$file" ]]; then
        fail "$app: not a symlink"
        return
    fi
    local target
    target=$(readlink "$file")
    if [[ "$target" == "$expected" ]]; then
        pass "$app: symlink → $target"
    else
        fail "$app: symlink → $target (expected: $expected)"
    fi
}

check_file() {
    local app="$1" file="$2"
    if [[ -f "$file" ]]; then
        pass "$app: file exists"
    else
        fail "$app: not found — $file"
    fi
}

check_no_unreplaced() {
    local app="$1" file="$2"
    [[ -f "$file" ]] || return
    if grep -qE '\{\{[^}]*\}\}' "$file"; then
        local count
        count=$(grep -oE '\{\{[^}]*\}\}' "$file" | wc -l)
        fail "$app: $count unreplaced template variables"
    else
        pass "$app: no unreplaced variables"
    fi
}

# ── App definitions ────────────────────────────────────────────────────────────
# Format: "app_name  ext  config_subdir"
# Symlink:  ~/.config/<subdir>/themes/current.<ext> → <theme>.<ext>
# Source:   <dotfiles>/.config/<subdir>/themes/<theme>.<ext>
APPS=(
    "Hyprland   conf  hypr"
    "Waybar     css   waybar"
    "Kitty      conf  kitty"
    "Rofi       rasi  rofi"
    "Starship   toml  starship"
    "SwayNC     css   swaync"
    "Tmux       conf  tmux"
    "Yazi       toml  yazi"
)

# ── Main ───────────────────────────────────────────────────────────────────────
printf '\033[0;36m╔════════════════════════════════════════════╗\033[0m\n'
printf '\033[0;36m║     Theme Check — %-16s            ║\033[0m\n' "$THEME"
printf '\033[0;36m╚════════════════════════════════════════════╝\033[0m\n'

# Check all themed apps
for spec in "${APPS[@]}"; do
    read -r app ext subdir <<< "$spec"
    section "$app"

    local_dotfiles="$DOTFILES_DIR/.config/$subdir/themes/${THEME}.${ext}"
    local_config="$CONFIG_DIR/$subdir/themes/current.${ext}"

    check_symlink  "$app" "$local_config" "${THEME}.${ext}"
    check_file     "$app" "$local_dotfiles"
    check_no_unreplaced "$app" "$local_config"
done

# ── Neovim ─────────────────────────────────────────────────────────────────────
section "Neovim"
nvim_theme_file="$CONFIG_DIR/nvim/themes/current_theme"
if [[ -f "$nvim_theme_file" ]]; then
    content=$(cat "$nvim_theme_file")
    if [[ "$content" == "$THEME" ]]; then
        pass "current_theme = $THEME"
    else
        fail "current_theme = $content (expected: $THEME)"
    fi
else
    fail "current_theme file not found"
fi

# ── GTK ────────────────────────────────────────────────────────────────────────
section "GTK"
if command -v gsettings &>/dev/null; then
    gtk_theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'" || echo "not set")
    gtk_lower="${gtk_theme,,}"
    theme_lower="${THEME,,}"
    if [[ "$gtk_lower" == *"${theme_lower}"* ]]; then
        pass "GTK theme = $gtk_theme"
    else
        warn "GTK theme = $gtk_theme (expected: *${THEME}*)"
    fi
else
    warn "gsettings not available"
fi

gtk3_ini="$HOME/.config/gtk-3.0/settings.ini"
if [[ -f "$gtk3_ini" ]] && grep -q "gtk-theme-name=" "$gtk3_ini"; then
    pass "GTK 3.0 config exists"
else
    warn "GTK 3.0 config missing"
fi

# ── Palette ────────────────────────────────────────────────────────────────────
section "Palette"
check_file "Palette" "$DOTFILES_DIR/themes/palettes/${THEME}.toml"
check_symlink "Palette" "$DOTFILES_DIR/themes/palettes/current.toml" "${THEME}.toml"

# ── Scripts ────────────────────────────────────────────────────────────────────
section "Scripts"
if [[ -x "$DOTFILES_DIR/scripts/theme-manager.py" ]]; then
    pass "theme-manager.py is executable"
else
    warn "theme-manager.py not executable"
fi

# ── Summary ────────────────────────────────────────────────────────────────────
echo ""
printf '\033[0;36m════════════════════════════════════════\033[0m\n'
printf '  \033[0;32mPassed\033[0m:   %d\n' "$PASS"
printf '  \033[1;33mWarnings\033[0m:  %d\n' "$WARN"
printf '  \033[0;31mFailed\033[0m:    %d\n' "$FAIL"
printf '\033[0;36m════════════════════════════════════════\033[0m\n'

if [[ $FAIL -gt 0 ]]; then
    echo ""
    printf '\033[0;31m✗ FAILED\033[0m — Fix with: theme-manager.py %s\n' "$THEME"
    exit 1
elif [[ $WARN -gt 0 ]]; then
    echo ""
    printf '\033[1;33m⚠ PASSED (with warnings)\033[0m\n'
    exit 0
else
    echo ""
    printf '\033[0;32m✓ PASSED\033[0m — Theme '\''%s'\'' correctly applied\n' "$THEME"
    exit 0
fi
