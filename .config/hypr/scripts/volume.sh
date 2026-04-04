#!/usr/bin/env bash
# =============================================================================
# Volume Control Script (PipeWire/wireplumber)
# Uses wpctl (modern PipeWire control tool)
# Usage: volume.sh [--inc|--dec|--toggle|--mic-inc|--mic-dec|--toggle-mic]
# =============================================================================

set -euo pipefail

# ── Helper Functions ──────────────────────────────────────────────────────────

get_volume() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

get_mic_volume() {
  wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2 * 100)}'
}

is_muted() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED
}

is_mic_muted() {
  wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED
}

send_notification() {
  local volume="$1"
  local muted="$2"
  local icon="audio-volume-high"

  if [[ "$muted" == "true" ]]; then
    icon="audio-volume-muted"
  elif [[ "$volume" -ge 70 ]]; then
    icon="audio-volume-high"
  elif [[ "$volume" -ge 30 ]]; then
    icon="audio-volume-medium"
  else
    icon="audio-volume-low"
  fi

  notify-send \
    -t 1500 \
    -u low \
    -i "$icon" \
    "Volume: ${volume}%" \
    "$([[ "$muted" == "true" ]] && echo 'Muted' || echo 'Unmuted')"
}

send_mic_notification() {
  local volume="$1"
  local muted="$2"
  local icon="microphone-sensitivity-high"

  if [[ "$muted" == "true" ]]; then
    icon="microphone-sensitivity-muted"
  elif [[ "$volume" -ge 70 ]]; then
    icon="microphone-sensitivity-high"
  elif [[ "$volume" -ge 30 ]]; then
    icon="microphone-sensitivity-medium"
  else
    icon="microphone-sensitivity-low"
  fi

  notify-send \
    -t 1500 \
    -u low \
    -i "$icon" \
    "Mic Volume: ${volume}%" \
    "$([[ "$muted" == "true" ]] && echo 'Muted' || echo 'Unmuted')"
}

# ── Main Logic ────────────────────────────────────────────────────────────────

case "${1:-}" in
  --inc)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    vol=$(get_volume)
    mute=$(is_muted && echo "true" || echo "false")
    send_notification "$vol" "$mute"
    ;;

  --dec)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    vol=$(get_volume)
    mute=$(is_muted && echo "true" || echo "false")
    send_notification "$vol" "$mute"
    ;;

  --toggle)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    vol=$(get_volume)
    mute=$(is_muted && echo "true" || echo "false")
    send_notification "$vol" "$mute"
    ;;

  --mic-inc)
    wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+
    vol=$(get_mic_volume)
    mute=$(is_mic_muted && echo "true" || echo "false")
    send_mic_notification "$vol" "$mute"
    ;;

  --mic-dec)
    wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-
    vol=$(get_mic_volume)
    mute=$(is_mic_muted && echo "true" || echo "false")
    send_mic_notification "$vol" "$mute"
    ;;

  --toggle-mic)
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    vol=$(get_mic_volume)
    mute=$(is_mic_muted && echo "true" || echo "false")
    send_mic_notification "$vol" "$mute"
    ;;

  *)
    # Default: show current volume
    vol=$(get_volume)
    mute=$(is_muted && echo "true" || echo "false")
    echo "${vol}%$([[ "$mute" == "true" ]] && echo " [Muted]" || echo "")"
    ;;
esac
