# 🚀 Dotfiles

Personal development environment configuration for Neovim, Tmux, Zsh, and Alacritty, managed with GNU Stow and Node via NVM.

---

## 📦 What's Inside

**Neovim** - Modern IDE with LSP support for TypeScript, Lua, Python, Go, C++, Solidity
**Tmux** - Terminal multiplexer with vim-like keybindings
**Zsh** - Shell configuration managed via GNU Stow
**Alacritty** - GPU-accelerated terminal

---

## 🚀 Installation

### Prerequisites

```bash
# Arch/Manjaro/EndeavourOS
sudo pacman -S git stow tmux neovim ripgrep base-devel zsh ttf-jetbrains-mono-nerd

# Ubuntu/Debian
sudo apt install git stow tmux neovim ripgrep build-essential zsh fonts-jetbrains-mono

# macOS
brew install git stow tmux neovim ripgrep zsh font-jetbrains-mono
```

### Setup

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Link each module
stow nvim
stow tmux
stow alacritty
stow zshrc
```

---
## Switch Shell to Zsh


## ⌨️ Key Bindings

### Neovim (Leader: `Space`)

- `<leader>e` - File explorer
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `gd` - Go to definition
- `K` - Hover documentation

### Tmux (Prefix: `Ctrl-a`)

- `Ctrl-a c` - New window
- `Ctrl-a h/j/k/l` - Navigate panes
- `Ctrl-a o` - Scratch pad popup

---

## 🔄 Updating

```bash
cd ~/dotfiles
git pull
```

---

## 📚 Features

### Neovim Plugins

- nvim-tree - File explorer
- fzf-lua - Fuzzy finder
- bufferline - Buffer tabs
- gitsigns - Git integration
- trouble - Diagnostics viewer
- nvim-cmp - Auto-completion
- treesitter - Syntax highlighting

### LSP Servers

TypeScript - Lua - Python - Go - C++ - Solidity - Bash - Docker - YAML - JSON

---

## 📁 Structure

```
dotfiles/
├── nvim/ # Neovim config
├── tmux/ # Tmux config
├── alacritty/ # Alacritty config
└── README.md
```


