#!/usr/bin/env bash
set -euo pipefail

command -v jq &>/dev/null || { echo '{"text":"jq missing","class":"window error"}'; exit 0; }

active=$(hyprctl activewindow -j 2>/dev/null) || exit 0

read -r class title < <(jq -r '[.class // "", .title // ""] | @tsv' <<<"$active")

# Strip whitespace
class="${class// /}"
title="${title// /}"

if [[ -z "$class" && -z "$title" ]]; then
    printf '{"text":" Empty","tooltip":"No active window","class":"window empty"}\n'
    exit 0
fi

title_lower="${title,,}"
class_lower="${class,,}"

# ── Detect app icon and name ─────────────────────────────────────────────────
case "$title_lower" in
*nvim* | *vim* | *neovide*)
    icon=""; appname="Neovim" ;;
*yazi*)
    icon=""; appname="Yazi" ;;
*)
    case "$class_lower" in
    *firefox* | *mozilla*)  icon=""; appname="Firefox" ;;
    *kitty*)                icon="󰄛"; appname="Kitty" ;;
    *chromium* | *chrome* | *brave*) icon=""; appname="Chrome" ;;
    *spotify*)              icon=""; appname="Spotify" ;;
    *steam*)                icon=""; appname="Steam" ;;
    *obsidian*)             icon=""; appname="Obsidian" ;;
    *zed*)                  icon=""; appname="Zed" ;;
    *code* | *vscodium*)    icon=""; appname="Code" ;;
    *discord*)              icon=""; appname="Discord" ;;
    *)
        icon="󰣆"
        # Strip numbers and dots from class name, limit to 12 chars
        appname="${class:0:12}"
        appname="${appname//[0-9.]/}"
        [[ -z "${appname// /}" ]] && appname="Empty"
        ;;
    esac
    ;;
esac

[[ -z "$title" ]] && title="No active window"

# ── Output JSON (properly escaped via jq) ────────────────────────────────────
jq -cn \
    --arg text "$icon $appname" \
    --arg tooltip "${title:0:50}" \
    '{"text": $text, "tooltip": $tooltip, "class": "window"}'
