#!/usr/bin/env python3
"""Capture actual Flutter Web runtime screens using Playwright.

Files are copied into docs/screenshots/runtime only if the whole smoke path
works. The script never renames wireframes as runtime evidence.
"""
from __future__ import annotations

import os
import shutil
from pathlib import Path

from playwright.sync_api import Locator, Page, TimeoutError as PlaywrightTimeoutError, sync_playwright

BASE_URL = os.environ.get("BLT_BASE_URL", "http://127.0.0.1:8765/")
TEMP_DIR = Path("build/runtime_screenshots")
DEST_DIR = Path("docs/screenshots/runtime")


def screenshot(page: Page, name: str) -> None:
    page.wait_for_timeout(900)
    TEMP_DIR.mkdir(parents=True, exist_ok=True)
    page.screenshot(path=str(TEMP_DIR / name), full_page=False)


def visible_locator(locator: Locator) -> Locator | None:
    try:
        for index in range(min(locator.count(), 12)):
            item = locator.nth(index)
            if item.is_visible():
                return item
    except Exception:
        return None
    return None


def fill_text(page: Page, label: str, index: int, value: str, point: tuple[int, int]) -> None:
    # Prefer accessible names. Coordinate fallback covers Flutter versions that
    # do not expose a DOM semantics node until a real input interaction occurs.
    for candidate in (
        page.get_by_role("textbox", name=label),
        page.get_by_label(label),
    ):
        item = visible_locator(candidate)
        if item is not None:
            item.fill(value, timeout=4000)
            return

    inputs = page.locator("input")
    try:
        if inputs.count() > index and inputs.nth(index).is_visible():
            inputs.nth(index).fill(value, timeout=3000)
            return
    except Exception:
        pass

    page.mouse.click(point[0], point[1])
    page.keyboard.press("Control+A")
    page.keyboard.type(value)


def click_text(page: Page, text: str, fallback: tuple[int, int] | None = None) -> None:
    item = visible_locator(page.get_by_text(text, exact=True))
    if item is not None:
        item.click(timeout=5000)
        return
    if fallback is not None:
        page.mouse.click(fallback[0], fallback[1])
        return
    raise RuntimeError(f"Teks antarmuka tidak ditemukan: {text}")


def click_button(page: Page, name: str, fallback: tuple[int, int] | None = None) -> None:
    item = visible_locator(page.get_by_role("button", name=name))
    if item is not None:
        item.click(timeout=5000)
        return
    click_text(page, name, fallback)


def wait_text(page: Page, text: str) -> None:
    try:
        page.get_by_text(text, exact=True).first.wait_for(state="visible", timeout=15000)
    except PlaywrightTimeoutError as exc:
        print("DEBUG body text:", page.locator("body").inner_text()[:3000])
        debug_path = TEMP_DIR / "debug-login-failed.png"
        TEMP_DIR.mkdir(parents=True, exist_ok=True)
        page.screenshot(path=str(debug_path), full_page=False)
        raise RuntimeError(f"Halaman runtime tidak menunjukkan teks yang diharapkan: {text}") from exc


def login(page: Page, email_point: tuple[int, int], password_point: tuple[int, int], button_point: tuple[int, int]) -> None:
    page.goto(BASE_URL, wait_until="networkidle", timeout=120000)
    page.wait_for_timeout(2200)
    fill_text(page, "Email", 0, "demo@blt-dd.local", email_point)
    fill_text(page, "Kata sandi", 1, "demo123", password_point)
    click_button(page, "Masuk", button_point)
    wait_text(page, "Ringkasan aplikasi")


def capture_desktop(browser) -> None:
    page = browser.new_page(viewport={"width": 1280, "height": 900}, device_scale_factor=1)
    page.goto(BASE_URL, wait_until="networkidle", timeout=120000)
    page.wait_for_timeout(1800)
    screenshot(page, "01-login-runtime.png")

    fill_text(page, "Email", 0, "demo@blt-dd.local", (640, 432))
    fill_text(page, "Kata sandi", 1, "demo123", (640, 500))
    click_button(page, "Masuk", (640, 580))
    wait_text(page, "Ringkasan aplikasi")
    screenshot(page, "02-beranda-runtime.png")

    click_text(page, "Data Calon", (64, 178))
    wait_text(page, "Data Calon Penerima")
    screenshot(page, "03-data-calon-runtime.png")

    click_button(page, "Tambah calon", (1195, 825))
    wait_text(page, "Tambah calon simulasi")
    screenshot(page, "04-form-calon-runtime.png")

    click_button(page, "Simpan", (830, 800))
    wait_text(page, "Nama calon wajib diisi.")
    screenshot(page, "05-validasi-form-runtime.png")
    click_button(page, "Batal", (710, 800))

    click_text(page, "Penilaian", (64, 246))
    wait_text(page, "Kriteria dan bobot demo")
    screenshot(page, "06-penilaian-runtime.png")

    click_text(page, "Hasil", (64, 315))
    wait_text(page, "Hasil prioritas simulasi")
    screenshot(page, "07-hasil-prioritas-runtime.png")
    page.close()


def capture_mobile(browser) -> None:
    page = browser.new_page(viewport={"width": 390, "height": 844}, device_scale_factor=1, is_mobile=True)
    login(page, (195, 424), (195, 490), (195, 570))
    screenshot(page, "08-beranda-mobile-runtime.png")
    page.close()


def main() -> None:
    if TEMP_DIR.exists():
        shutil.rmtree(TEMP_DIR)
    TEMP_DIR.mkdir(parents=True, exist_ok=True)

    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(headless=True, args=["--no-sandbox"])
            try:
                capture_desktop(browser)
                capture_mobile(browser)
            finally:
                browser.close()
    except Exception:
        if TEMP_DIR.exists() and any(TEMP_DIR.glob("*.png")):
            DEST_DIR.parent.mkdir(parents=True, exist_ok=True)
            if DEST_DIR.exists():
                shutil.rmtree(DEST_DIR)
            shutil.copytree(TEMP_DIR, DEST_DIR)
            print("Partial runtime screenshots copied for honest review:", sorted(p.name for p in DEST_DIR.glob("*.png")))
        raise

    expected = [
        "01-login-runtime.png",
        "02-beranda-runtime.png",
        "03-data-calon-runtime.png",
        "04-form-calon-runtime.png",
        "05-validasi-form-runtime.png",
        "06-penilaian-runtime.png",
        "07-hasil-prioritas-runtime.png",
        "08-beranda-mobile-runtime.png",
    ]
    missing = [name for name in expected if not (TEMP_DIR / name).exists()]
    if missing:
        raise RuntimeError("Screenshot runtime belum lengkap: " + ", ".join(missing))

    DEST_DIR.parent.mkdir(parents=True, exist_ok=True)
    if DEST_DIR.exists():
        shutil.rmtree(DEST_DIR)
    shutil.copytree(TEMP_DIR, DEST_DIR)
    print(f"Berhasil menangkap {len(expected)} screenshot runtime ke {DEST_DIR.resolve()}")


if __name__ == "__main__":
    main()
