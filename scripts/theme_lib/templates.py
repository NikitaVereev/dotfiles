"""Template rendering for config files."""

import re
from pathlib import Path

try:
    import tomllib
except ImportError:
    import tomli as tomllib  # pip install tomli (Python < 3.11)

from theme_lib.config import PALETTES_DIR, TEMPLATES_DIR, DOTFILES_DIR, CONFIG_DIR


def render_template(template_content: str, context: dict) -> str:
    """Simple template renderer supporting {{ variable }} syntax."""
    result = template_content
    for key, value in context.items():
        result = result.replace(f"{{{{ {key} }}}}", str(value))
    return result


def write_config(output_path: Path, content: str) -> None:
    """Write generated config to file with validation."""
    output_path.parent.mkdir(parents=True, exist_ok=True)

    if output_path.suffix == ".css":
        rgba_pattern = r'rgba\(([0-9a-fA-F]{6})\s*,'
        matches = re.findall(rgba_pattern, content)
        if matches:
            raise ValueError(f"Invalid rgba() format in CSS: rgba({matches[0]},...) - missing #")

    with open(output_path, "w") as f:
        f.write(content)


def create_symlink(theme_name: str) -> None:
    """Create symlink for current theme palette."""
    current_link = PALETTES_DIR / "current.toml"
    if current_link.is_symlink() or current_link.exists():
        current_link.unlink()
    current_link.symlink_to(f"{theme_name}.toml")


def load_palette(theme_name: str) -> dict:
    """Load palette from TOML file."""
    palette_file = PALETTES_DIR / f"{theme_name}.toml"
    if not palette_file.exists():
        raise FileNotFoundError(f"Palette not found: {palette_file}")
    with open(palette_file, "rb") as f:
        return tomllib.load(f)


def render_template_file(template_name: str, context: dict) -> str:
    """Read template file and render it with given context."""
    template_file = TEMPLATES_DIR / template_name
    if not template_file.exists():
        raise FileNotFoundError(f"Template not found: {template_file}")
    with open(template_file, "r") as f:
        return f.read()


# Named theme files that are generated alongside current.* symlinks
NAMED_THEME_FILES = {
    "hypr": ("conf", "hyprland.conf.j2"),
    "waybar": ("css", "waybar.css.j2"),
    "kitty": ("conf", "kitty.conf.j2"),
    "swaync": ("css", "swaync.css.j2"),
    "swayosd": ("css", "swayosd.css.j2"),
    "starship": ("toml", "starship.toml.j2"),
    "rofi": ("rasi", "rofi.rasi.j2"),
    "tmux": ("conf", "tmux.conf.j2"),
    "yazi": ("toml", "yazi.toml.j2"),
}


def generate_named_theme_files(theme_name: str, context: dict) -> None:
    """Generate named theme files for apps that use symlinks."""
    for app, (ext, template) in NAMED_THEME_FILES.items():
        content = render_template(render_template_file(template, context), context)
        output_path = DOTFILES_DIR / ".config" / app / "themes" / f"{theme_name}.{ext}"
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(content)
