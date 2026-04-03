"""Theme Library — shared modules for theme management."""

from theme_lib.colors import hex_to_rgb, flatten_colors
from theme_lib.templates import (
    render_template, write_config, create_symlink,
    load_palette, render_template_file, generate_named_theme_files,
    NAMED_THEME_FILES,
)
from theme_lib.config import DOTFILES_DIR, THEMES_DIR, PALETTES_DIR, TEMPLATES_DIR, CONFIG_DIR, HOME_DIR
from theme_lib.config import COLORS, log_info, log_ok, log_err, log_warn

__all__ = [
    "hex_to_rgb",
    "flatten_colors",
    "render_template",
    "write_config",
    "create_symlink",
    "load_palette",
    "render_template_file",
    "generate_named_theme_files",
    "NAMED_THEME_FILES",
    "DOTFILES_DIR", "THEMES_DIR", "PALETTES_DIR", "TEMPLATES_DIR",
    "CONFIG_DIR", "HOME_DIR",
    "COLORS", "log_info", "log_ok", "log_err", "log_warn",
]
