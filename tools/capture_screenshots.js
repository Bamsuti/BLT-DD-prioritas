// Capture runtime screenshots of the Flutter Web build.
//
// 1. flutter build web --dart-define=SCREENSHOT_MODE=true
// 2. Serve build/web, e.g. npx http-server build/web -p 8080
// 3. npm i puppeteer-core
// 4. CHROME_PATH="C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe" \
//    node tools/capture_screenshots.js http://127.0.0.1:8080
//
// SCREENSHOT_MODE hanya dipakai untuk dokumentasi: halaman dibuka langsung
// tanpa melewati login dan memakai data simulasi.

const puppeteer = require('puppeteer-core');
const path = require('path');
const fs = require('fs');

const BASE = process.argv[2] || 'http://127.0.0.1:8080';
const OUT = process.argv[3] || path.join('docs', 'screenshots', 'runtime');
const CHROME = process.env.CHROME_PATH ||
  'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

const pages = [
  { n: 0, slug: 'login' },
  { n: 1, slug: 'beranda' },
  { n: 2, slug: 'data-calon' },
  { n: 3, slug: 'penilaian' },
  { n: 4, slug: 'hasil' },
  { n: 5, slug: 'form-tambah' },
  { n: 6, slug: 'form-validasi' },
];

const viewports = [
  { tag: 'desktop', width: 1280, height: 800, dpr: 2 },
  { tag: 'mobile', width: 390, height: 844, dpr: 2 },
];

(async () => {
  fs.mkdirSync(OUT, { recursive: true });
  const browser = await puppeteer.launch({
    executablePath: CHROME,
    headless: 'new',
    args: ['--hide-scrollbars', '--no-sandbox', '--enable-unsafe-swiftshader'],
  });

  for (const vp of viewports) {
    const page = await browser.newPage();
    await page.setViewport({ width: vp.width, height: vp.height, deviceScaleFactor: vp.dpr });
    for (const item of pages) {
      await page.goto(`${BASE}/?page=${item.n}`, { waitUntil: 'networkidle2', timeout: 60000 });
      // Tunggu font dan animasi Flutter selesai agar teks tidak terpotong.
      await new Promise((resolve) => setTimeout(resolve, 6500));
      const name = `${String(item.n + 1).padStart(2, '0')}-${item.slug}-${vp.tag}.png`;
      await page.screenshot({ path: path.join(OUT, name) });
      console.log('saved', path.join(OUT, name));
    }
    await page.close();
  }

  await browser.close();
})();
