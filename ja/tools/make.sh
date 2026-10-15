#!/bin/bash
# Build the Japanese book from ja/ into ja/system-design-notes-ja.{pdf,epub}.
#
#   ja/tools/make.sh            # PDF + EPUB
#   ja/tools/make.sh pdf        # PDF only
#   ja/tools/make.sh epub       # EPUB only
#   ja/tools/make.sh measure    # re-measure text size in images (after adding images)
#
# Requires: macOS, pandoc 3.x, Google Chrome, python3, curl, sips, xmllint, swift
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
OUT="$HERE/out"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
FMT="markdown-implicit_figures-yaml_metadata_block-native_divs+lists_without_preceding_blankline"
TARGET="${1:-all}"

mkdir -p "$OUT"

measure() {
  echo "==> Measuring text size in images (Vision OCR)"
  swiftc -O -o "$OUT/textsize" "$HERE/textsize.swift"
  (cd "$REPO/ja" && find . -path "*/images/*" -type f -print0 | xargs -0 "$OUT/textsize") |
    sed 's#^\./##' | sort > "$OUT/textsize.new.tsv"
  mv "$OUT/textsize.new.tsv" "$HERE/textsize.tsv"
  echo "    wrote $(wc -l < "$HERE/textsize.tsv" | tr -d ' ') rows to textsize.tsv"
}

fonts() {
  mkdir -p "$OUT/fonts"
  local base="https://github.com/google/fonts/raw/main/ofl"
  [ -f "$OUT/fonts/NotoSansJP.ttf" ] ||
    curl -sSLf -o "$OUT/fonts/NotoSansJP.ttf" "$base/notosansjp/NotoSansJP%5Bwght%5D.ttf"
  [ -f "$OUT/fonts/NotoSansMono.ttf" ] ||
    curl -sSLf -o "$OUT/fonts/NotoSansMono.ttf" "$base/notosansmono/NotoSansMono%5Bwdth,wght%5D.ttf"
}

combine() {
  python3 "$HERE/build.py" "$REPO" "$OUT/book.md"
}

pdf() {
  echo "==> PDF"
  fonts
  cp "$HERE/print.css" "$OUT/print.css"
  pandoc "$OUT/book.md" -f "$FMT" -t html5 -s --syntax-highlighting=none --toc --toc-depth=1 \
    --css print.css --metadata-file "$HERE/meta.yaml" \
    --metadata pagetitle="System Design Interview 学習ノート" -o "$OUT/book.html"
  python3 "$HERE/size_imgs.py" "$OUT/book.html" "$HERE/textsize.tsv"
  # Keep this heading on one line so its bookmark label keeps the space
  sed -i '' 's/Back-of-the-Envelope Estimation/Back-of-the-Envelope\&nbsp;Estimation/g' "$OUT/book.html"
  # Break the cover title after 「ノート」
  sed -i '' 's#学習ノート（日本語版）</h1>#学習ノート<br />（日本語版）</h1>#' "$OUT/book.html"
  "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer --generate-pdf-document-outline \
    --allow-file-access-from-files --virtual-time-budget=60000 \
    --print-to-pdf="$OUT/book.pdf" "file://$OUT/book.html" 2>&1 | grep "bytes written" || true
  cp "$OUT/book.pdf" "$REPO/ja/system-design-notes-ja.pdf"
  echo "    -> ja/system-design-notes-ja.pdf"
}

epub() {
  echo "==> EPUB"
  # Downscale images to JPEG (max 1200px) to keep the file under Send to Kindle's email limit
  (cd "$REPO/ja" && for f in */images/*; do
    dst="$OUT/epubimg/${f%.*}.jpg"
    [ -f "$dst" ] && [ "$dst" -nt "$f" ] && continue
    mkdir -p "$(dirname "$dst")"
    sips -Z 1200 -s format jpeg -s formatOptions 80 "$f" --out "$dst" >/dev/null
  done)
  python3 - "$OUT" "$REPO" <<'PY'
import re, sys
out, repo = sys.argv[1], sys.argv[2]
s = open(f"{out}/book.md", encoding="utf-8").read()
s = re.sub(re.escape(f"{repo}/ja/") + r'([^")]+?/images/[^")]+?)\.(png|PNG|jpe?g)',
           lambda m: f"{out}/epubimg/{m.group(1)}.jpg", s)
s = re.sub(r'\sstyle="margin-left:\s*[\d.]+(?:rem|em);?"', "", s)
# EPUB is XHTML: raw void tags must be self-closed
s = re.sub(r"<img([^>]*?)\s*/?>", r"<img\1 />", s)
s = re.sub(r"<br\s*/?>", "<br />", s)
open(f"{out}/book_epub.md", "w", encoding="utf-8").write(s)
PY
  pandoc "$OUT/book_epub.md" -f "$FMT" -t epub3 --syntax-highlighting=none --toc --toc-depth=2 \
    --split-level=1 --css "$HERE/epub.css" --metadata-file "$HERE/meta.yaml" -o "$OUT/book.epub"
  rm -rf "$OUT/epubcheck" && mkdir "$OUT/epubcheck" && unzip -oq "$OUT/book.epub" -d "$OUT/epubcheck"
  for f in "$OUT"/epubcheck/EPUB/text/*.xhtml; do xmllint --noout "$f"; done
  cp "$OUT/book.epub" "$REPO/ja/system-design-notes-ja.epub"
  echo "    -> ja/system-design-notes-ja.epub"
}

case "$TARGET" in
  measure) measure ;;
  pdf) combine; pdf ;;
  epub) combine; epub ;;
  all) combine; pdf; epub ;;
  *) echo "usage: $0 [all|pdf|epub|measure]" >&2; exit 2 ;;
esac
