#!/usr/bin/env bash
set -euo pipefail

# ── Resolve Hyprland instance signature ────────────────────────────────────────
sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"

# Retry if empty (may not be set yet at exec-once time)
retries=20
while [[ -z "$sig" ]]; do
    sleep 0.5
    sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"
    retries=$((retries - 1))
    [[ $retries -gt 0 ]] || { echo "window-event-daemon: HYPRLAND_INSTANCE_SIGNATURE not set" >&2; exit 1; }
done

socket="$XDG_RUNTIME_DIR/hypr/$sig/.socket2.sock"

# Wait for socket to appear
retries=10
while [[ ! -S "$socket" ]]; do
    sleep 0.5
    retries=$((retries - 1))
    [[ $retries -gt 0 ]] || { echo "window-event-daemon: socket not found: $socket" >&2; exit 1; }
done

# ── Listen for window events and signal Waybar to refresh ──
while true; do
    socat -U - "UNIX-CONNECT:$socket" 2>/dev/null | while IFS= read -r line; do
        case "$line" in
            activewindowv2*|workspacev2*|focusedmonv2*|openwindow*|closewindow*)
                pkill -x -RTMIN+8 waybar 2>/dev/null || true
                ;;
        esac
    done
    # If socat disconnects, retry after 1 second
    sleep 1
done
