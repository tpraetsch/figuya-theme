# CLAUDE.md

Guidance for Claude Code when working in this repo.

## What this is

`figuya` is a single-source-of-truth color theme. One palette (`palette.toml`) is
compiled by one generator (`generate.py`) into per-app theme files under `dist/`,
for ~25 editors, terminals, CLI tools, and Wayland desktop components.

The defining idea: **accent colors are never hand-tuned for contrast**. The
generator re-derives every color's contrast against the background it actually
sits on, to a WCAG floor — holding the hue and moving only lightness. "High
contrast" is computed, in both light and dark variants. Don't paste magic hex
values into emitters; let `floor()` do it.

## Architecture

```
palette.toml  ──►  generate.py  ──►  dist/<app>/<files>
 (you edit)        (resolve+emit)     (committed output)
```

- **`palette.toml`** — the *only* file you edit to change colors. Brand hues
  (`[brand]`), WCAG floors (`[floors]`), per-variant structural tones
  (`[variant.light]` / `[variant.dark]`), and ANSI mapping (`[ansi]`).
- **`generate.py`** — stdlib-only (Python 3.11+, uses `tomllib`). No deps.
  - `resolve(cfg, variant)` → a flat dict `p` of hex strings (no `#`) for one
    variant: `p["primary"]`, `p["bg"]`, `p["text"]`, plus `p["<role>_raw"]`
    (unfloored brand hex for large/non-text UI) and `p["ansi_*"]`.
  - `floor(fg, bg, ratio)` — the contrast engine. Lifts/darkens `fg` until it
    clears `ratio` against `bg`, preserving hue.
  - `emit_<app>(p)` (or `emit_<app>(pd, pl)` for cross-variant files) — builds a
    theme string and calls `write("<app>/<file>", body)`.
  - `main()` resolves both variants then calls every emitter.
- **`dist/`** — generated output, **committed** to the repo (it's what users
  install). Never edit by hand; regenerate instead.
- **`install.sh`** — regenerates, then copies `dist/` files into `~/.config`,
  `~/.local/share/figuya`, and `~/.local/share/themes` for a darkman-style
  light/dark switcher. Idempotent. `--no-gen` skips regeneration.

## Working in this repo

- **Changing a color:** edit `palette.toml`, run `python3 generate.py`, review the
  `dist/` diff. Re-pointing one hue updates every port.
- **Adding a port:** write an `emit_<app>(p)` function that calls
  `write(...)`, register it in `main()`, and add a row to the README's
  supported-ports / install sections. Use `p["<role>"]` for text-bearing color
  and `p["<role>_raw"]` for borders/cursors/large fills.
- **After any change to `palette.toml` or `generate.py`, regenerate** so `dist/`
  stays in sync — a stale `dist/` is the main failure mode here.

## Commands

```sh
python3 generate.py            # rewrite dist/ (prints file count + list)
python3 generate.py --preview  # same, plus an ANSI swatch of both variants
sh install.sh                  # regenerate + install onto this machine
sh install.sh --no-gen         # install current dist/ without regenerating
```

There are no tests, build system, or external dependencies. Verification is:
regenerate, then eyeball the `dist/` diff (and `--preview` swatch).
