"""Theme Library — shared modules for theme management."""

from theme_lib.colors import hex_to_rgb, flatten_colors
from theme_lib.templates import (
    render_template, write_config, create_symlink,
    load_palette, render_template_file, generate_named_theme_files,
    NAMED_THEME_FILES,
)
from theme_lib.hot_reload import (
    apply_hyprland, apply_waybar,
    apply_nvim, set_nvim_theme, apply_swaync, apply_swayosd, apply_tmux,
    reload_all,
)
from theme_lib.gtk import apply_gtk_settings
from theme_lib.wallpapers import generate_wallpapers, apply_current_wallpaper
from theme_lib.config import DOTFILES_DIR, THEMES_DIR, PALETTES_DIR, TEMPLATES_DIR, CONFIG_DIR, HOME_DIR
from theme_lib.config import COLORS, log_info, log_ok, log_err, log_warn

__all__ = [
    # Colors
    "hex_to_rgb",
    "flatten_colors",
    # Templates
    "render_template",
    "write_config",
    "create_symlink",
    "load_palette",
    "render_template_file",
    "generate_named_theme_files",
    "NAMED_THEME_FILES",
    # Hot-reload
    "apply_hyprland", "apply_waybar",
    "apply_nvim", "set_nvim_theme", "apply_swaync", "apply_swayosd", "apply_tmux",
    "reload_all",
    # GTK
    "apply_gtk_settings",
    # Wallpapers
    "generate_wallpapers",
    "apply_current_wallpaper",
    # Config
    "DOTFILES_DIR", "THEMES_DIR", "PALETTES_DIR", "TEMPLATES_DIR",
    "CONFIG_DIR", "HOME_DIR",
    "COLORS", "log_info", "log_ok", "log_err", "log_warn",
]
