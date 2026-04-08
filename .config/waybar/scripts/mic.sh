#!/usr/bin/env bash
set -euo pipefail

state=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)
vol_raw=$(echo "$state" | grep -oE '[0-9]+\.[0-9]+' | head -1)

if [[ -z "$vol_raw" ]]; then
    vol=0
else
    vol=$(awk "BEGIN {printf \"%d\", $vol_raw * 100}")
fi

if echo "$state" | grep -q MUTED; then
    printf '{"text":"","tooltip":"Микрофон выключен","class":"muted"}\n'
else
    # Берём именно node.description, а не profile.description
    desc=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -m1 'node.description' | sed 's/.*= "\([^"]*\)"/\1/')
    [[ -z "$desc" ]] && desc="Microphone"
    printf '{"text":"","tooltip":"Mic: %s%% — %s","class":"unmuted"}\n' "$vol" "$desc"
fi
