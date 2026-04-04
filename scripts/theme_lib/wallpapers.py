"""Wallpaper generation and application via gowall."""

import shutil
import subprocess

from theme_lib.config import DOTFILES_DIR, log_info, log_ok, log_warn

WALLPAPERS_DIR = DOTFILES_DIR / "wallpapers"
ORIGINALS_DIR = WALLPAPERS_DIR / "original"
GENERATED_DIR = WALLPAPERS_DIR / "generated"

# Map dotfile theme names → gowall built-in themes
GOWALL_THEME_MAP = {
    "gruvbox": "gruvbox",
    "catppuccin": "catppuccin",
    "everforest": "everforest",
    "kanagawa": "kanagawa",
    "oxocarbon": "material",
}

IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif"}


def _has_gowall() -> bool:
    return shutil.which("gowall") is not None


def generate_wallpapers(theme_name: str) -> int:
    """
    Generate theme-coloured wallpapers via gowall.

    Returns the number of wallpapers generated.
    """
    if not ORIGINALS_DIR.exists():
        log_warn(f"Wallpapers: Originals directory not found ({ORIGINALS_DIR})")
        return 0

    if not _has_gowall():
        log_warn("Wallpapers: gowall not found. Install with: yay -S gowall")
        return 0

    gowall_theme = GOWALL_THEME_MAP.get(theme_name, theme_name)
    theme_gen_dir = GENERATED_DIR / theme_name
    theme_gen_dir.mkdir(parents=True, exist_ok=True)

    log_info(f"Wallpapers: Generating for {theme_name}...")

    count = 0
    for img in ORIGINALS_DIR.rglob("*"):
        if img.suffix.lower() not in IMAGE_EXTENSIONS:
            continue

        output_name = f"{img.stem}_{theme_name}{img.suffix}"
        output_path = theme_gen_dir / output_name

        if output_path.exists() and img.stat().st_mtime < output_path.stat().st_mtime:
            continue

        try:
            subprocess.run(
                [
                    "gowall", "convert",
                    "--theme", gowall_theme,
                    "--output", str(output_path),
                    str(img),
                ],
                check=True, capture_output=True, timeout=60,
            )
            count += 1
            log_ok(f"  Generated: {output_name}")
        except subprocess.CalledProcessError as e:
            stderr = e.stderr.decode().strip() if e.stderr else "unknown error"
            log_warn(f"  Failed: {img.name} ({stderr})")
        except subprocess.TimeoutExpired:
            log_warn(f"  Timeout: {img.name}")
        except Exception as e:
            log_warn(f"  Error: {img.name} ({e})")

    if count > 0:
        log_ok(f"Wallpapers: {count} generated for {theme_name}")
    else:
        log_info(f"Wallpapers: No new wallpapers to generate for {theme_name}")

    # Apply current wallpaper with the new theme
    apply_current_wallpaper(theme_name)

    return count


def apply_current_wallpaper(theme_name: str) -> None:
    """Apply the saved wallpaper for the given theme."""
    script = DOTFILES_DIR / "scripts" / "wallpaper-selector.sh"
    if not script.exists():
        log_warn("Wallpapers: wallpaper-selector.sh not found")
        return
    try:
        subprocess.run(
            [str(script), "--apply-current"],
            check=True, capture_output=True, timeout=10,
        )
    except Exception:
        pass  # non-critical
