#!/usr/bin/env bash
set -euo pipefail

command -v socat &>/dev/null || { echo "window-event-daemon: socat not found" >&2; exit 1; }

resolve_sig() {
    local sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"
    local retries=20
    while [[ -z "$sig" ]]; do
        sleep 0.5
        sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"
        retries=$((retries - 1))
        [[ $retries -gt 0 ]] || return 1
    done
    echo "$sig"
}

# ── Main loop: re-resolve on each reconnect (handles Hyprland restarts) ──────
while true; do
    sig=$(resolve_sig) || { sleep 5; continue; }
    socket="$XDG_RUNTIME_DIR/hypr/$sig/.socket2.sock"

    # Wait for socket
    retries=10
    while [[ ! -S "$socket" ]]; do
        sleep 0.5
        retries=$((retries - 1))
        [[ $retries -gt 0 ]] || { sleep 5; continue 2; }
    done

    # Listen for events
    socat -U - "UNIX-CONNECT:$socket" 2>/dev/null | while IFS= read -r line; do
        case "$line" in
            activewindowv2*|workspacev2*|focusedmonv2*|openwindow*|closewindow*)
                pkill -x -RTMIN+8 waybar 2>/dev/null || true
                ;;
        esac
    done
    sleep 1
done
