#!/bin/bash
active=$(hyprctl activewindow -j 2>/dev/null) || exit 0

read -r class title < <(jq -r '[.class // "", .title // ""] | @tsv' <<<"$active")

if [[ -z "${class// /}" && -z "${title// /}" ]]; then
    printf '{"text":" Empty","tooltip":"No active window","class":"window empty"}\n'
    exit 0
fi

title_lower=${title,,}
class_lower=${class,,}

case "$title_lower" in
*nvim* | *vim* | *neovide*)
    icon=""
    appname="Neovim"
    ;;
*yazi*)
    icon=""
    appname="Yazi"
    ;;
*)
    case "$class_lower" in
    *firefox* | *mozilla*)
        icon=""
        appname="Firefox"
        ;;
    *kitty*)
        icon="󰄛"
        appname="Kitty"
        ;;
    *chromium* | *chrome* | *brave*)
        icon=""
        appname="Chrome"
        ;;
    *spotify*)
        icon=""
        appname="Spotify"
        ;;
    *steam*)
        icon=""
        appname="Steam"
        ;;
    *obsidian*)
        icon=""
        appname="Obsidian"
        ;;
    *zed*)
        icon=""
        appname="Zed"
        ;;
    *code* | *vscodium*)
        icon=""
        appname="Code"
        ;;
    *discord*)
        icon=""
        appname="Discord"
        ;;
    *)
        icon="󰣆"
        appname=$(sed 's/[0-9.-]\+//g' <<<"${class:0:12}")
        [[ -z "${appname// /}" ]] && appname="Empty"
        ;;
    esac
    ;;
esac

[[ -z "${title// /}" ]] && title="No active window"

printf '{"text":"%s %s","tooltip":"%s","class":"window"}\n' \
    "$icon" "$appname" "${title:0:50}"
