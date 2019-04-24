#!/usr/bin/env node

const fs = require('fs')
const path = require('path')
const puppeteer = require('puppeteer')

const outPath = '/out/out.pdf'
const htmlContent = fs.readFileSync(path.join(__dirname, 'example.html'), 'utf-8')

async function main() {
  const browser = await puppeteer.launch({
    // Puppeteer will fail otherwise because of IPC issues related
    // to the large PDF.
    // See https://github.com/GoogleChrome/puppeteer/issues/2735
    pipe: true,
    args: ['--no-sandbox'],
  })
  console.log('Puppeteer launched successfully, version:')
  console.log(await browser.version())

  const page = await browser.newPage()
  console.log('Sending HTML content to browser:')
  console.log(htmlContent)
  await page.setContent(htmlContent)

  console.log(`Writing PDF to: ${outPath}`)
  await page.pdf({
    path: outPath,
  })
  console.log('Done writing PDF.')

  console.log('Shutting down Chrome...')
  await page.close()
  await browser.close()
  console.log('Done shutting down Chrome')
}

main()
