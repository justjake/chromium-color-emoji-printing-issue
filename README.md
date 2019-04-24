This repo demonstrates a pathological case for Chrome's printing functionality.

## Testing with Puppeteer Chromium

```
docker build . --tag chromium-color-emoji-printing-issue:0

docker run --rm -it -v "$(pwd)"/out:/out chromium-color-emoji-printing-issue:0 node /app/example.js
```

This should create ./out/out.pdf, an extremely large PDF file.

## Testing with Any Chrome

1. Modify `example.js` and add the following to the `puppeteer.launch({ ... })` call to specify the path to your Chrome/Chromiun executable:

```javascript
const browser = await puppeteer.launch({
  // Puppeteer will fail otherwise because of IPC issues related
  // to the large PDF.
  // See https://github.com/GoogleChrome/puppeteer/issues/2735
  pipe: true,
  args: ['--no-sandbox'],

  // You may need to modify this path to suite your system.
  executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
})
```

2. Install nodejs, then run `npm install` in this directory
3. Run `node example.js`
