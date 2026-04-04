#!/usr/bin/env python3
# ═══════════════════════════════════════════════════════════════════════════════
# Theme Manager - Централизованная Система Управления Темами
# Генерирует конфиги и применяет темы динамически без перезапуска приложений
# Usage: theme-manager.py <theme-name>
# ═══════════════════════════════════════════════════════════════════════════════

import sys

from theme_lib import (
    DOTFILES_DIR, THEMES_DIR, PALETTES_DIR, TEMPLATES_DIR,
    HOME_DIR,
    COLORS, log_info, log_ok, log_err, log_warn,
    flatten_colors,
    render_template, write_config, create_symlink,
    load_palette, render_template_file, generate_named_theme_files,
    reload_all, set_nvim_theme, apply_gtk_settings,
    generate_wallpapers,
)

# ── Mappings ───────────────────────────────────────────────────────────────────

# Template files → output locations
TEMPLATE_MAPPING = {
    "hyprland.conf.j2": ".config/hypr/themes/current.conf",
    "waybar.css.j2": ".config/waybar/themes/current.css",
    "kitty.conf.j2": ".config/kitty/themes/current.conf",
    "rofi.rasi.j2": ".config/rofi/themes/current.rasi",
    "swaync.css.j2": ".config/swaync/themes/current.css",
    "starship.toml.j2": ".config/starship/themes/current.toml",
    "tmux.conf.j2": ".config/tmux/themes/current.conf",
    "yazi.toml.j2": ".config/yazi/themes/current.toml",
}

# ═══════════════════════════════════════════════════════════════════════════════
# Create Symlinks
# ═══════════════════════════════════════════════════════════════════════════════


def create_application_symlinks(theme_name: str) -> None:
    """Create symlinks for all applications."""
    
    # Dynamic symlink mappings for ANY theme
    symlink_mappings = {
        "hypr": ("conf", f"{theme_name}.conf"),
        "waybar": ("css", f"{theme_name}.css"),
        "kitty": ("conf", f"{theme_name}.conf"),
        "swaync": ("css", f"{theme_name}.css"),
        "starship": ("toml", f"{theme_name}.toml"),
        "rofi": ("rasi", f"{theme_name}.rasi"),
        "tmux": ("conf", f"{theme_name}.conf"),
        "yazi": ("toml", f"{theme_name}.toml"),
        # nvim uses plugin theme (ellisonleao/gruvbox.nvim)
    }
    
    config_base = HOME_DIR / ".config"
    
    for app, (ext, target) in symlink_mappings.items():
        symlink = config_base / app / "themes" / f"current.{ext}"
        
        if symlink.exists() or symlink.is_symlink():
            symlink.unlink()
        symlink.symlink_to(target)
        log_ok(f"{app}: symlink → {target}")


# ═══════════════════════════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════════════════════════


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
                content = render_template_file(template_name, context)
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

        # Generate wallpapers for theme
        print()
        generate_wallpapers(theme_name)

        # Create application symlinks
        print()
        create_application_symlinks(theme_name)

        # Apply GTK theme (theme must be installed manually)
        print()
        log_info("GTK: Applying theme...")
        apply_gtk_settings(theme_name)

        # Set Neovim theme name
        print()
        log_info("Neovim: Setting theme name...")
        set_nvim_theme(theme_name)
        log_ok(f"Neovim: vim.g.colors_name = {theme_name}")

        # Apply themes dynamically to running applications
        print()
        log_info("Dynamic theme application...")
        results = reload_all(theme_name)

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
