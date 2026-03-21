#!/usr/bin/env bash
# =================================================================================================
# Dotfiles Installer - Professional Edition
# =================================================================================================
# Supports: Arch Linux, Debian/Ubuntu, Fedora/RHEL, macOS
# Features: Backup, package management, symlinks, post-install setup
# =================================================================================================

set -euo pipefail

# ── Colors ─────────────────────────────────────────────────────────────────────
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly NC='\033[0m' # No Color

# ── Logging ────────────────────────────────────────────────────────────────────
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
log_error()   { echo -e "${RED}[✗]${NC} $1"; }
log_step()    { echo -e "${CYAN}[STEP]${NC} $1"; }
log_debug()   { [[ "${DEBUG:-0}" == "1" ]] && echo -e "${MAGENTA}[DEBUG]${NC} $1" || :; }

# ── Configuration ──────────────────────────────────────────────────────────────
# Get dotfiles directory (works even if script is symlinked)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_DIR

# Backup directory with timestamp
BACKUP_DIR="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
readonly BACKUP_DIR

# Log file
readonly LOG_FILE="$HOME/.dotfiles.install.log"

# Detect OS
detect_os() {
    if [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/redhat-release ]] || [[ -f /etc/fedora-release ]]; then
        echo "fedora"
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Get OS (separate from readonly to avoid SC2155)
OS="$(detect_os)"
readonly OS

# ── Package Lists ──────────────────────────────────────────────────────────────

# pacman (Arch official repositories)
readonly PACMAN_PACKAGES=(
    # Hyprland
    hyprland hyprlock hyprpaper hyprshot
    # Bar & Notifications
    waybar swaync
    # Terminal
    kitty tmux
    # Shell
    zsh starship zoxide fzf fd ripgrep
    # Launcher
    rofi
    # File Manager
    yazi ffmpegthumbnailer thunar ranger
    # System
    fastfetch cliphist swww imagemagick
    # Fonts
    noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd ttf-font-awesome
    # Audio
    wireplumber pipewire pipewire-pulse pipewire-alsa pavucontrol
    # Network
    networkmanager network-manager-applet blueman
    # Utilities
    brightnessctl playerctl pamixer polkit-kde-agent
    # Zsh plugins
    zsh-autosuggestions zsh-syntax-highlighting
    # Development
    base-devel git cargo nodejs npm python python-pip go rust
    # Tools
    stow jq lazygit htop
)

# AUR packages (requires yay or paru)
readonly AUR_PACKAGES=(
    ghostty
    atuin
    wl-clip-persist
)

# Debian/Ubuntu packages
readonly DEB_PACKAGES=(
    git curl wget stow jq htop
    zsh tmux kitty
    fzf ripgrep fd-find
    starship zoxide
    rofi waybar swaync
    yazi ranger thunar
    fastfetch
    imagemagick
    pipewire pipewire-pulse wireplumber pavucontrol
    network-manager blueman
    brightnessctl playerctl pamixer
    fonts-noto fonts-noto-cjk fonts-noto-color-emoji
    build-essential nodejs npm python3 python3-pip golang-go cargo rustc
)

# Fedora packages
readonly FEDORA_PACKAGES=(
    git curl wget stow jq htop
    zsh tmux kitty
    fzf ripgrep fd-find
    starship zoxide
    rofi-wayland waybar swaync
    yazi ranger thunar
    fastfetch
    ImageMagick
    pipewire pipewire-pulse wireplumber pavucontrol
    NetworkManager blueman
    brightnessctl playerctl pamixer
    google-noto-fonts google-noto-cjk-fonts google-noto-color-emoji-fonts
    "@Development Tools" nodejs npm python3 python3-pip golang cargo rust
)

# macOS packages (Homebrew)
readonly MACOS_PACKAGES=(
    git curl wget stow jq htop
    zsh tmux kitty
    fzf ripgrep fd
    starship zoxide
    rofi
    yazi ranger
    fastfetch
    imagemagick
    node npm python3 go rust
)

# ── Helper Functions ───────────────────────────────────────────────────────────
command_exists() {
    command -v "$1" &> /dev/null
}

is_root() {
    [[ $EUID -eq 0 ]]
}

require_command() {
    local cmd="$1"
    if ! command_exists "$cmd"; then
        log_error "Required command not found: $cmd"
        return 1
    fi
}

# ── System Checks ──────────────────────────────────────────────────────────────
check_root() {
    if is_root; then
        log_error "Do not run as root!"
        exit 1
    fi
}

check_os_support() {
    log_info "Detected OS: $OS"
    
    case "$OS" in
        arch|debian|fedora|macos)
            log_success "OS supported"
            ;;
        *)
            log_warn "Unsupported OS: $OS"
            log_warn "Installation may fail. Continue at your own risk."
            read -rp "Continue anyway? (y/N): " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
            ;;
    esac
}

check_disk_space() {
    local required_mb=2000
    local available_mb
    
    available_mb=$(df -m "$HOME" | awk 'NR==2 {print $4}')
    
    if [[ $available_mb -lt $required_mb ]]; then
        log_error "Insufficient disk space. Required: ${required_mb}MB, Available: ${available_mb}MB"
        exit 1
    fi
    
    log_debug "Disk space OK: ${available_mb}MB available"
}

# ── Backup ─────────────────────────────────────────────────────────────────────
backup_existing() {
    log_step "Creating backup..."
    
    local items=(
        ".config/hypr"
        ".config/nvim"
        ".config/waybar"
        ".config/rofi"
        ".config/swaync"
        ".config/ghostty"
        ".config/kitty"
        ".config/tmux"
        ".config/starship"
        ".config/yazi"
        ".config/fastfetch"
        ".config/wireplumber"
        ".zshrc"
        ".tmux.conf"
    )
    
    mkdir -p "$BACKUP_DIR"
    local backed_up=0
    
    for item in "${items[@]}"; do
        if [[ -e "$HOME/$item" ]]; then
            if cp -r "$HOME/$item" "$BACKUP_DIR/$item" 2>/dev/null; then
                ((backed_up++))
            fi
        fi
    done
    
    if [[ $backed_up -gt 0 ]]; then
        log_success "Backed up $backed_up items to: $BACKUP_DIR"
    else
        log_info "No existing configs to backup"
    fi
}

# ── Package Installation ───────────────────────────────────────────────────────
install_pacman() {
    log_step "Installing packages via pacman..."
    
    # Update package database
    sudo pacman -Sy --noconfirm || {
        log_error "Failed to update pacman database"
        return 1
    }
    
    # Install packages
    sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}" || {
        log_error "Failed to install pacman packages"
        return 1
    }
    
    log_success "pacman packages installed"
}

install_aur() {
    log_step "Installing AUR packages..."
    
    # Detect AUR helper
    local aur_helper=""
    
    if command_exists yay; then
        aur_helper="yay"
    elif command_exists paru; then
        aur_helper="paru"
    else
        log_warn "No AUR helper found (yay or paru required)"
        log_info "Installing yay..."
        
        # Install yay if base-devel and git are available
        if command_exists git && command_exists make; then
            local tmp_dir
            tmp_dir=$(mktemp -d)
            git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
            (cd "$tmp_dir/yay" && makepkg -si --noconfirm)
            aur_helper="yay"
            rm -rf "$tmp_dir"
        else
            log_error "Cannot install AUR packages without yay/paru"
            return 1
        fi
    fi
    
    log_info "Using AUR helper: $aur_helper"
    
    # Install AUR packages
    $aur_helper -S --needed --noconfirm "${AUR_PACKAGES[@]}" || {
        log_error "Failed to install AUR packages"
        return 1
    }
    
    log_success "AUR packages installed"
}

install_deb() {
    log_step "Installing packages via apt..."
    
    sudo apt update || {
        log_error "Failed to update apt"
        return 1
    }
    
    sudo apt install -y "${DEB_PACKAGES[@]}" || {
        log_error "Failed to install packages"
        return 1
    }
    
    log_success "Debian/Ubuntu packages installed"
}

install_fedora() {
    log_step "Installing packages via dnf..."
    
    sudo dnf update -y || {
        log_error "Failed to update dnf"
        return 1
    }
    
    sudo dnf install -y "${FEDORA_PACKAGES[@]}" || {
        log_error "Failed to install packages"
        return 1
    }
    
    log_success "Fedora packages installed"
}

install_macos() {
    log_step "Installing packages via Homebrew..."
    
    if ! command_exists brew; then
        log_warn "Homebrew not installed"
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    brew update || {
        log_error "Failed to update Homebrew"
        return 1
    }
    
    brew install "${MACOS_PACKAGES[@]}" || {
        log_error "Failed to install packages"
        return 1
    }
    
    log_success "macOS packages installed"
}

install_packages() {
    case "$OS" in
        arch)
            install_pacman
            install_aur || log_warn "Some AUR packages may have failed"
            ;;
        debian)
            install_deb
            ;;
        fedora)
            install_fedora
            ;;
        macos)
            install_macos
            ;;
        *)
            log_error "Unknown OS, cannot install packages"
            return 1
            ;;
    esac
}

# ── External Installers ────────────────────────────────────────────────────────
install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Oh My Zsh already installed"
        return 0
    fi
    
    log_step "Installing Oh My Zsh..."
    
    # Install zsh if not present
    if ! command_exists zsh; then
        log_warn "Zsh not found, installing..."
        case "$OS" in
            arch) sudo pacman -S --noconfirm zsh ;;
            debian) sudo apt install -y zsh ;;
            fedora) sudo dnf install -y zsh ;;
            macos) brew install zsh ;;
        esac
    fi
    
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
        log_error "Failed to install Oh My Zsh"
        return 1
    }
    
    log_success "Oh My Zsh installed"
}

install_fzf() {
    if [[ -d "$HOME/.fzf" ]]; then
        log_info "FZF already installed"
        return 0
    fi
    
    # On Arch, fzf is in official repos
    if [[ "$OS" == "arch" ]] && pacman -Qq fzf &>/dev/null; then
        log_info "FZF installed via pacman"
        # Still need to run fzf installer for shell integration
        /usr/share/doc/fzf/key-bindings.zsh 2>/dev/null || true
        /usr/share/doc/fzf/completion.zsh 2>/dev/null || true
        return 0
    fi
    
    log_step "Installing FZF..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --unattended || {
        log_error "Failed to install FZF"
        return 1
    }
    
    log_success "FZF installed"
}

install_tmux_plugin_manager() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    
    if [[ -d "$tpm_dir" ]]; then
        log_info "TPM already installed"
        return 0
    fi
    
    log_step "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir" || {
        log_error "Failed to install TPM"
        return 1
    }
    
    log_success "TPM installed"
}

# ── Symlinks ───────────────────────────────────────────────────────────────────
create_symlinks() {
    log_step "Creating symlinks..."
    
    # Root level files
    local files=(".zshrc")
    
    # Directories in .config
    local dirs=(
        ".config/hypr"
        ".config/nvim"
        ".config/waybar"
        ".config/rofi"
        ".config/swaync"
        ".config/ghostty"
        ".config/kitty"
        ".config/tmux"
        ".config/starship"
        ".config/yazi"
        ".config/fastfetch"
        ".config/wireplumber"
    )
    
    local created=0
    
    # Create symlinks for files
    for file in "${files[@]}"; do
        if [[ -e "$DOTFILES_DIR/$file" ]]; then
            if [[ -L "$HOME/$file" ]]; then
                log_debug "Symlink exists: $file"
            elif [[ -e "$HOME/$file" ]]; then
                log_warn "File exists, skipping: $file"
            else
                ln -s "$DOTFILES_DIR/$file" "$HOME/$file"
                ((created++))
                log_debug "Created symlink: $file"
            fi
        fi
    done
    
    # Create symlinks for directories
    for dir in "${dirs[@]}"; do
        if [[ -d "$DOTFILES_DIR/$dir" ]]; then
            if [[ -L "$HOME/$dir" ]]; then
                log_debug "Symlink exists: $dir"
            elif [[ -d "$HOME/$dir" ]]; then
                log_warn "Directory exists, skipping: $dir"
            else
                ln -s "$DOTFILES_DIR/$dir" "$HOME/$dir"
                ((created++))
                log_debug "Created symlink: $dir"
            fi
        fi
    done
    
    log_success "Created $created symlinks"
}

# ── Neovim Setup ───────────────────────────────────────────────────────────────
setup_nvim() {
    log_step "Setting up Neovim..."
    
    # Create undo directory
    mkdir -p "$HOME/.local/share/nvim/undo"
    
    # Check if nvim is installed
    if ! command_exists nvim; then
        log_warn "Neovim not installed, skipping plugin setup"
        return 0
    fi
    
    # Install Lazy.nvim and sync plugins
    log_info "Installing Lazy.nvim plugins (this may take a while)..."
    
    NVIM_APPNAME=nvim nvim --headless "+Lazy! sync" +qa 2>&1 | tee -a "$LOG_FILE" || {
        log_warn "Neovim plugin installation had issues (can be fixed manually with :Lazy sync)"
    }
    
    log_success "Neovim setup complete"
}

# ── Default Theme Setup ────────────────────────────────────────────────────────
setup_default_theme() {
    log_step "Setting up default theme..."
    
    local theme="oxocarbon"
    local configs_created=0
    
    # Hyprland
    if [[ ! -f "$HOME/.config/hypr/themes/current.conf" ]]; then
        ln -s "$DOTFILES_DIR/.config/hypr/themes/${theme}.conf" "$HOME/.config/hypr/themes/current.conf"
        ((configs_created++))
    fi
    
    # Neovim
    if [[ ! -f "$HOME/.config/nvim/themes/current" ]]; then
        echo "$theme" > "$HOME/.config/nvim/themes/current"
        ((configs_created++))
    fi
    
    # Waybar
    if [[ ! -f "$HOME/.config/waybar/themes/current.css" ]]; then
        ln -s "$DOTFILES_DIR/.config/waybar/themes/${theme}.css" "$HOME/.config/waybar/themes/current.css"
        ((configs_created++))
    fi
    
    # Rofi
    if [[ ! -f "$HOME/.config/rofi/themes/current.rasi" ]]; then
        ln -s "$DOTFILES_DIR/.config/rofi/themes/${theme}.rasi" "$HOME/.config/rofi/themes/current.rasi"
        ((configs_created++))
    fi
    
    # SwayNC
    if [[ ! -f "$HOME/.config/swaync/themes/current.css" ]]; then
        ln -s "$DOTFILES_DIR/.config/swaync/themes/${theme}.css" "$HOME/.config/swaync/themes/current.css"
        ((configs_created++))
    fi
    
    # Starship
    if [[ ! -f "$HOME/.config/starship/themes/current.toml" ]]; then
        ln -s "$DOTFILES_DIR/.config/starship/themes/${theme}.toml" "$HOME/.config/starship/themes/current.toml"
        ((configs_created++))
    fi
    
    log_success "Default theme configured ($configs_created configs)"
}

# ── System Services ────────────────────────────────────────────────────────────
enable_services() {
    log_step "Enabling system services..."

    case "$OS" in
        arch|fedora|debian)
            # NetworkManager
            if systemctl list-unit-files 2>/dev/null | grep -q NetworkManager; then
                if sudo systemctl enable NetworkManager 2>/dev/null; then
                    log_success "NetworkManager enabled"
                fi
            fi

            # Bluetooth
            if systemctl list-unit-files 2>/dev/null | grep -q bluetooth; then
                if sudo systemctl enable bluetooth 2>/dev/null; then
                    log_success "Bluetooth enabled"
                fi
            fi

            # PipeWire (if available)
            if systemctl list-unit-files 2>/dev/null | grep -q pipewire; then
                sudo systemctl enable pipewire 2>/dev/null || true
            fi
            ;;
        macos)
            log_info "macOS services managed by launchd"
            ;;
        *)
            log_warn "Cannot enable services on unknown OS"
            ;;
    esac
}

# ── Post-Install Information ───────────────────────────────────────────────────
show_post_install() {
    cat << EOF

${GREEN}═══════════════════════════════════════════════════════════════${NC}
${WHITE}                          Installation Complete!${NC}
${GREEN}═══════════════════════════════════════════════════════════════${NC}

${CYAN}Next Steps:${NC}
  1. Reboot your system: ${YELLOW}sudo reboot${NC}
  2. Install Tmux plugins: Open tmux, then press ${YELLOW}Ctrl+A + I${NC}
  3. Launch Neovim to install plugins: ${YELLOW}nvim${NC}

${CYAN}Keybindings:${NC}
  • Hyprland:  ${YELLOW}Mod1+Enter${NC} (terminal), ${YELLOW}Mod1+Shift+T${NC} (theme switcher)
  • Neovim:    ${YELLOW}Space+e${NC} (explorer), ${YELLOW}Space+f${NC} (find file)
  • Tmux:      ${YELLOW}Ctrl+A${NC} (prefix)

${CYAN}Locations:${NC}
  • Backup:    ${YELLOW}$BACKUP_DIR${NC}
  • Log file:  ${YELLOW}$LOG_FILE${NC}
  • Dotfiles:  ${YELLOW}$DOTFILES_DIR${NC}

${WHITE}Enjoy your new configuration! 🎉${NC}

EOF
}

# ── Logging Setup ──────────────────────────────────────────────────────────────
setup_logging() {
    exec > >(tee -a "$LOG_FILE") 2>&1
    log_debug "Logging to $LOG_FILE"
}

# ── Main Function ──────────────────────────────────────────────────────────────
main() {
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           Dotfiles Installer - Professional Edition       ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log_info "OS: $OS | Dotfiles: $DOTFILES_DIR"
    echo ""
    
    # Interactive prompt
    read -rp "Continue with installation? (y/N): " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
    
    # Pre-installation checks
    check_root
    check_os_support
    check_disk_space
    setup_logging
    
    # Installation steps
    backup_existing
    install_packages || log_warn "Package installation had issues"
    install_oh_my_zsh
    install_fzf
    install_tmux_plugin_manager
    create_symlinks
    setup_nvim
    setup_default_theme
    enable_services
    
    # Post-installation
    show_post_install
    log_success "Installation completed successfully!"
}

# Run main function
main "$@"
