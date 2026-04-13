"""GTK theme application — gsettings, config files, Xresources."""

import subprocess

from theme_lib.config import HOME_DIR, log_info, log_ok, log_warn, log_err

# GTK apps to restart after theme change (Arch Linux)
GTK_APPS = ["nwg-look", "nwg-drawer", "thunar"]


def apply_gtk_settings(theme_name: str, palette: dict) -> None:
    """Apply GTK theme via gsettings, config files, and Xresources."""

    theme_display_name = theme_name.title() + "-Dark"

    # ── gsettings (GNOME/GTK3/GTK4) ─────────────────────────────────────
    try:
        subprocess.run(
            ["gsettings", "set", "org.gnome.desktop.interface", "gtk-theme", theme_display_name],
            check=True, capture_output=True,
        )
        log_ok("GTK: Theme applied via gsettings")

        log_info("GTK: Restarting applications...")
        for app in GTK_APPS:
            try:
                subprocess.run(["pkill", "-HUP", app], capture_output=True, timeout=2)
            except Exception:
                pass
        log_ok("GTK: Applications restarted")

    except subprocess.CalledProcessError:
        log_warn(f"GTK: Theme '{theme_display_name}' not found. Install via AUR (e.g., adw-gtk3, gruvbox-gtk-theme)")
        return
    except FileNotFoundError:
        log_warn("GTK: gsettings not found. Install: pacman -S glib2")
        return

    # ── GTK 3.0 config ──────────────────────────────────────────────────
    gtk3_dir = HOME_DIR / ".config" / "gtk-3.0"
    gtk3_dir.mkdir(parents=True, exist_ok=True)
    (gtk3_dir / "settings.ini").write_text(
        f"[Settings]\ngtk-theme-name={theme_display_name}\n"
        f"gtk-application-prefer-dark-theme=1\n"
    )
    log_ok("GTK 3.0: Config created")

    # ── GTK 4.0 config ──────────────────────────────────────────────────
    gtk4_dir = HOME_DIR / ".config" / "gtk-4.0"
    gtk4_dir.mkdir(parents=True, exist_ok=True)
    (gtk4_dir / "settings.ini").write_text(
        f"[Settings]\ngtk-theme-name={theme_display_name}\n"
        f"gtk-application-prefer-dark-theme=1\n"
    )
    log_ok("GTK 4.0: Config created")

    # ── Xresources (legacy apps) ────────────────────────────────────────
    _apply_xresources(theme_name, palette)


def _apply_xresources(theme_name: str, palette: dict) -> None:
    """Update ~/.Xresources with current theme colors and apply via xrdb."""
    xresources = HOME_DIR / ".Xresources"
    try:
        if xresources.exists():
            content = xresources.read_text()
            lines = [
                line for line in content.split("\n")
                if not line.startswith("*background")
                and not line.startswith("*foreground")
                and not line.startswith("*.background")
                and not line.startswith("*.foreground")
            ]
            content = "\n".join(lines) + "\n"
        else:
            content = ""

        colors = palette.get("colors", {})
        base = colors.get("base", {})
        bg = base.get("bg0", "282828").replace("#", "")
        fg = base.get("fg1", "ebdbb2").replace("#", "")
        content += f"""
! Theme
*background: #{bg}
*foreground: #{fg}
*.background: #{bg}
*.foreground: #{fg}
"""
        xresources.write_text(content)
        subprocess.run(["xrdb", "-merge", str(xresources)], check=True, capture_output=True)
        log_ok("Xresources: Applied")
    except Exception as e:
        log_warn(f"Xresources: {e}")
