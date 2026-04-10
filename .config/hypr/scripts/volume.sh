#!/usr/bin/env bash
set -euo pipefail

# ── Volume control for PipeWire (CLI wrapper) ─────────────────────────────────
# Usage: volume.sh [--inc|--dec|--toggle|--mic-inc|--mic-dec|--toggle-mic]
# Note: Visual OSD is handled by swayosd-server. This script only changes volume.

SINK="@DEFAULT_AUDIO_SINK@"
SOURCE="@DEFAULT_AUDIO_SOURCE@"

get_vol() { wpctl get-volume "$1" 2>/dev/null | grep -oE '[0-9]+\.[0-9]+' | head -1 || echo "0"; }

case "${1:-}" in
  --inc)        wpctl set-volume "$SINK"   5%+ ;;
  --dec)        wpctl set-volume "$SINK"   5%- ;;
  --toggle)     wpctl set-mute   "$SINK"   toggle ;;
  --mic-inc)    wpctl set-volume "$SOURCE" 5%+ ;;
  --mic-dec)    wpctl set-volume "$SOURCE" 5%- ;;
  --toggle-mic) wpctl set-mute   "$SOURCE" toggle ;;
  *)
    v=$(get_vol "$SINK")
    m=$(wpctl get-volume "$SINK" 2>/dev/null | grep -q MUTED && echo " [Muted]" || echo "")
    echo "${v}%${m}"
    ;;
esac
