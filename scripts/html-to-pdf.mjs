// Render a self-contained HTML file to PDF using the project's Playwright Chromium.
// Usage: node scripts/html-to-pdf.mjs <input.html> <output.pdf>

import { chromium } from 'playwright-chromium'
import { pathToFileURL } from 'node:url'
import { resolve } from 'node:path'

const [input, output] = process.argv.slice(2)
if (!input || !output) {
  console.error('Usage: node scripts/html-to-pdf.mjs <input.html> <output.pdf>')
  process.exit(1)
}

const browser = await chromium.launch()
try {
  const page = await browser.newPage()
  await page.goto(pathToFileURL(resolve(input)).href, { waitUntil: 'networkidle' })
  await page.pdf({
    path: output,
    format: 'A4',
    printBackground: true,
    margin: { top: '18mm', bottom: '18mm', left: '16mm', right: '16mm' },
  })
} finally {
  await browser.close()
}
console.log(`wrote ${output}`)
