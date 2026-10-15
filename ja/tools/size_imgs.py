#!/usr/bin/env python3
"""Size each <img> so the text inside it prints at a readable size.

Uses textsize.tsv (path relative to ja/, width px, height px, median OCR
line height px). Display width = width_px * TARGET_MM / text_px, clamped
to the page.
"""
import re
import sys
from pathlib import Path

html_path, tsv_path = sys.argv[1], sys.argv[2]
TARGET_MM = 2.4      # printed height of a text line inside a diagram (~7pt)
MAX_W_MM = 180       # A4 content width (210 - 2 * 15)
MAX_H_MM = 200       # leave room for surrounding text on the page
MIN_W_MM = 40
NO_TEXT_W_MM = 90    # diagrams without detectable text

info = {}
for line in open(tsv_path, encoding="utf-8"):
    path, w, h, t = line.rstrip("\n").split("\t")
    info[path] = (int(w), int(h), float(t))

# Optional per-image scale factors for page balance (path<TAB>factor, # comments)
overrides = {}
override_path = Path(tsv_path).with_name("overrides.tsv")
if override_path.exists():
    for line in open(override_path, encoding="utf-8"):
        line = line.split("#", 1)[0].strip()
        if line:
            path, factor = line.rsplit("\t", 1)
            overrides[path] = float(factor)

s = open(html_path, encoding="utf-8").read()
missing = 0


def resize(m):
    global missing
    tag = m.group(0)
    src = re.search(r'src="([^"]+)"', tag)
    key = src.group(1).split("/ja/", 1)[-1] if src else None
    if key not in info:
        missing += 1
        return tag
    w, h, t = info[key]
    width = w * TARGET_MM / t if t > 0 else NO_TEXT_W_MM
    width *= overrides.get(key, 1.0)
    width = max(MIN_W_MM, min(width, MAX_W_MM))
    if width * h / w > MAX_H_MM:
        width = MAX_H_MM * w / h
    tag = re.sub(r'\s(?:width|height)="[^"]*"', "", tag)
    tag = re.sub(r'\sstyle="[^"]*"', "", tag)
    return tag.replace("<img", f'<img style="width:{width:.1f}mm"', 1)


s = re.sub(r"<img\b[^>]*>", resize, s)
open(html_path, "w", encoding="utf-8").write(s)
print("unmatched images:", missing)
