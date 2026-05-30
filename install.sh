#!/usr/bin/env bash
# Post-stow bootstrap for cross-platform dotfiles install.
# Clones standalone nvim-config (so we can also use it cleanly on macOS),
# and optionally pre-installs Lazy.nvim plugins.
#
# Run AFTER `stow -t ~ .` from inside the dotfiles repo.

set -euo pipefail

# --- Config ---
NVIM_REPO="https://github.com/NikitaVereev/nvim-config.git"
NVIM_TARGET="$HOME/.config/nvim"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

info()  { echo -e "${BLUE}==>${RESET} $*"; }
ok()    { echo -e "${GREEN}✓${RESET} $*"; }
warn()  { echo -e "${YELLOW}⚠${RESET} $*"; }
error() { echo -e "${RED}✗${RESET} $*" >&2; }

# --- nvim-config ---
clone_nvim() {
  if [[ -d "$NVIM_TARGET/.git" ]]; then
    info "nvim-config exists, pulling latest..."
    git -C "$NVIM_TARGET" pull --ff-only || warn "git pull failed, leaving as-is"
    ok "nvim-config updated"
  elif [[ -e "$NVIM_TARGET" ]]; then
    error "$NVIM_TARGET exists but is not a git repo. Move or delete it first."
    return 1
  else
    info "Cloning nvim-config to $NVIM_TARGET..."
    git clone "$NVIM_REPO" "$NVIM_TARGET"
    ok "nvim-config cloned"
  fi
}

# --- Lazy.nvim bootstrap ---
bootstrap_lazy() {
  if ! command -v nvim >/dev/null 2>&1; then
    warn "nvim not in PATH; skipping plugin bootstrap. Install nvim ≥ 0.12 then run :Lazy sync manually."
    return
  fi
  info "Bootstrapping Lazy.nvim plugins (headless)..."
  nvim --headless "+Lazy! sync" "+qa" 2>&1 | tail -5 || warn "Lazy sync exited non-zero (often OK on first run)"
  ok "Plugins installed"
}

# --- tmux TPM bootstrap (optional) ---
bootstrap_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    ok "TPM already present"
    return
  fi
  info "Cloning TPM..."
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  ok "TPM cloned (run '<prefix> I' inside tmux to install plugins)"
}

main() {
  echo
  info "Dotfiles post-stow bootstrap"
  echo

  clone_nvim
  bootstrap_tpm
  bootstrap_lazy

  echo
  ok "All done."
  echo
  echo "Next steps:"
  echo "  • Inside tmux: <prefix> I (Shift-I) to install tmux plugins"
  echo "  • Inside nvim: :MasonToolsInstall and :TSUpdate"
  echo "  • See $NVIM_TARGET/README.md for full setup notes"
}

main "$@"
