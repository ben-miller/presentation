# presentation

Slidev decks. Currently: a Japanese-language talk arguing that **working at a
traditional big Japanese company wears you down**, made through how pay and
performance are handled (vs. the US).

## Theme (swappable)

The `theme:` line in `slides.md` headmatter has commented alternatives — switch
by moving the `#`:

```yaml
theme: penguin        # slidev-theme-penguin  (installed, current)
# theme: mokkapps     # slidev-theme-mokkapps (installed)
# theme: seriph       # built in, no install
# theme: default      # built in, no install
```

The deck only uses layouts common to all four (`intro`, `section`, `two-cols`,
`default`), so a swap is a one-line change and always builds. What changes is
styling — fonts, heading sizes, colors, and per-theme chrome (e.g. mokkapps adds
an author footer to every slide; penguin needs the `@iconify-json/*` dev deps).
Both extra themes are in `package.json`, so `npm ci` / the deploy workflow cover
them.

Do **not** put `---` inside a headmatter comment: Slidev's frontmatter splitter
scans for `---` and ignores YAML comments, so it truncates the block.

**Live:**
- Deck: https://ben-miller.github.io/presentation/
- Transcript (furigana + English): https://ben-miller.github.io/presentation/transcript.html

Both are deployed from `main` by `.github/workflows/deploy.yml` (Slidev build +
`npm run transcript` → GitHub Pages). `TRANSCRIPT.md` also renders directly in
the GitHub file view.

## The deck: 日本で働くのはつらい - 給料と成績の話

`slides.md`, ~3 minutes, 11 slides. Thesis: hard work barely moves your pay,
because pay tracks age and tenure rather than contribution; weak performers are
protected at the expense of everyone else; bonuses, raises, and pay data are all
opaque. The US side is the contrast ("paid for what you did, for better and
worse"). Closing: if you want to be paid for your ability, an old big Japanese
company is the wrong place.

This is an **argument, not a neutral comparison.** The nuance (job-type reforms
at Hitachi/Fujitsu/KDDI; foreign firms and startups differ; US dysfunctions)
lives in the presenter notes and `TRANSCRIPT.md`'s 補足 section, not the slides.

**Japanese level:** roughly JLPT N3 - short sentences, everyday words, kana for
heavier compounds. `TRANSCRIPT.md` adds furigana on top.

**Layout convention:** two-column slides put **🇯🇵 the Japanese problem on the
left, 🇺🇸 the US alternative on the right**. Section breaks use
`layout: new-section`; the title uses `layout: intro`.

## Speaker script

Two forms, kept in sync:

- **`slides.md` presenter notes** - the `<!-- ... -->` block at the end of each
  slide. Plain kanji. Shown in Slidev's Presenter mode and the `/notes` viewer
  (see "Does Slidev do transcripts?" below). Also carried into PowerPoint
  speaker notes on `slidev export --format pptx`.
- **`TRANSCRIPT.md`** - the full standalone script with **furigana** (`<ruby>`
  tags) and explicit `▶ スライド N` cues marking where to advance. Renders on
  GitHub and in any browser.

### Rendering the transcript (`npm run transcript`)

`scripts/build-transcript.sh` turns `TRANSCRIPT.md` into readable output in
`dist-transcript/` (gitignored):

| File                        | How it's made                                      |
| --------------------------- | -------------------------------------------------- |
| `TRANSCRIPT.html`           | `pandoc` -> standalone, self-contained HTML (CSS embedded from `scripts/transcript.css`); furigana renders natively |
| `TRANSCRIPT.pdf`            | that HTML printed to PDF via the project's Playwright Chromium (`scripts/html-to-pdf.mjs`) |

```sh
npm run transcript          # HTML + PDF
npm run transcript -- --html # HTML only, skip Chromium
```

Why this route: pandoc's LaTeX/typst PDF writers drop raw `<ruby>` HTML, and no
`luatexja-ruby` is installed. Rendering the HTML with a browser engine keeps the
furigana and picks up the system Japanese fonts. Needs `pandoc` on PATH; the PDF
step needs `npx playwright install chromium` (already done here).

## English translation captions

Each slide carries a small English gloss via the `<Tr>` component
(`components/Tr.vue`). Toggle all of them from the `slides.md` headmatter:

```yaml
showTranslations: true   # false hides every caption
```

Read at build/load time - change it and restart `npm run dev` (or rebuild).
Add one to a new slide with `<Tr>English here</Tr>` anywhere in that slide.

## Setup

```sh
npm install
```

`@iconify-json/carbon` and `@iconify-json/logos` are dev dependencies the
penguin theme needs to build (its header component references a Twitter icon);
`playwright-chromium` is for PDF/PNG export.

## Commands

| Command          | What it does                                         |
| ---------------- | --------------------------------------------------- |
| `npm run dev`    | Dev server with hot reload at http://localhost:3030 |
| `npm run build`  | Static SPA build into `dist/`                       |
| `npm run export` | Export the deck to `nihon-tsurai.pdf`     |

Presenter mode with notes: `npm run dev`, then press `p` (or open
`http://localhost:3030/presenter`). Hands-free notes that follow the live slide:
`http://localhost:3030/notes`.

## Does Slidev do transcripts / slide cues natively?

Partly, and it's why the script lives in two places:

- **Per-slide presenter notes are built in** (the trailing `<!-- -->` in each
  slide). They are inherently slide-synced - the note *is* attached to its
  slide, so "advance, then read this" is implicit. Markdown is supported, so
  `<ruby>` furigana works there too. Visible in Presenter mode, the `/notes`
  route, `/notes-edit`, and exported to `.pptx` speaker notes.
- **There is no built-in "export all notes as one transcript document."** So
  `TRANSCRIPT.md` is maintained by hand as the standalone, furigana-annotated
  read-aloud script with explicit advance cues.
- Ruby/furigana is not a native Slidev/Markdown feature either - it's plain
  `<ruby>漢字<rt>かんじ</rt></ruby>` HTML, which Slidev passes through.
