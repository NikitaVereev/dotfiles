# 🚀 Dotfiles

Personal development environment configuration for Neovim, Tmux, and Alacritty.

---

## 📦 What's Inside

**Neovim** - Modern IDE with LSP support for TypeScript, Lua, Python, Go, C++, Solidity
**Tmux** - Terminal multiplexer with vim-like keybindings
**Alacritty** - GPU-accelerated terminal

---

## 🚀 Installation

### Prerequisites

```bash
# Arch/Manjaro/EndeavourOS
sudo pacman -S git nodejs npm ripgrep tmux neovim base-devel

# Ubuntu/Debian
sudo apt install git nodejs npm ripgrep tmux neovim

# macOS
brew install git node ripgrep tmux neovim
```

### Setup

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/tmux ~/.config/tmux
ln -sf ~/dotfiles/alacritty ~/.config/alacritty
nvim
```

---

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


