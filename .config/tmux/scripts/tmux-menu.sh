#!/usr/bin/env bash
set -euo pipefail

# Build session/window menu for fzf
{
	tmux list-sessions -F '#S' | grep -v '^_popup_' | while IFS= read -r session; do
		echo "▼ $session"
		tmux list-windows -t "$session" -F '  ⦿ #S:#I #W'
	done
} | fzf --reverse || true | while IFS= read -r choice; do
    # Extract target: after ▼/⦿ take the second field
    target="${choice#* }"
    [[ -n "$target" ]] && tmux switch-client -t "$target"
done
