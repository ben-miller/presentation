#!/usr/bin/env bash
# Render TRANSCRIPT.md (kanji + <ruby> furigana) to a standalone HTML file, and
# optionally to PDF via the project's Playwright Chromium.
#
#   scripts/build-transcript.sh            # -> dist-transcript/TRANSCRIPT.html + .pdf
#   scripts/build-transcript.sh --html     # HTML only, skip the PDF step
#
# Requires: pandoc. PDF step also requires the `playwright-chromium` dev dep
# (installed) and its browser binary (`npx playwright install chromium`).

set -euo pipefail

cd "$(dirname "$0")/.."

SRC="TRANSCRIPT.md"
OUT_DIR="dist-transcript"
HTML="$OUT_DIR/TRANSCRIPT.html"
PDF="$OUT_DIR/TRANSCRIPT.pdf"
HTML_ONLY=0

for arg in "$@"; do
  case "$arg" in
    --html) HTML_ONLY=1 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc not found (brew install pandoc)" >&2
  exit 1
fi
if [[ ! -f "$SRC" ]]; then
  echo "error: $SRC not found" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

echo "==> pandoc: $SRC -> $HTML"
pandoc "$SRC" \
  --from gfm \
  --to html5 \
  --standalone \
  --embed-resources \
  --metadata pagetitle="発表台本 — 人事評価と報酬 日米比較" \
  --metadata lang=ja \
  --css scripts/transcript.css \
  --output "$HTML"

if [[ "$HTML_ONLY" -eq 1 ]]; then
  echo "done: $HTML"
  exit 0
fi

echo "==> chromium: $HTML -> $PDF"
if node scripts/html-to-pdf.mjs "$HTML" "$PDF"; then
  echo "done: $HTML  $PDF"
else
  echo "PDF step failed (is Chromium installed? 'npx playwright install chromium')." >&2
  echo "HTML is still available: $HTML" >&2
  exit 1
fi
