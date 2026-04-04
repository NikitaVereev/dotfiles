#!/usr/bin/env bash
set -euo pipefail

# ── Validate Hyprland instance signature (hex only, prevents path traversal) ──
if [[ ! "${HYPRLAND_INSTANCE_SIGNATURE:-}" =~ ^[a-f0-9]+$ ]]; then
    exit 1
fi

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
[[ -S "$socket" ]] || exit 1

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
