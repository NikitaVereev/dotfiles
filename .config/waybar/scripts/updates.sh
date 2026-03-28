#!/bin/bash

CACHE_FILE="/tmp/waybar-updates"

if [[ -f "$CACHE_FILE" ]] && [[ $(find "$CACHE_FILE" -mmin -30) ]]; then
    count=$(cat "$CACHE_FILE")
else
    count=$(checkupdates 2>/dev/null | wc -l)
    echo "$count" >"$CACHE_FILE"
fi

if [[ "$count" -eq 0 ]]; then
    echo ""
else
    echo "$count"
fi
