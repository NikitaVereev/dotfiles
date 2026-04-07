#!/usr/bin/env bash
set -euo pipefail

# ── Volume control for PipeWire ───────────────────────────────────────────────
# Usage: volume.sh [--inc|--dec|--toggle|--mic-inc|--mic-dec|--toggle-mic]

SINK="@DEFAULT_AUDIO_SINK@"
SOURCE="@DEFAULT_AUDIO_SOURCE@"

# ── Helpers ────────────────────────────────────────────────────────────────────
get_vol() { wpctl get-volume "$1" | awk '{print int($2 * 100)}'; }
is_muted() { wpctl get-volume "$1" | grep -q MUTED; }

notify() {
    local vol="$1" muted="$2" icon_prefix="$3" title="$4"
    local icon
    if [[ "$muted" == true ]]; then
        icon="${icon_prefix}-muted"
    elif ((vol >= 70)); then
        icon="${icon_prefix}-high"
    elif ((vol >= 30)); then
        icon="${icon_prefix}-medium"
    else
        icon="${icon_prefix}-low"
    fi
    notify-send -t 1500 -u low -i "$icon" "$title: ${vol}%" \
        "$([[ "$muted" == true ]] && echo Muted || echo Unmuted)"
}

# ── Main ──────────────────────────────────────────────────────────────────────
case "${1:-}" in
--inc) wpctl set-volume "$SINK" 5%+ ;;
--dec) wpctl set-volume "$SINK" 5%- ;;
--toggle) wpctl set-mute "$SINK" toggle ;;
--mic-inc) wpctl set-volume "$SOURCE" 5%+ ;;
--mic-dec) wpctl set-volume "$SOURCE" 5%- ;;
--toggle-mic) wpctl set-mute "$SOURCE" toggle ;;
*)
    v=$(get_vol "$SINK")
    m=$(is_muted "$SINK" && echo true || echo false)
    echo "${v}%$([[ "$m" == true ]] && echo " [Muted]")"
    exit 0
    ;;
esac

# Show notification
if [[ "$1" == --mic-* ]]; then
    v=$(get_vol "$SOURCE")
    m=$(is_muted "$SOURCE" && echo true || echo false)
    notify "$v" "$m" "microphone-sensitivity" "Mic Volume"
else
    v=$(get_vol "$SINK")
    m=$(is_muted "$SINK" && echo true || echo false)
    notify "$v" "$m" "audio-volume" "Volume"
fi
