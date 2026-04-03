"""Global constants and logging helpers."""

from pathlib import Path

# ── Paths ──────────────────────────────────────────────────────────────────────

# Dotfiles root is the parent of scripts/
DOTFILES_DIR = Path(__file__).parent.parent.parent
THEMES_DIR = DOTFILES_DIR / "themes"
PALETTES_DIR = THEMES_DIR / "palettes"
TEMPLATES_DIR = THEMES_DIR / "templates"
CONFIG_DIR = DOTFILES_DIR / ".config"
HOME_DIR = Path.home()

# ── Terminal colors ───────────────────────────────────────────────────────────

COLORS = {
    "cyan": "\033[0;36m",
    "green": "\033[0;32m",
    "red": "\033[0;31m",
    "yellow": "\033[1;33m",
    "reset": "\033[0m",
}


def log_info(msg: str) -> None:
    print(f"{COLORS['cyan']}→{COLORS['reset']} {msg}")


def log_ok(msg: str) -> None:
    print(f"{COLORS['green']}✓{COLORS['reset']} {msg}")


def log_err(msg: str) -> None:
    print(f"{COLORS['red']}✗{COLORS['reset']} {msg}")


def log_warn(msg: str) -> None:
    print(f"{COLORS['yellow']}!{COLORS['reset']} {msg}")
