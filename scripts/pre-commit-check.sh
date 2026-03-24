#!/usr/bin/env bash
# Pre-commit Checks - Human-readable output
set -uo pipefail

C="\033[0;36m"; G="\033[0;32m"; R="\033[0;31m"; Y="\033[1;33m"; N="\033[0m"
PASS=0; FAIL=0; WARN=0

pass() { echo -e "${G}✓${N} $1"; ((PASS++)); }
fail() { echo -e "${R}✗${N} $1"; ((FAIL++)); }
warn() { echo -e "${Y}!${N} $1"; ((WARN++)); }
section() { echo -e "\n${G}▶${N} $1"; }
error_detail() { echo -e "   ${R}→${N} $1"; }

# Bash syntax
section "Bash Syntax"
for f in install.sh .config/hypr/scripts/*.sh; do
    [[ -f "$f" ]] || continue
    if output=$(bash -n "$f" 2>&1); then
        pass "$f"
    else
        fail "$f"
        error_detail "Syntax error:"
        echo "$output" | while IFS= read -r line; do
            [[ -n "$line" ]] && error_detail "$line"
        done
    fi
done

# Zsh
section "Zsh Configuration"
if output=$(zsh -n .zshrc 2>&1); then
    pass ".zshrc"
else
    fail ".zshrc"
    error_detail "Syntax error:"
    echo "$output" | while IFS= read -r line; do
        [[ -n "$line" ]] && error_detail "$line"
    done
fi

# Makefile
section "Makefile"
if output=$(make -n help 2>&1); then
    pass "syntax"
else
    fail "syntax"
    error_detail "Error:"
    echo "$output" | head -3 | while IFS= read -r line; do
        [[ -n "$line" ]] && error_detail "$line"
    done
fi

# Lua
section "Lua (Neovim)"
if command -v luacheck &>/dev/null; then
    cd .config/nvim
    if output=$(luacheck --config .luacheckrc lua/ 2>&1); then
        pass "luacheck"
    else
        fail "luacheck"
        error_detail "Issues found (first 10):"
        echo "$output" | grep -E "^\s+\." | head -10 | while IFS= read -r line; do
            error_detail "$line"
        done
        total=$(echo "$output" | grep -c "warning\|error" || echo 0)
        [[ $total -gt 10 ]] && error_detail "... and $((total-10)) more"
    fi
    cd - >/dev/null
else
    warn "luacheck not installed (install: sudo pacman -S luacheck)"
fi

# Shellcheck
section "Shellcheck"
if command -v shellcheck &>/dev/null; then
    output=$(shellcheck install.sh .config/hypr/scripts/*.sh 2>&1)
    if [[ $? -eq 0 ]]; then
        pass "passed"
    else
        warn "warnings found:"
        echo "$output" | grep -E "^In .* line" | head -5 | while IFS= read -r line; do
            error_detail "$line"
        done
        echo "$output" | grep -E "^    " | head -5 | while IFS= read -r line; do
            [[ -n "$line" ]] && error_detail "$line"
        done
        total=$(echo "$output" | grep -c "^In" || echo 0)
        [[ $total -gt 5 ]] && error_detail "... and $((total-5)) more warnings"
        error_detail "Fix: Edit file and re-run 'make lint'"
    fi
else
    warn "not installed (install: sudo pacman -S shellcheck)"
fi

# JSON/JSONC/TOML
section "JSON/JSONC/TOML"

# JSONC files (with comments)
for f in .config/waybar/config.jsonc .config/fastfetch/config.jsonc; do
    [[ -f "$f" ]] || continue
    if output=$(python3 -c "
import json,re,sys
try:
    c=open('$f').read()
    c=re.sub(r'^\s*//.*$','',c,flags=re.MULTILINE)
    c=re.sub(r',(\s*[\]\}])',r'\1',c)
    json.loads(c)
except Exception as e:
    print(f'Line {e}', file=sys.stderr)
    sys.exit(1)
" 2>&1); then
        pass "$f"
    else
        fail "$f"
        error_detail "Invalid JSONC:"
        echo "$output" | while IFS= read -r line; do
            [[ -n "$line" ]] && error_detail "$line"
        done
    fi
done

# Pure JSON files (strict)
for f in .config/swaync/config.json .config/nvim/lazy-lock.json; do
    [[ -f "$f" ]] || continue
    if output=$(python3 -m json.tool "$f" 2>&1); then
        pass "$f"
    else
        fail "$f"
        error_detail "Invalid JSON:"
        echo "$output" | while IFS= read -r line; do
            [[ -n "$line" ]] && error_detail "$line"
        done
    fi
done

# TOML files
for f in .config/yazi/yazi.toml; do
    [[ -f "$f" ]] || continue
    if output=$(python3 -c "import tomllib;tomllib.load(open('$f','rb'))" 2>&1); then
        pass "$f"
    else
        fail "$f"
        error_detail "Invalid TOML:"
        echo "$output" | while IFS= read -r line; do
            [[ -n "$line" ]] && error_detail "$line"
        done
    fi
done

# Git
section "Git Status"
CHANGED=$(git status --short 2>/dev/null | wc -l)
if [[ $CHANGED -gt 0 ]]; then
    pass "$CHANGED files changed"
    echo -e "   ${C}Tip:${N} Review changes: git diff"
else
    warn "no changes (nothing to commit)"
fi

# Summary
echo -e "\n═══════════════════════════════════════"
echo -e "  ${G}Passed${N}:   $PASS"
echo -e "  ${Y}Warnings${N}:  $WARN"
echo -e "  ${R}Failed${N}:    $FAIL"
echo "═══════════════════════════════════════"

if [[ $FAIL -gt 0 ]]; then
    echo -e "\n${R}✗ FAILED${N} - Fix errors before committing"
    echo -e "${C}Next steps:${N}"
    echo "  1. Review errors above"
    echo "  2. Edit files to fix"
    echo "  3. Re-run: make lint"
    exit 1
elif [[ $WARN -gt 0 ]]; then
    echo -e "\n${Y}⚠ PASSED (with warnings)${N}"
    echo -e "${C}Optional:${N} Fix warnings for cleaner code"
    exit 0
else
    echo -e "\n${G}✓ PASSED${N} - Ready to commit!"
    echo -e "${C}Next:${N} git add . && git commit"
    exit 0
fi
