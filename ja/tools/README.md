# 日本語版PDF / EPUBのビルド

`ja/` の翻訳Markdownから、1冊にまとめたPDF（A4、Notoフォント、しおり付き）とKindle用EPUBを生成します。

```bash
ja/tools/make.sh
```

生成物は `ja/system-design-notes-ja.pdf` と `ja/system-design-notes-ja.epub` です。中間ファイルとフォントは `ja/tools/out/` に置かれます（gitの管理対象外）。

## 必要なもの

macOS、pandoc 3.x、Google Chrome、python3、Xcodeコマンドラインツール（swift）

## 仕組み

1. `build.py` が全章を1つのMarkdownにまとめる（画像パスの絶対化、表・区切り線の前処理）
2. pandocでHTML化し、`print.css` でA4・Noto Sans JP・本文9ptに整形
3. `size_imgs.py` が図の中の文字が約7.5pt相当で印刷されるよう、画像ごとに表示幅を決める（文字サイズは `textsize.tsv` に記録済み）
4. ChromeのヘッドレスモードでPDFに印刷（しおりは見出しから自動生成）
5. EPUBは画像を1200px・JPEGに縮小してpandocで生成

## 調整

- 本文の文字サイズ・余白: `print.css` の `html { font-size }` と `@page { margin }`
- 図の大きさ（全体）: `size_imgs.py` の `TARGET_MM`
- 図の大きさ（個別）: `overrides.tsv` に「`ja/` からのパス<TAB>倍率」を書く（ページ内のバランス調整用）
- 画像を追加・差し替えたら `ja/tools/make.sh measure` で `textsize.tsv` を作り直す
