#!/usr/bin/env bash
set -euo pipefail

# ── Arch Linux package update counter ─────────────────────────────────────────
count_updates() {
    (checkupdates 2>/dev/null || true) | wc -l
}

# ── Cache (secure: XDG_RUNTIME_DIR, per-user, no symlink attacks) ─────────────
CACHE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
CACHE_FILE="$CACHE_DIR/waybar-updates"
mkdir -p "$CACHE_DIR" 2>/dev/null || true

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
