# Dotfiles

Personal Linux configuration for **Hyprland (Wayland)** on **Arch Linux**.

> **Note**: This configuration is optimized for Arch Linux but can be adapted for other distributions.

---

## 📚 Table of Contents

- [Stack](#-stack)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Structure](#-structure)
- [Themes](#-themes)
- [Keybindings](#-keybindings)
- [Neovim](#-neovim)
- [Scripts](#-scripts)
- [License](#-license)

---

## 🛠 Stack

| Category          | Tools                                       |
| ----------------- | ------------------------------------------- |
| **WM**            | Hyprland, Hyprlock, Hyprpaper               |
| **Bar**           | Waybar                                      |
| **Notifications** | SwayNC                                      |
| **Terminal**      | Ghostty, Kitty                              |
| **Shell**         | Zsh + Oh My Zsh + Starship + Atuin + Zoxide |
| **Editor**        | Neovim (Lazy.nvim)                          |
| **Launcher**      | Rofi                                        |
| **File Manager**  | Yazi, Thunar, Ranger                        |
| **Multiplexer**   | Tmux (TPM)                                  |
| **System Info**   | Fastfetch                                   |

---

## 📋 Requirements

### Package Sources

Packages are installed from different sources. Choose your installer accordingly:

#### 1. Official Arch Repositories (pacman)

```bash
# Hyprland
sudo pacman -S hyprland hyprlock hyprpaper hyprshot

# Bar & Notifications
sudo pacman -S waybar swaync

# Terminal Emulators
sudo pacman -S kitty tmux ghostty

# Shell & Utilities
sudo pacman -S zsh starship zoxide fzf fd ripgrep atuin

# Launcher
sudo pacman -S rofi

# File Managers
sudo pacman -S yazi ffmpegthumbnailer thunar ranger

# System Tools
sudo pacman -S fastfetch cliphist swww imagemagick wl-clip-persist

# Fonts
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd ttf-font-awesome

# Audio (PipeWire)
sudo pacman -S wireplumber pipewire pipewire-pulse pipewire-alsa pavucontrol

# Network & Bluetooth
sudo pacman -S networkmanager network-manager-applet blueman

# Utilities
sudo pacman -S brightnessctl playerctl pamixer polkit-kde-agent

# Zsh Plugins
sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting

# Development
sudo pacman -S base-devel git cargo nodejs npm python python-pip go rust

# Tools
sudo pacman -S stow jq lazygit htop
```

#### 2. External Installers (run during install.sh)

| Tool               | Method              | Description                 |
| ------------------ | ------------------- | --------------------------- |
| **Oh My Zsh**      | curl script         | Zsh framework               |
| **FZF**            | git clone + install | Fuzzy finder                |
| **TPM**            | git clone           | Tmux Plugin Manager         |
| **Neovim Plugins** | Lazy.nvim           | Auto-installed on first run |

---

## 🚀 Installation

### Quick Install (Recommended)

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installer
./install.sh
```

### Manual Install (GNU Stow)

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Create all symlinks
stow .

# Or create symlinks selectively
stow .zshrc
stow .config/hypr
stow .config/nvim
```

### Post-Installation Steps

1. **Reboot** to apply all changes:

   ```bash
   sudo reboot
   ```

2. **Install Neovim plugins** (automatic on first launch):

   ```bash
   nvim
   ```

3. **Install Tmux plugins** (inside tmux):

   ```
   Ctrl+A + I  (installs TPM plugins)
   ```

4. **Enable system services** (if not done by installer):
   ```bash
   sudo systemctl enable NetworkManager
   sudo systemctl enable bluetooth
   ```

---

## 📁 Structure

```
~/.dotfiles/
├── .config/
│   ├── hypr/           # Hyprland configuration
│   │   ├── modules/    # Modular configs (monitors, binds, etc.)
│   │   ├── scripts/    # Shell scripts (theme-switch, volume, etc.)
│   │   └── themes/     # Theme configurations (5 themes)
│   ├── nvim/           # Neovim (Lazy.nvim package manager)
│   │   ├── lua/
│   │   │   ├── config/
│   │   │   ├── plugins/
│   │   │   └── themes/
│   │   └── themes/
│   ├── waybar/         # Status bar
│   │   ├── scripts/
│   │   └── themes/
│   ├── rofi/           # Application launcher
│   │   └── themes/
│   ├── swaync/         # Notification center
│   │   └── themes/
│   ├── ghostty/        # Ghostty terminal config
│   │   └── themes/
│   ├── kitty/          # Kitty terminal config
│   ├── tmux/           # Tmux configuration
│   │   └── scripts/
│   ├── starship/       # Shell prompt
│   │   └── themes/
│   ├── yazi/           # Terminal file manager
│   ├── fastfetch/      # System information
│   └── wireplumber/    # Audio configuration
├── .zshrc              # Zsh configuration
├── install.sh          # Installation script
└── README.md
```

---

## 🎨 Themes

5 synchronized themes across all components:

| Theme         | Status    |
| ------------- | --------- |
| **oxocarbon** | Default   |
| catppuccin    | Available |
| everforest    | Available |
| kanagawa      | Available |
| bloodmoon     | Available |

### Switch Theme

- **Keyboard shortcut**: `Mod1 + Shift + T`
- **Preview**: Rofi-based picker with wallpaper thumbnails

---

## ⌨ Keybindings

### Hyprland (Mod1 = Win/Super)

| Keys                     | Action                   |
| ------------------------ | ------------------------ |
| `Mod1 + Enter`           | Open terminal            |
| `Mod1 + C`               | Close window             |
| `Mod1 + H/J/K/L`         | Navigate windows         |
| `Mod1 + Shift + H/J/K/L` | Move windows             |
| `Mod1 + 1-9`             | Switch workspaces        |
| `Mod1 + Space`           | Switch keyboard layout   |
| `Mod1 + Shift + T`       | Theme selector           |
| `Mod1 + A`               | Notification center      |
| `Mod1 + F12`             | Screenshot (full screen) |
| `Print`                  | Screenshot (region)      |
| `Mod1 + Shift + V`       | Clipboard manager        |
| `Alt + Tab`              | Previous workspace       |

### Neovim (Leader = Space)

| Keys             | Action              |
| ---------------- | ------------------- |
| `Space + e`      | Toggle explorer     |
| `Space + f`      | Find file           |
| `Space + /`      | Grep search         |
| `Space + b`      | Buffer list         |
| `Space + g`      | Git operations      |
| `Space + l`      | LSP actions         |
| `Space + d`      | Diagnostics         |
| `Space + q`      | Quit                |
| `K`              | Hover documentation |
| `Ctrl + H/J/K/L` | Window navigation   |

### Tmux (Prefix = Ctrl+A)

| Keys               | Action                |
| ------------------ | --------------------- |
| `Ctrl+A + \|`      | Vertical split        |
| `Ctrl+A + -`       | Horizontal split      |
| `Ctrl+A + H/J/K/L` | Pane navigation       |
| `Ctrl+A + W`       | Session menu          |
| `Ctrl+A + G`       | LazyGit popup         |
| `Ctrl+A + Tab`     | Scratch pad           |
| `Ctrl+A + I`       | Install plugins (TPM) |

---

## 📦 Neovim

**Plugin Manager**: [Lazy.nvim](https://github.com/folke/lazy.nvim)

Plugins are auto-installed on first launch.

### Supported Languages (LSP)

| Language              | LSP Server                  |
| --------------------- | --------------------------- |
| Lua                   | lua_ls                      |
| Go                    | gopls                       |
| Rust                  | rust-analyzer               |
| TypeScript/JavaScript | ts_ls                       |
| Python                | pyright                     |
| Bash                  | bashls                      |
| CSS/HTML/JSON/YAML    | cssls, html, jsonls, yamlls |
| Zig                   | zls                         |

### LSP Tools (via Mason)

- **Linters**: eslint_d, luacheck, golangci-lint, shellcheck, markdownlint, yamllint, jsonlint, htmlhint, stylelint, ruff, mypy
- **Formatters**: stylua, goimports, prettier, black, isort, shfmt

Install/update via `:Mason` in Neovim.

---

## 📜 Scripts

| Script                                  | Purpose                  |
| --------------------------------------- | ------------------------ |
| `install.sh`                            | Automated installation   |
| `.config/hypr/scripts/theme-select.sh`  | Theme selector (rofi)    |
| `.config/hypr/scripts/theme-switch.sh`  | Theme switcher logic     |
| `.config/hypr/scripts/layout-switch.sh` | Keyboard layout switcher |
| `.config/hypr/scripts/volume.sh`        | Volume control (pamixer) |
| `.config/waybar/scripts/launch.sh`      | Waybar launcher          |
| `.config/tmux/scripts/tmux-menu.sh`     | Tmux session menu        |
| `.config/tmux/scripts/tmux-scratch.sh`  | Tmux scratch pad         |

---

## 🔧 Troubleshooting

### Common Issues

1. **Themes not switching**: Ensure `current.conf` symlink exists in `~/.config/hypr/themes/`

2. **Neovim plugins not loading**: Run `:Lazy sync` inside Neovim

3. **Tmux plugins missing**: Press `Ctrl+A + I` inside tmux

4. **Waybar not showing**: Check if `gtk-layer-shell` is installed

5. **Fonts not rendering**: Run `fc-cache -fv` after font installation

### Logs

- Installation log: `~/.dotfiles.install.log`
- Backup location: `~/.dotfiles.backup.YYYYMMDD_HHMMSS`

---

## 📸 Screenshots

Coming soon...
