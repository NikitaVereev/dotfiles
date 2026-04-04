#!/usr/bin/env bash
set -euo pipefail

# ── Cross-distro package update counter ────────────────────────────────────────
count_updates() {
    if command -v checkupdates &>/dev/null; then
        (checkupdates 2>/dev/null || true) | wc -l
    elif command -v apt &>/dev/null; then
        (apt list --upgradable 2>/dev/null || true) | grep -c 'upgradable' || echo 0
    elif command -v dnf &>/dev/null; then
        (dnf check-update -q 2>/dev/null || true) | grep -cE '^[a-z]' || echo 0
    else
        echo 0
    fi
}

# ── Cache (secure: XDG_RUNTIME_DIR, per-user, no symlink attacks) ─────────────
CACHE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
CACHE_FILE="$CACHE_DIR/waybar-updates"

# Re-check every 30 minutes
if [[ -f "$CACHE_FILE" ]] && [[ $(find "$CACHE_FILE" -mmin -30) ]]; then
    count=$(cat "$CACHE_FILE")
else
    count=$(count_updates)
    echo "$count" > "$CACHE_FILE"
fi

if [[ "$count" -gt 0 ]]; then
    echo "$count"
fi
