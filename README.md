# Dotfiles

Hyprland (Wayland) dotfiles для Arch Linux.

**Neovim-конфиг живёт отдельно** в репо [`nvim-config`](https://github.com/NikitaVereev/nvim-config)

## Установка

```bash
# 1. Клонировать main dotfiles
git clone https://github.com/NikitaVereev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Развернуть симлинки (shell, tmux, hyprland, waybar, kitty, ...)
stow -t ~ .

# 3. Подтянуть nvim-config и плагины (а также TPM)
./install.sh
```

`install.sh` сделает:

- `git clone nvim-config → ~/.config/nvim`
- `git clone TPM → ~/.tmux/plugins/tpm`
- `nvim --headless +Lazy! sync +qa` (bootstrap плагинов)

Потом внутри tmux: `<prefix> I` (Shift-I) — установит tmux-плагины.

## Только Neovim (без desktop-стека)

```bash
git clone https://github.com/NikitaVereev/nvim-config.git ~/.config/nvim
nvim
```

Дальше следуй `README.md` в самом `nvim-config` репо — там полный список системных deps (ripgrep, fd, lazygit, tree-sitter, ...).

## Стек

| Компонент | Инструменты                                                            |
| --------- | ---------------------------------------------------------------------- |
| WM        | Hyprland, Hyprlock, Hyprpaper                                          |
| Панель    | Waybar                                                                 |
| Терминал  | Kitty                                                                  |
| Shell     | Zsh + Oh My Zsh + Starship + Atuin                                     |
| Редактор  | [Neovim](https://github.com/NikitaVereev/nvim-config) (отдельный репо) |
| Лаунчер   | Rofi                                                                   |
| Файловый  | Yazi, Thunar                                                           |
| Tmux      | TPM + Resurrect                                                        |

## Управление темами

Переключение: `Mod1 + Shift + T` (через Rofi)

Или вручную:

```bash
~/.dotfiles/scripts/theme-manager.py gruvbox
```

## Темы

2 темы: **gruvbox** (default), catppuccin

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
├── install.sh                  # пост-stow bootstrap (клонирует nvim-config, TPM, плагины)
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

`./install.sh` делает большую часть. Что нужно вручную:

1. **Tmux плагины**: Откройте tmux, нажмите `Ctrl+A + I` (Shift-I)
2. **Mason tools** (форматтеры/линтеры): В nvim — `:MasonToolsInstall`
3. **Treesitter парсеры**: В nvim — `:TSUpdate`

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
