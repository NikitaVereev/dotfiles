#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# Pre-commit Checks for Dotfiles
# ═══════════════════════════════════════════════════════════════════════════════

set -uo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Helper functions
pass() {
    echo -e "${GREEN}   ✓${NC} $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}   ✗${NC} $1"
    ((FAILED++))
}

warn() {
    echo -e "${YELLOW}   !${NC} $1"
    ((WARNINGS++))
}

section() {
    echo ""
    echo -e "${BLUE}▶${NC} $1"
}

# ═══════════════════════════════════════════════════════════════════════════════
# Main Checks
# ═══════════════════════════════════════════════════════════════════════════════

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Pre-commit Checks for Dotfiles                 ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"

# ── 1. Bash Scripts Syntax ─────────────────────────────────────────────────────
section "Bash Scripts Syntax"

for script in install.sh .config/hypr/scripts/*.sh; do
    if [[ -f "$script" ]]; then
        if bash -n "$script" 2>/dev/null; then
            pass "$(basename "$script")"
        else
            fail "$(basename "$script") - syntax error"
        fi
    fi
done

# ── 2. Zsh Configuration ───────────────────────────────────────────────────────
section "Zsh Configuration"

if zsh -n .zshrc 2>/dev/null; then
    pass ".zshrc syntax"
else
    fail ".zshrc syntax error"
fi

# ── 3. Makefile ────────────────────────────────────────────────────────────────
section "Makefile"

if make -n help >/dev/null 2>&1; then
    pass "Makefile syntax"
else
    fail "Makefile syntax error"
fi

# ── 4. Neovim Lua Files ────────────────────────────────────────────────────────
section "Neovim Lua Configuration"

if command -v luacheck >/dev/null 2>&1; then
    if luacheck .config/nvim/lua/ >/dev/null 2>&1; then
        pass "Lua syntax (luacheck)"
    else
        warn "Lua has warnings (luacheck)"
    fi
else
    warn "luacheck not installed, skipping Lua check"
fi

# ── 5. Starship Configuration ──────────────────────────────────────────────────
section "Starship Configuration"

if starship init zsh --print-full-init >/dev/null 2>&1; then
    pass "Starship config valid"
else
    fail "Starship config invalid"
fi

# ── 6. Shell Scripts (shellcheck) ──────────────────────────────────────────────
section "Shellcheck (if available)"

if command -v shellcheck >/dev/null 2>&1; then
    if shellcheck install.sh .config/hypr/scripts/*.sh >/dev/null 2>&1; then
        pass "shellcheck passed"
    else
        warn "shellcheck found issues"
    fi
else
    warn "shellcheck not installed, skipping"
fi

# ── 7. Git Status ──────────────────────────────────────────────────────────────
section "Git Status"

CHANGED_FILES=$(git status --short 2>/dev/null | wc -l)
echo -e "   Changed files: ${CYAN}${CHANGED_FILES}${NC}"

if [[ $CHANGED_FILES -gt 0 ]]; then
    pass "Git working tree clean or has changes"
else
    warn "No changes to commit"
fi

# ── 8. Symlinks Check ──────────────────────────────────────────────────────────
section "Symlinks Status"

BROKEN_LINKS=0
for link in .zshrc .config/hypr .config/nvim .config/waybar; do
    if [[ -L "$HOME/$link" ]]; then
        if [[ -e "$HOME/$link" ]]; then
            : # Link is valid
        else
            ((BROKEN_LINKS++))
        fi
    fi
done

if [[ $BROKEN_LINKS -eq 0 ]]; then
    pass "All symlinks valid"
else
    fail "$BROKEN_LINKS broken symlinks"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Summary                                ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "   ${GREEN}Passed:${NC}   $PASSED"
echo -e "   ${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "   ${RED}Failed:${NC}   $FAILED"
echo ""

if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}❌ Pre-commit checks FAILED${NC}"
    echo ""
    echo "Please fix the issues above before committing."
    exit 1
elif [[ $WARNINGS -gt 0 ]]; then
    echo -e "${YELLOW}⚠ Pre-commit checks passed with warnings${NC}"
    echo ""
    echo "You can commit, but consider fixing the warnings."
    exit 0
else
    echo -e "${GREEN}✅ All pre-commit checks PASSED${NC}"
    echo ""
    echo "Ready to commit!"
    exit 0
fi
