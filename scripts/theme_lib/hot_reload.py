"""Hot-reload / signal logic for running applications."""

import subprocess

from theme_lib.config import CONFIG_DIR, HOME_DIR, log_info, log_ok, log_warn


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
        result = subprocess.run(["waybar-msg", "cmd", "reload"], capture_output=True)
        if result.returncode == 0:
            return True
    except FileNotFoundError:
        pass
    try:
        subprocess.run(["pkill", "-SIGUSR2", "-x", "waybar"], check=True, capture_output=True)
        return True
    except Exception:
        return False


def apply_nvim() -> bool:
    """Signal all running Neovim instances to reload theme (SIGUSR1)."""
    try:
        result = subprocess.run(["pgrep", "-x", "nvim"], capture_output=True, text=True)
        if result.stdout.strip():
            for pid in result.stdout.strip().split("\n"):
                subprocess.run(["kill", "-USR1", pid], check=True, capture_output=True)
            return True
    except Exception:
        pass
    return False


def set_nvim_theme(theme_name: str) -> None:
    """Write current theme name for Neovim to read on startup."""
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
    """Source tmux config if a session is running."""
    tmux_theme = CONFIG_DIR / "tmux" / "themes" / "current.conf"
    if not tmux_theme.exists():
        return False
    try:
        result = subprocess.run(["tmux", "has-session"], capture_output=True)
        if result.returncode == 0:
            subprocess.run(
                ["tmux", "source-file", str(tmux_theme)],
                check=True, capture_output=True,
            )
            return True
    except Exception:
        pass
    return False


def reload_all(theme_name: str) -> dict:
    """
    Reload every running application.

    Returns a dict of {app_name: success_bool}.
    """
    results = {}

    log_info("Applying themes dynamically...")

    # Hyprland
    if apply_hyprland():
        results["hyprland"] = True
        log_ok("Hyprland: Reloaded")
    else:
        results["hyprland"] = False

    # Waybar
    if apply_waybar():
        results["waybar"] = True
        log_ok("Waybar: Reloaded")
    else:
        results["waybar"] = False

    # Kitty (SIGUSR1 — reload config)
    try:
        result = subprocess.run(["pgrep", "-x", "kitty"], capture_output=True, text=True)
        if result.stdout.strip():
            for pid in result.stdout.strip().split("\n"):
                subprocess.run(["kill", "-USR1", pid], check=True, capture_output=True)
            results["kitty"] = True
            log_ok("Kitty: Config reloaded (SIGUSR1)")
        else:
            results["kitty"] = False
    except Exception:
        results["kitty"] = False

    # Neovim (SIGUSR1)
    if apply_nvim():
        results["nvim"] = True
        log_ok("Neovim: Theme reloaded (SIGUSR1)")
    else:
        results["nvim"] = False

    # SwayNC
    if apply_swaync():
        results["swaync"] = True
        log_ok("SwayNC: CSS reloaded")
    else:
        results["swaync"] = False

    # Tmux
    if apply_tmux():
        results["tmux"] = True
        log_ok("Tmux: Config sourced")
    else:
        results["tmux"] = False

    # No hot-reload available
    results["rofi"] = False
    results["starship"] = True   # symlink — auto-applies on next shell
    results["yazi"] = False

    return results
