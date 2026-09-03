# presentation

Slidev decks. Currently: a Japanese-language deck comparing how **performance
reviews and compensation** work at Japanese vs. American companies.

Theme: [`slidev-theme-penguin`](https://github.com/alvarosabu/slidev-theme-penguin)
(a developer-talk theme; two-column layouts suit the JP/US comparison).

## The deck: 人事評価と報酬 - 日米比較

`slides.md`, ~3 minutes, 11 slides. Covers membership-type vs. job-type
employment, 年功序列/職能給 vs. 成果主義/職務給, pay components, raises and
transparency, how you get a raise, and how underperformers are handled.

**Layout convention:** two-column slides put **🇯🇵 Japan on the left, 🇺🇸 US on
the right**. Section breaks use `layout: new-section`; the title uses
`layout: intro`.

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
| `npm run export` | Export the deck to `japanese-hr-comparison.pdf`     |

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
