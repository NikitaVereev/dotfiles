#!/usr/bin/env bash
set -euo pipefail

# Restart Waybar and SwayNC (exact process match, user-only)
pkill -x -u "$USER" waybar 2>/dev/null || true
pkill -x -u "$USER" swaync 2>/dev/null || true

# Start SwayNC in background, then replace shell with Waybar
swaync &
exec waybar
