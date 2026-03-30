# Dotfiles

Hyprland (Wayland) dotfiles для Arch Linux.

## Установка

```bash
git clone https://github.com/NikitaVereev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
sudo reboot
```

## Стек

| Компонент | Инструменты |
|-----------|-------------|
| WM | Hyprland, Hyprlock, Hyprpaper |
| Панель | Waybar |
| Терминал | Kitty |
| Shell | Zsh + Oh My Zsh + Starship + Atuin |
| Редактор | Neovim (Lazy.nvim) |
| Лаунчер | Rofi |
| Файловый | Yazi, Thunar |
| Tmux | TPM + Resurrect |

## Управление

```bash
make help      # Помощь
make install   # Создать symlink
make sync      # Update + install
make lint      # Проверка кода
```

## Темы

5 тем: **oxocarbon** (default), catppuccin, everforest, kanagawa, bloodmoon

Переключение: `Mod1 + Shift + T`

## Горячие клавиши

### Hyprland (Mod1 = Win)

| Клавиши | Действие |
|---------|----------|
| `Mod1 + Enter` | Терминал |
| `Mod1 + C` | Закрыть окно |
| `Mod1 + H/J/K/L` | Навигация |
| `Mod1 + 1-9` | Рабочие столы |
| `Mod1 + Shift + T` | Смена темы |

### Neovim (Leader = Space)

| Клавиши | Действие |
|---------|----------|
| `Space + e` | Проводник |
| `Space + f` | Поиск файла |
| `Space + /` | Grep |
| `Space + b` | Буферы |
| `Space + g` | Git |

### Tmux (Prefix = Ctrl+A)

| Клавиши | Действие |
|---------|----------|
| `Ctrl+A + \|` | Вертикальный сплит |
| `Ctrl+A + -` | Горизонтальный сплит |
| `Ctrl+A + H/J/K/L` | Навигация |
| `Ctrl+A + I` | Плагины |

## Структура

```
~/.dotfiles/
├── install.sh          # Установщик
├── Makefile            # Управление
├── scripts/
│   └── pre-commit-check.sh  # Проверки
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
