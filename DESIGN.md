# Design

Visual system for figuya. Source of truth is [`palette.toml`](palette.toml);
this file is the human-readable companion. Colors below are the *anchors* — the
generator floors them per variant, so the emitted value can differ.

## Theme

Warm, high-contrast, restrained. Light = "Newsprint Cream" (warm paper); dark =
"Inked Cocoa" (warm near-black). Both are warm-neutral end to end (hue ~30–75),
so the palette reads warm regardless of variant. Color strategy: **Restrained** —
tinted warm neutrals carry the surface, Figuya Orange is the single accent and
stays ≤ ~10% of any surface.

## Color

### Structural tones

| Role | Light | Dark | Use |
|------|-------|------|-----|
| bg | `#fff6e9` | `#251d1b` | base surface |
| surface | `#fffaf3` | `#2e2422` | lifted: chips, popovers, panels (waybar modules) |
| overlay | `#f6ead8` | `#3b2f31` | recessed: gutters, inactive chips |
| hl_med | `#e8ddca` | `#50403d` | selection / current-line wash |
| text | `#2d2220` | `#f5ece0` | body/UI text — floored to 7:1 |
| dim | `#5c4d4a`¹ | `#a1887f`¹ | secondary text — floored to 4.5:1 |

¹ shown floored. ink `#2d2220` / paper `#fffaf3` are the two text poles `on()`
picks between for legibility on a colored fill.

### Brand accents (anchors; floored per variant to ≥ 4.5:1)

| Role | Anchor | Meaning |
|------|--------|---------|
| primary — Figuya Orange | `#f76707` | the brand accent; marks the active/primary element |
| secondary — Convention Violet | `#7950f2` | |
| tertiary — Marker Magenta | `#d6336c` | |
| info — Backorder Blue | `#1c7ed6` | |
| success — Stocked Green | `#2f9e44` | |
| warning — Caution Amber | `#f59f00` | |
| error — Sale Error Red | `#f03e3e` | |

`role` = floored-for-text; `role_raw` = unfloored brand hex for large/non-text
fills (cursors, borders, indicators, group tabs).

### Contrast floors (the contract)

- accent ≥ 4.5:1 · text ≥ 7:1 · dim ≥ 4.5:1, against the actual background.
- Enforced by `floor()` in `generate.py`. Hue held, lightness moved.

## Components (desktop chrome)

- **Waybar modules** — `surface` chips with a 1px transparent frame that lights up
  per-module; the active workspace is the one orange chip. Item padding lives in
  the user's `waybar/style.css` (not the theme): currently `1px 12px`.
- **Hyprland groupbar** — tabbed window stacks. Active tab = brand marker, inactive
  tabs recede; titles use the `on()`-picked pole for legibility. `gradients = true`
  is required for the tab *body* to fill (it renders flat for single-stop colors).
  The `col.active`/`col.inactive` color BOTH the body and the bottom indicator
  strip — they cannot be colored independently.
- **Borders** — hairline (`hl_med`); focus is shown by opacity, not loud borders.

## Motion

N/A — this is a static color theme. "Motion" is the darkman light/dark flip; every
token must stay above its floor on both sides of that flip.

## Principles in one line

Warmth from neutrals + type, not from tinting everything; orange marks one thing;
contrast is computed; calm reading surface.
