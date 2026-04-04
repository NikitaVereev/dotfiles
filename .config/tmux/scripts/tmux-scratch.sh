#!/usr/bin/env bash
set -euo pipefail

session="_popup_scratchpad"

# Create session if it doesn't exist
if ! tmux has-session -t "$session" 2>/dev/null; then
	session_id="$(tmux new-session -dP -s "$session" -F '#{session_id}')"
	tmux set-option -t "$session_id" status off
	tmux set-option -t "$session_id" prefix None
	session="$session_id"
fi

# Attach to the scratchpad session
exec tmux attach -t "$session" >/dev/null 2>&1 || {
    echo "Failed to attach to tmux session '$session'" >&2
    exit 1
}
