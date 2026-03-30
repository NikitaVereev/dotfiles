#!/usr/bin/env bash
# Dotfiles Installer - Minimal Edition
# Supports: Arch, Debian, Fedora, macOS
set -euo pipefail

# Colors
C="\033[0;36m"
G="\033[0;32m"
R="\033[0;31m"
N="\033[0m"
info() { echo -e "${C}→${N} $1"; }
ok() { echo -e "${G}✓${N} $1"; }
err() { echo -e "${R}✗${N} $1"; }

# Config
DIR="$(cd "$(dirname "$0")" && pwd)"
OS=$(if [[ -f /etc/arch-release ]]; then
    echo arch
elif [[ -f /etc/debian_version ]]; then
    echo debian
elif [[ -f /etc/fedora-release ]]; then
    echo fedora
elif [[ "$(uname)" == "Darwin" ]]; then
    echo macos
else echo unknown; fi)

# Packages
ARCH_PKGS=(hyprland hyprlock hyprpaper waybar swaync kitty tmux zsh starship
    zoxide fzf fd rofi yazi thunar fastfetch cliphist awww imagemagick
    noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd
    wireplumber pipewire pipewire-alsa pavucontrol networkmanager blueman
    brightnessctl playerctl polkit-kde-agent zsh-autosuggestions
    zsh-syntax-highlighting base-devel git cargo nodejs npm python go rust
    stow jq lazygit htop)
AUR_PKGS=(atuin)
DEB_PKGS=(git curl wget stow jq htop zsh tmux kitty starship zoxide rofi
    waybar swaync yazi ranger thunar fastfetch imagemagick pipewire
    wireplumber pavucontrol network-manager blueman brightnessctl
    playerctl fonts-noto fonts-noto-cjk build-essential nodejs python3 go)
FEDORA_PKGS=(git curl wget stow jq htop zsh tmux kitty starship zoxide
    rofi-wayland waybar swaync yazi ranger thunar fastfetch
    ImageMagick pipewire wireplumber pavucontrol NetworkManager
    blueman brightnessctl playerctl google-noto-fonts "@Development Tools")

# Install functions
install_arch() {
    sudo pacman -Sy --noconfirm "${ARCH_PKGS[@]}"
    if command -v yay &>/dev/null || command -v paru &>/dev/null; then
        command -v yay &>/dev/null && AUR_HELPER="yay" || AUR_HELPER="paru"
        $AUR_HELPER -S --noconfirm "${AUR_PKGS[@]}"
    else
        info "Installing yay..."
        tmp=$(mktemp -d)
        git clone --quiet https://aur.archlinux.org/yay.git "$tmp/yay"
        (cd "$tmp/yay" && makepkg -si --noconfirm)
        rm -rf "$tmp"
        yay -S --noconfirm "${AUR_PKGS[@]}"
    fi
}

install_deb() { sudo apt update && sudo apt install -y "${DEB_PKGS[@]}"; }
install_fedora() { sudo dnf update -y && sudo dnf install -y "${FEDORA_PKGS[@]}"; }
install_macos() {
    command -v brew &>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install "${MACOS_PACKAGES[@]}"
}

# External installers
install_ohmyzsh() {
    [[ -d "$HOME/.oh-my-zsh" ]] && return 0
    tmp=$(mktemp -d)
    timeout 60 git clone --depth 1 --quiet https://github.com/ohmyzsh/ohmyzsh.git "$tmp/ohmyzsh"
    RUNZSH=no CHSH=no sh "$tmp/ohmyzsh/tools/install.sh" "" --unattended
    rm -rf "$tmp"
}

install_fzf() {
    [[ -d "$HOME/.fzf" ]] && return 0
    [[ "$OS" == "arch" ]] && pacman -Qq fzf &>/dev/null && return 0
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --unattended
}

install_tpm() {
    [[ -d "$HOME/.tmux/plugins/tpm" ]] && return 0
    git clone --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
}

# Backup
backup() {
    local backup_dir
    backup_dir="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
    local items=(.config/hypr .config/nvim .config/waybar .config/rofi
        .config/swaync .config/kitty .config/tmux
        .config/starship .zshrc)
    mkdir -p "$backup_dir"
    for item in "${items[@]}"; do
        [[ -e "$HOME/$item" ]] && cp -r "$HOME/$item" "$backup_dir/" 2>/dev/null || true
    done
    [[ -n "$(ls -A "$backup_dir" 2>/dev/null)" ]] && ok "Backup: $backup_dir"
}

# Symlinks
create_symlinks() {
    local files=(.zshrc)
    local dirs=(.config/hypr .config/nvim .config/waybar .config/rofi
        .config/swaync .config/kitty .config/tmux
        .config/starship .config/yazi .config/fastfetch .config/wireplumber)

    for f in "${files[@]}"; do
        [[ -e "$DIR/$f" && ! -e "$HOME/$f" ]] && ln -s "$DIR/$f" "$HOME/$f"
    done
    for d in "${dirs[@]}"; do
        [[ -d "$DIR/$d" && ! -e "$HOME/$d" ]] && ln -s "$DIR/$d" "$HOME/$d"
    done
    ok "Symlinks created"
}

# Setup Neovim
setup_nvim() {
    mkdir -p "$HOME/.local/share/nvim/undo"
    command -v nvim || return 0
    info "Installing Neovim plugins..."
    NVIM_APPNAME=nvim nvim --headless "+Lazy! sync" +qa 2>&1 || true
}

# Default theme
setup_theme() {
    local theme="oxocarbon"
    ln -sf "$DIR/.config/hypr/themes/${theme}.conf" "$HOME/.config/hypr/themes/current.conf" 2>/dev/null || true
    echo "$theme" >"$HOME/.config/nvim/themes/current" 2>/dev/null || true
    ln -sf "$DIR/.config/waybar/themes/${theme}.css" "$HOME/.config/waybar/themes/current.css" 2>/dev/null || true
    ln -sf "$DIR/.config/rofi/themes/${theme}.rasi" "$HOME/.config/rofi/themes/current.rasi" 2>/dev/null || true
    ln -sf "$DIR/.config/swaync/themes/${theme}.css" "$HOME/.config/swaync/themes/current.css" 2>/dev/null || true
    ln -sf "$DIR/.config/starship/themes/${theme}.toml" "$HOME/.config/starship/themes/current.toml" 2>/dev/null || true
}

# Enable services
enable_services() {
    [[ "$OS" == "macos" ]] && return 0
    sudo systemctl enable NetworkManager 2>/dev/null || true
    sudo systemctl enable bluetooth 2>/dev/null || true
}

# Main
main() {
    echo -e "${C}╔════════════════════════════════════════════╗${N}"
    echo -e "${C}║     Dotfiles Installer                     ║${N}"
    echo -e "${C}╚════════════════════════════════════════════╝${N}"
    info "OS: $OS | Dir: $DIR"

    read -rp "Continue? (y/N): " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && {
        echo ""
        info "Installation cancelled"
        exit 0
    }

    # Check OS support
    if [[ "$OS" == "unknown" ]]; then
        err "Unsupported OS"
        echo ""
        echo "Supported: Arch, Debian, Fedora, macOS"
        echo "Your OS: $(uname -a)"
        echo ""
        echo "You can continue at your own risk, but packages may not install correctly."
        read -rp "Continue anyway? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && {
            info "Installation cancelled"
            exit 0
        }
    fi

    # Install packages
    info "Installing packages..."
    case "$OS" in
    arch) install_arch ;;
    debian) install_deb ;;
    fedora) install_fedora ;;
    macos) install_macos ;;
    *)
        err "Unsupported OS: $OS"
        exit 1
        ;;
    esac
    ok "Packages installed"

    # External installers
    install_ohmyzsh && ok "Oh My Zsh"
    install_fzf && ok "FZF"
    install_tpm && ok "TPM"

    # Backup & symlinks
    backup
    create_symlinks

    # Setup
    setup_nvim
    setup_theme
    enable_services

    # Done
    echo ""
    ok "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Reboot: sudo reboot"
    echo "  2. Tmux: Open tmux, press Ctrl+A then I (install plugins)"
    echo "  3. Neovim: Run nvim (auto-install plugins)"
    echo ""
    echo "If something goes wrong:"
    echo "  - Check logs: ~/.dotfiles.install.log"
    echo "  - Restore backup: ~/.dotfiles.backup.*"
    echo "  - Report issue: https://github.com/NikitaVereev/dotfiles/issues"
}

main "$@"
