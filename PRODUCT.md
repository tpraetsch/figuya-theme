# Product

## Register

product

## Users

The theme's author (a developer ricing a Hyprland/Wayland desktop) and anyone
installing figuya across editors, terminals, CLI tools, and Wayland desktop
chrome. They spend all day in this environment and care about long-session
legibility, not first-impression flash. Context: variable ambient light, a
darkman-style light/dark flip during the day, dense text surfaces (code,
terminals, status bars) where contrast is load-bearing.

## Product Purpose

A single-source-of-truth color theme: one `palette.toml` compiled by
`generate.py` into ~25 per-app theme files under `dist/`. The defining promise is
that **contrast is computed, never hand-tuned**: every accent is re-derived
against the background it actually sits on to a WCAG floor (accents ≥ 4.5:1, body
text ≥ 7:1), holding hue and moving only lightness. Success = a warm, coherent,
recognizably-Figuya palette that is provably legible in both variants without any
per-color manual fudging.

## Brand Personality

Warm, precise, quietly confident. Three words: **warm, computed, restrained.**
The warmth comes from the brand neutrals (newsprint cream, inked cocoa) and
Figuya Orange; the precision from the contrast engine; the restraint from using
orange as a *sparing accent*, not a field. It should feel like a well-set
newspaper, not a neon dashboard.

## Anti-references

- Themes that look pretty in a swatch but fail contrast in practice (the thing
  the contrast engine exists to refuse).
- Neon/synthwave or "gamer RGB" desktops — saturation as decoration.
- The 2026 AI cream-and-one-accent default. figuya's cream is a *committed brand
  identity* (a real Figuya brand color), not a warm-tint-by-default; that
  distinction is why identity-preservation wins here over the usual "avoid cream"
  rule.
- Accent-as-wallpaper: letting the brand color fill large surfaces until it stops
  reading as an accent.

## Design Principles

1. **Computed contrast over chosen contrast.** If a color needs to be legible,
   it gets floored by the generator, not eyeballed. Never paste a magic hex.
2. **Orange is a marker, not a field.** Figuya Orange marks the one active /
   primary element. The moment it fills a large surface it loses meaning.
3. **One source of truth.** Color logic lives in `palette.toml` / `generate.py`;
   ports consume named roles. Per-app layout (padding, sizing) lives in that
   app's config, not the theme.
4. **Legible in both variants, by construction.** Every change is validated in
   light *and* dark; the floor is the contract.
5. **Quiet hierarchy.** Distinguish states with tone and a small accent, not with
   maximum saturation. The reading surface stays calm.

## Accessibility & Inclusion

WCAG is the product's core contract, enforced in code: accents ≥ 4.5:1 (AA),
body/UI text ≥ 7:1 (AAA), dim/secondary text ≥ 4.5:1, all against the actual
background. The palette must also survive the light/dark flip without dropping
below those floors. Hue is held while lightness moves, so color-blind users get
the same contrast separation everyone else does.
