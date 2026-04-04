# Dotfiles

Hyprland (Wayland) dotfiles для Arch Linux.

## Установка

```bash
git clone https://github.com/NikitaVereev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Создать symlink'и (через GNU stow)
stow -t ~ .

# Или вручную:
# ln -s ~/.dotfiles/.zshrc ~/.zshrc
# ln -s ~/.dotfiles/.config/hypr ~/.config/hypr
# ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
# ... и т.д.
```

## Стек

| Компонент | Инструменты                        |
| --------- | ---------------------------------- |
| WM        | Hyprland, Hyprlock, Hyprpaper      |
| Панель    | Waybar                             |
| Терминал  | Kitty                              |
| Shell     | Zsh + Oh My Zsh + Starship + Atuin |
| Редактор  | Neovim (Lazy.nvim)                 |
| Лаунчер   | Rofi                               |
| Файловый  | Yazi, Thunar                       |
| Tmux      | TPM + Resurrect                    |

## Управление темами

Переключение: `Mod1 + Shift + T` (через Rofi)

Или вручную:

```bash
~/.dotfiles/scripts/theme-manager.py gruvbox
```

## Темы

5 тем: **oxocarbon** (default), catppuccin, everforest, kanagawa, bloodmoon

Переключение: `Mod1 + Shift + T`

## Горячие клавиши

### Hyprland (Mod1 = Win)

| Клавиши            | Действие      |
| ------------------ | ------------- |
| `Mod1 + Enter`     | Терминал      |
| `Mod1 + C`         | Закрыть окно  |
| `Mod1 + H/J/K/L`   | Навигация     |
| `Mod1 + 1-9`       | Рабочие столы |
| `Mod1 + Shift + T` | Смена темы    |

### Neovim (Leader = Space)

| Клавиши     | Действие    |
| ----------- | ----------- |
| `Space + e` | Проводник   |
| `Space + f` | Поиск файла |
| `Space + /` | Grep        |
| `Space + b` | Буферы      |
| `Space + g` | Git         |

### Tmux (Prefix = Ctrl+A)

| Клавиши            | Действие             |
| ------------------ | -------------------- |
| `Ctrl+A + \|`      | Вертикальный сплит   |
| `Ctrl+A + -`       | Горизонтальный сплит |
| `Ctrl+A + H/J/K/L` | Навигация            |
| `Ctrl+A + I`       | Плагины              |

## Структура

```
~/.dotfiles/
├── .gitignore
├── .editorconfig
├── .prettierrc
├── README.md
├── scripts/
│   ├── theme-manager.py        # Orchestrator
│   ├── theme-selector.sh       # Rofi → theme manager
│   ├── wallpaper-selector.sh   # Rofi → wallpaper apply
│   ├── check-themes.sh         # Verify theme state
│   └── theme_lib/              # Python library
│       ├── config.py           #   Paths + logging
│       ├── colors.py           #   Color utilities
│       ├── templates.py        #   Template engine
│       ├── gtk.py              #   GTK theme apply
│       ├── hot_reload.py       #   App signal handlers
│       └── wallpapers.py       #   gowall wrapper
├── themes/
│   ├── palettes/               # Color palettes (TOML)
│   └── templates/              # Jinja2-style templates (.j2)
└── .config/
    ├── hypr/           # Hyprland
    ├── nvim/           # Neovim
    ├── waybar/         # Waybar
    ├── rofi/           # Rofi
    ├── swaync/         # Уведомления
    ├── starship/       # Промпт
    ├── tmux/           # Tmux
    ├── kitty/          # Kitty
    ├── yazi/           # Yazi
    └── fastfetch/      # Fastfetch
```

## Post-Install

1. **Tmux плагины**: Откройте tmux, нажмите `Ctrl+A + I`
2. **Neovim плагины**: Запустите `nvim` (авто-установка)

## GTK-темы

GTK-темы устанавливаются вручную (скрипт не скачивает их автоматически).

### Установка

```bash
# Gruvbox - https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme
git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git ~/.themes/Gruvbox
cd ~/.themes/Gruvbox/themes
./install.sh

# Catppuccin - https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme
git clone https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme.git ~/.themes/Catppuccin
cd ~/.themes/Catppuccin/themes
./install.sh
```

После установки тема применится автоматически при переключении через `theme-manager.py`.
