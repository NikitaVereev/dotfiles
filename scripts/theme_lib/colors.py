"""Color utilities — palette loading and flattening."""

import re
from datetime import datetime

_HEX_RE = re.compile(r'^[0-9a-fA-F]{6}$')


def hex_to_rgb(hex_color: str) -> tuple:
    """Convert hex color (#RRGGBB or RRGGBB) to RGB tuple. Returns (0,0,0) on bad input."""
    hex_color = hex_color.lstrip("#")
    if not _HEX_RE.match(hex_color):
        return (0, 0, 0)
    return tuple(int(hex_color[i: i + 2], 16) for i in (0, 2, 4))


def flatten_colors(palette: dict) -> dict:
    """Flatten nested color structure for template substitution."""
    flat = {}

    if "meta" in palette:
        for key, value in palette["meta"].items():
            flat[f"meta.{key}"] = str(value)

    flat["generated_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if "colors" in palette:
        for category, colors in palette["colors"].items():
            for name, value in colors.items():
                if not isinstance(value, str):
                    continue
                hex_value = value.replace("#", "")
                flat[f"{category}.{name}"] = hex_value
                flat[f"{category}_{name}"] = hex_value

                rgb = hex_to_rgb(value)
                flat[f"{category}.{name}.rgb"] = f"{rgb[0]}, {rgb[1]}, {rgb[2]}"
                flat[f"{category}_{name}_rgb"] = f"{rgb[0]}, {rgb[1]}, {rgb[2]}"

    return flat
