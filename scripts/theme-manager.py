#!/usr/bin/env python3
# ═══════════════════════════════════════════════════════════════════════════════
# Theme Manager - Централизованная Система Управления Темами
# Генерирует конфиги и применяет темы динамически без перезапуска приложений
# Usage: theme-manager.py <theme-name>
# ═══════════════════════════════════════════════════════════════════════════════

import tomllib
import subprocess
import sys
import re
from pathlib import Path
from datetime import datetime

# ═══════════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════════

DOTFILES_DIR = Path(__file__).parent.parent
THEMES_DIR = DOTFILES_DIR / "themes"
PALETTES_DIR = THEMES_DIR / "palettes"
TEMPLATES_DIR = THEMES_DIR / "templates"
CONFIG_DIR = DOTFILES_DIR / ".config"
HOME_DIR = Path.home()

# Mapping of template files to their output locations
# For some apps we write to named files (gruvbox.*), for others to current.*
TEMPLATE_MAPPING = {
    "hyprland.conf.j2": ".config/hypr/themes/current.conf",
    "waybar.css.j2": ".config/waybar/themes/current.css",  # symlink handles this
    "kitty.conf.j2": ".config/kitty/themes/current.conf",  # symlink handles this
    "rofi.rasi.j2": ".config/rofi/themes/current.rasi",
    "swaync.css.j2": ".config/swaync/themes/current.css",  # symlink handles this
    "starship.toml.j2": ".config/starship/themes/current.toml",  # symlink handles this
    "tmux.conf.j2": ".config/tmux/themes/current.conf",
    "yazi.toml.j2": ".config/yazi/themes/current.toml",
}

# Apps that need named theme files (not current.*)
NAMED_THEME_FILES = {
    "nvim": {"lua": "gruvbox.lua"},
    "waybar": {"css": "gruvbox.css"},
    "kitty": {"conf": "gruvbox.conf"},
    "swaync": {"css": "gruvbox.css"},
    "starship": {"toml": "gruvbox.toml"},
}

# Colors for terminal output
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


# ═══════════════════════════════════════════════════════════════════════════════
# Color Conversion
# ═══════════════════════════════════════════════════════════════════════════════


def hex_to_rgb(hex_color: str) -> tuple:
    """Convert hex color (#RRGGBB or RRGGBB) to RGB tuple."""
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))


def flatten_colors(palette: dict) -> dict:
    """Flatten nested color structure for template substitution."""
    flat = {}

    # Meta information
    if "meta" in palette:
        for key, value in palette["meta"].items():
            flat[f"meta.{key}"] = value

    # Add generation timestamp
    flat["generated_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Colors
    if "colors" in palette:
        for category, colors in palette["colors"].items():
            for name, value in colors.items():
                # Remove # from hex values for rgba conversion
                hex_value = value.replace("#", "")
                flat[f"{category}.{name}"] = hex_value
                flat[f"{category}_{name}"] = hex_value

                # Also provide RGB values for CSS rgba()
                rgb = hex_to_rgb(value)
                flat[f"{category}.{name}.rgb"] = f"{rgb[0]}, {rgb[1]}, {rgb[2]}"
                flat[f"{category}_{name}_rgb"] = f"{rgb[0]}, {rgb[1]}, {rgb[2]}"

    return flat


# ═══════════════════════════════════════════════════════════════════════════════
# Template Engine
# ═══════════════════════════════════════════════════════════════════════════════


def render_template(template_content: str, context: dict) -> str:
    """Simple template renderer supporting {{ variable }} syntax."""
    result = template_content
    for key, value in context.items():
        result = result.replace(f"{{{{ {key} }}}}", value)
    return result


def write_config(output_path: Path, content: str) -> None:
    """Write generated config to file with validation."""
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # Validate CSS files for common errors
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


# ═══════════════════════════════════════════════════════════════════════════════
# GTK Theme Management
# ═══════════════════════════════════════════════════════════════════════════════


def install_gtk_theme(theme_name: str) -> bool:
    """Install GTK theme for the selected theme."""
    
    gtk_themes = {
        "gruvbox": {
            "name": "Gruvbox-Dark",
            "url": "https://github.com/jakeworthington/gruvbox-gtk-theme/archive/refs/heads/main.tar.gz",
            "extract_dir": "gruvbox-gtk-theme-main",
        }
    }

    if theme_name not in gtk_themes:
        return False

    theme_info = gtk_themes[theme_name]
    themes_dir = HOME_DIR / ".themes"
    theme_path = themes_dir / theme_info["name"]

    if theme_path.exists():
        return True

    themes_dir.mkdir(parents=True, exist_ok=True)

    import tempfile
    import tarfile
    import urllib.request

    with tempfile.TemporaryDirectory() as tmpdir:
        tar_path = Path(tmpdir) / f"{theme_name}.tar.gz"
        extract_path = Path(tmpdir) / "extract"

        try:
            urllib.request.urlretrieve(theme_info["url"], tar_path)
            with tarfile.open(tar_path, "r:gz") as tar:
                tar.extractall(extract_path)

            source_dir = extract_path / theme_info["extract_dir"]
            if source_dir.exists():
                subprocess.run(["mv", str(source_dir), str(theme_path)], check=True, capture_output=True)
                return True
        except Exception:
            pass
    
    return False


def apply_gtk_settings(theme_name: str) -> None:
    """Apply GTK theme via gsettings and config files."""
    
    gtk_theme_names = {
        "gruvbox": "Gruvbox-Dark",
        "catppuccin": "Catppuccin-Mocha-Dark",
    }
    
    theme_display_name = gtk_theme_names.get(theme_name, theme_name.title())
    
    # 1. Try gsettings (GNOME/GTK3/GTK4)
    try:
        subprocess.run(
            ["gsettings", "set", "org.gnome.desktop.interface", "gtk-theme", theme_display_name],
            check=True, capture_output=True
        )
        log_ok("GTK: Theme applied via gsettings")
    except subprocess.CalledProcessError:
        log_warn(f"GTK: Theme '{theme_display_name}' not found in system")
        return
    except FileNotFoundError:
        pass

    # 2. Create GTK 3.0 config
    gtk3_dir = HOME_DIR / ".config" / "gtk-3.0"
    gtk3_dir.mkdir(parents=True, exist_ok=True)
    
    gtk3_config = gtk3_dir / "settings.ini"
    gtk3_config.write_text(f"""[Settings]
gtk-theme-name={theme_display_name}
gtk-application-prefer-dark-theme=1
""")
    log_ok("GTK 3.0: Config created")

    # 3. Create GTK 4.0 config
    gtk4_dir = HOME_DIR / ".config" / "gtk-4.0"
    gtk4_dir.mkdir(parents=True, exist_ok=True)
    
    gtk4_config = gtk4_dir / "settings.ini"
    gtk4_config.write_text(f"""[Settings]
gtk-theme-name={theme_display_name}
gtk-application-prefer-dark-theme=1
""")
    log_ok("GTK 4.0: Config created")

    # 4. Create Xresources for legacy apps
    xresources = HOME_DIR / ".Xresources"
    try:
        if xresources.exists():
            content = xresources.read_text()
            # Remove old theme lines
            lines = [l for l in content.split('\n') if not l.startswith('*background') 
                     and not l.startswith('*foreground') and not l.startswith('*.background')
                     and not l.startswith('*.foreground')]
            content = '\n'.join(lines) + '\n'
        else:
            content = ""
        
        # Add new theme
        palette = load_palette(theme_name)
        colors = palette['colors']
        content += f"""
! Gruvbox Theme
*background: #{colors['base']['bg0'].replace('#', '')}
*foreground: #{colors['base']['fg1'].replace('#', '')}
*.background: #{colors['base']['bg0'].replace('#', '')}
*.foreground: #{colors['base']['fg1'].replace('#', '')}
"""
        xresources.write_text(content)
        
        # Apply Xresources
        subprocess.run(["xrdb", "-merge", str(xresources)], check=True, capture_output=True)
        log_ok("Xresources: Applied")
    except Exception as e:
        log_warn(f"Xresources: {e}")


# ═══════════════════════════════════════════════════════════════════════════════
# Dynamic Theme Application (Hot Reload)
# ═══════════════════════════════════════════════════════════════════════════════


def apply_hyprland() -> bool:
    """Reload Hyprland configuration."""
    try:
        subprocess.run(["hyprctl", "reload"], check=True, capture_output=True)
        return True
    except Exception:
        return False


def apply_waybar() -> bool:
    """Reload Waybar configuration."""
    try:
        # Try waybar-msg first (doesn't restart)
        result = subprocess.run(["waybar-msg", "cmd", "reload"], capture_output=True)
        if result.returncode == 0:
            return True
    except FileNotFoundError:
        pass
    
    # Fallback: restart waybar
    try:
        subprocess.run(["pkill", "-SIGUSR2", "waybar"], check=True, capture_output=True)
        return True
    except Exception:
        return False


def apply_kitty(theme_name: str) -> bool:
    """Apply Kitty theme dynamically using remote control."""
    kitty_theme = CONFIG_DIR / "kitty" / "themes" / f"{theme_name}.conf"
    
    if not kitty_theme.exists():
        return False
    
    try:
        # Use kitty remote control to apply colors
        subprocess.run(
            ["kitty", "@", "set-colors", str(kitty_theme)],
            check=True, capture_output=True, timeout=5
        )
        return True
    except Exception:
        return False


def apply_nvim(theme_name: str) -> bool:
    """Notify Neovim to reload theme via SIGUSR1 and set vim.g.colors_name."""
    try:
        # Find nvim processes and send SIGUSR1
        result = subprocess.run(["pgrep", "-x", "nvim"], capture_output=True, text=True)
        if result.stdout.strip():
            pids = result.stdout.strip().split('\n')
            for pid in pids:
                subprocess.run(["kill", "-USR1", pid], check=True, capture_output=True)
            return True
    except Exception:
        pass
    return False


def set_nvim_theme(theme_name: str) -> None:
    """Set vim.g.colors_name for Neovim theme switching."""
    # Create a file that Neovim can read to get the theme name
    theme_file = HOME_DIR / ".config" / "nvim" / "themes" / "current_theme"
    theme_file.parent.mkdir(parents=True, exist_ok=True)
    theme_file.write_text(theme_name)


def apply_swaync() -> bool:
    """Reload SwayNC CSS."""
    try:
        subprocess.run(["swaync-client", "--reload-css"], check=True, capture_output=True)
        return True
    except Exception:
        return False


def apply_tmux() -> bool:
    """Reload Tmux configuration."""
    tmux_theme = CONFIG_DIR / "tmux" / "themes" / "current.conf"
    
    if not tmux_theme.exists():
        return False
    
    try:
        # Source tmux config (works without restarting session)
        subprocess.run(
            ["tmux", "source-file", str(tmux_theme)],
            check=True, capture_output=True
        )
        return True
    except Exception:
        return False


def apply_all_dynamic(theme_name: str) -> dict:
    """Apply theme to all applications dynamically."""
    results = {}
    
    log_info("Applying themes dynamically...")
    
    # Hyprland
    if apply_hyprland():
        results["hyprland"] = True
        log_ok("Hyprland: Reloaded")
    else:
        results["hyprland"] = False
    
    # Waybar - use SIGUSR2 for reload without restart
    if apply_waybar():
        results["waybar"] = True
        log_ok("Waybar: Reloaded")
    else:
        results["waybar"] = False
    
    # Kitty - send SIGUSR1 to reload config
    try:
        result = subprocess.run(["pgrep", "-x", "kitty"], capture_output=True, text=True)
        if result.stdout.strip():
            pids = result.stdout.strip().split('\n')
            for pid in pids:
                subprocess.run(["kill", "-USR1", pid], check=True, capture_output=True)
            results["kitty"] = True
            log_ok("Kitty: Config reloaded (SIGUSR1)")
        else:
            results["kitty"] = False
    except Exception:
        results["kitty"] = False
    
    # Neovim - theme is applied via plugin (gruvbox-material)
    # No dynamic reload needed, theme will be applied on next Neovim start
    results["nvim"] = False  # Plugin handles this
    
    # SwayNC
    if apply_swaync():
        results["swaync"] = True
        log_ok("SwayNC: CSS reloaded")
    else:
        results["swaync"] = False
    
    # Tmux - source config if session exists
    try:
        result = subprocess.run(["tmux", "has-session"], capture_output=True)
        if result.returncode == 0:
            tmux_theme = CONFIG_DIR / "tmux" / "themes" / "current.conf"
            if tmux_theme.exists():
                subprocess.run(
                    ["tmux", "source-file", str(tmux_theme)],
                    check=True, capture_output=True
                )
                results["tmux"] = True
                log_ok("Tmux: Config sourced")
            else:
                results["tmux"] = False
        else:
            results["tmux"] = False
    except Exception:
        results["tmux"] = False
    
    # Rofi - no hot reload, but theme file is updated
    results["rofi"] = False  # Will apply on next launch
    
    # Starship - auto-applies on next shell
    results["starship"] = True  # Uses symlink, auto-applies
    
    # Yazi - no hot reload
    results["yazi"] = False  # Will apply on next launch
    
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# Create Symlinks
# ═══════════════════════════════════════════════════════════════════════════════


def create_application_symlinks(theme_name: str) -> None:
    """Create symlinks for all applications."""
    
    symlink_mappings = {
        "gruvbox": {
            "hypr": ("conf", "gruvbox.conf"),
            "waybar": ("css", "gruvbox.css"),
            "kitty": ("conf", "gruvbox.conf"),
            "swaync": ("css", "gruvbox.css"),
            "starship": ("toml", "gruvbox.toml"),
            "rofi": ("rasi", "gruvbox.rasi"),
            "tmux": ("conf", "gruvbox.conf"),
            "yazi": ("toml", "gruvbox.toml"),
            # nvim uses plugin theme (ellisonleao/gruvbox.nvim)
        }
    }
    
    if theme_name not in symlink_mappings:
        return
    
    mappings = symlink_mappings[theme_name]
    config_base = HOME_DIR / ".config"
    
    for app, (ext, target) in mappings.items():
        symlink = config_base / app / "themes" / f"current.{ext}"
        
        if symlink.exists() or symlink.is_symlink():
            symlink.unlink()
        symlink.symlink_to(target)
        log_ok(f"{app}: symlink → {target}")


# ═══════════════════════════════════════════════════════════════════════════════
# Main Functions
# ═══════════════════════════════════════════════════════════════════════════════


def load_palette(theme_name: str) -> dict:
    """Load palette from TOML file."""
    palette_file = PALETTES_DIR / f"{theme_name}.toml"
    if not palette_file.exists():
        raise FileNotFoundError(f"Palette not found: {palette_file}")
    with open(palette_file, "rb") as f:
        return tomllib.load(f)


def generate_config(template_name: str, context: dict) -> str:
    """Generate config file from template."""
    template_file = TEMPLATES_DIR / template_name
    if not template_file.exists():
        raise FileNotFoundError(f"Template not found: {template_file}")
    with open(template_file, "r") as f:
        return f.read()


def generate_named_theme_files(theme_name: str, context: dict) -> None:
    """Generate named theme files for apps that use symlinks."""
    
    named_files = {
        "hypr": ("conf", "gruvbox.conf", "hyprland.conf.j2"),
        "waybar": ("css", "gruvbox.css", "waybar.css.j2"),
        "kitty": ("conf", "gruvbox.conf", "kitty.conf.j2"),
        "swaync": ("css", "gruvbox.css", "swaync.css.j2"),
        "starship": ("toml", "gruvbox.toml", "starship.toml.j2"),
        "rofi": ("rasi", "gruvbox.rasi", "rofi.rasi.j2"),
        "tmux": ("conf", "gruvbox.conf", "tmux.conf.j2"),
        "yazi": ("toml", "gruvbox.toml", "yazi.toml.j2"),
        # nvim uses plugin theme (ellisonleao/gruvbox.nvim)
    }
    
    for app, (ext, filename, template) in named_files.items():
        content = render_template(generate_config(template, context), context)
        output_path = DOTFILES_DIR / ".config" / app / "themes" / filename
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(content)


def main() -> int:
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <theme-name>")
        print("")
        print("Available themes:")
        for palette_file in PALETTES_DIR.glob("*.toml"):
            if palette_file.name != "current.toml":
                print(f"  - {palette_file.stem}")
        return 1

    theme_name = sys.argv[1]

    print(f"{COLORS['cyan']}╔════════════════════════════════════════════╗{COLORS['reset']}")
    print(f"{COLORS['cyan']}║     Theme Manager - Dynamic Theme Apply    ║{COLORS['reset']}")
    print(f"{COLORS['cyan']}╚════════════════════════════════════════════╝{COLORS['reset']}")
    print()

    try:
        # Load palette
        log_info(f"Loading palette: {theme_name}")
        palette = load_palette(theme_name)
        context = flatten_colors(palette)
        log_ok(f"Loaded {palette['meta']['name']}")

        # Generate configs
        print()
        log_info("Generating configuration files...")

        generated_count = 0
        for template_name, output_relative in TEMPLATE_MAPPING.items():
            output_path = DOTFILES_DIR / output_relative
            try:
                content = generate_config(template_name, context)
                write_config(output_path, content)
                log_ok(f"{output_relative}")
                generated_count += 1
            except Exception as e:
                log_err(f"Failed: {e}")

        # Create palette symlink
        print()
        create_symlink(theme_name)
        log_ok(f"Palette symlink: current.toml → {theme_name}.toml")

        # Generate named theme files (gruvbox.css, gruvbox.conf, etc.)
        print()
        log_info("Generating named theme files...")
        generate_named_theme_files(theme_name, context)
        log_ok("Named theme files created (gruvbox.*)")

        # Create application symlinks
        print()
        create_application_symlinks(theme_name)

        # Install and apply GTK theme
        print()
        log_info("GTK: Installing and applying theme...")
        install_gtk_theme(theme_name)
        apply_gtk_settings(theme_name)

        # Set Neovim theme name
        print()
        log_info("Neovim: Setting theme name...")
        set_nvim_theme(theme_name)
        log_ok(f"Neovim: vim.g.colors_name = {theme_name}")

        # Apply themes dynamically to running applications
        print()
        log_info("Dynamic theme application...")
        results = apply_all_dynamic(theme_name)

        # Summary
        print()
        print(f"{COLORS['green']}════════════════════════════════════════{COLORS['reset']}")
        print(f"  {COLORS['green']}Generated{COLORS['reset']}: {generated_count} configs")
        
        applied = sum(1 for v in results.values() if v)
        total = len(results)
        print(f"  {COLORS['green']}Applied{COLORS['reset']}:   {applied}/{total} apps (dynamic)")
        
        if applied < total:
            failed = [k for k, v in results.items() if not v]
            print(f"  {COLORS['yellow']}Skipped{COLORS['reset']}:  {', '.join(failed)}")
        
        print(f"{COLORS['green']}════════════════════════════════════════{COLORS['reset']}")
        print()
        log_ok("Theme applied successfully!")
        print()
        print("Note: Theme applied dynamically - no restart needed!")

        return 0

    except FileNotFoundError as e:
        log_err(str(e))
        return 1
    except Exception as e:
        log_err(f"Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
