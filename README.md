# presentation

A [Quarto](https://quarto.org) → reveal.js talk, in Japanese, arguing that
**working at a traditional big Japanese company wears you down**, made through
how pay and performance are handled (vs. the US).

Was Slidev; moved to Quarto because Slidev themes aren't swappable (each theme
ships its own Vue layouts). Quarto reveal.js themes are plain SCSS - every slide
is a `<section>`, so `theme:` is a genuine one-line switch.

**Live:**
- Deck: https://ben-miller.github.io/presentation/
- Transcript (furigana + English): https://ben-miller.github.io/presentation/transcript.html

Deployed from `main` by `.github/workflows/deploy.yml` (`quarto render` +
`scripts/build-transcript.sh` → GitHub Pages). `TRANSCRIPT.md` also renders
directly in the GitHub file view.

## The deck: `index.qmd`

~3 minutes, 11 slides. Thesis: hard work barely moves your pay, because pay
tracks age and tenure rather than contribution; weak performers are protected at
everyone else's expense; bonuses, raises, and pay data are all opaque. The US
side is the contrast ("paid for what you did, for better and worse"). Closing:
if you want to be paid for your ability, an old big Japanese company is the
wrong place.

This is an **argument, not a neutral comparison.** The nuance (job-type reforms
at Hitachi/Fujitsu/KDDI; foreign firms and startups differ; US dysfunctions)
lives in the `::: {.notes}` blocks and `TRANSCRIPT.md`'s 補足 section, not the
slides.

- **Japanese level:** roughly JLPT N3 - short sentences, everyday words, kana for
  heavier compounds. `TRANSCRIPT.md` adds furigana on top.
- **Column convention:** 🇯🇵 the Japanese problem on the left, 🇺🇸 the US
  alternative on the right (`::: {.columns}` with two `::: {.column}`).
- **Dividers:** `#` headings. **Comparison slides:** `##` headings.

### Theme

One line in the `index.qmd` YAML, with commented alternatives:

```yaml
theme: [simple, custom.scss]
# theme: [serif, custom.scss]
# theme: [moon, custom.scss]
```

Built-in reveal themes: `default simple serif white black league night sky beige
solarized moon dracula`. `custom.scss` layers on the Japanese webfont
(Noto Sans JP) plus column/divider tweaks, and is theme-agnostic. Restart
`quarto preview` after changing it.

## Speaker script

- **`index.qmd` `::: {.notes}` blocks** - plain kanji, shown in reveal's speaker
  view (press `s`).
- **`TRANSCRIPT.md`** - the standalone read-aloud script with **furigana**
  (`<ruby>` tags), English translations, and `▶ スライド N` advance cues.
  Renders on GitHub as-is.

### Rendering the transcript (`npm run transcript`)

`scripts/build-transcript.sh` turns `TRANSCRIPT.md` into `dist-transcript/`
(gitignored):

| File              | How it's made |
| ----------------- | ------------- |
| `TRANSCRIPT.html` | `pandoc` → standalone self-contained HTML (CSS from `scripts/transcript.css`); furigana renders natively. This is what deploys to `/transcript.html`. |
| `TRANSCRIPT.pdf`  | that HTML printed to PDF via Playwright Chromium (`scripts/html-to-pdf.mjs`) |

```sh
npm run transcript            # HTML + PDF
npm run transcript -- --html  # HTML only (CI uses this; needs only pandoc)
```

Why via a browser: pandoc's LaTeX/typst PDF writers drop raw `<ruby>` HTML.
Rendering the HTML with Chromium keeps the furigana.

## Setup & commands

Needs [Quarto](https://quarto.org/docs/get-started/) on PATH. `npm install` is
only for the transcript PDF step (Playwright).

| Command          | What it does |
| ---------------- | ------------ |
| `quarto preview index.qmd` | Live deck at http://localhost:port with hot reload |
| `quarto render index.qmd`  | Build `index.html` (+ `index_files/`) |
| `npm run transcript`       | Build the transcript HTML/PDF |

Speaker view: open the deck, press `s`. Export the deck to PDF: open with
`?print-pdf`, then print (or `decktape`).
