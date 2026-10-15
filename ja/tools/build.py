#!/usr/bin/env python3
"""Combine ja/ chapters into one Markdown file for PDF / EPUB generation."""
import re
import sys
from pathlib import Path

repo = Path(sys.argv[1]).resolve()
out = Path(sys.argv[2])
ja = repo / "ja"

chapters = sorted(
    (d for d in ja.iterdir() if d.is_dir() and re.match(r"\d\d\.", d.name)),
    key=lambda d: int(d.name[:2]),
)

parts = []
for d in chapters:
    md = next(p for p in d.iterdir() if p.name.lower() == "readme.md")
    text = md.read_text(encoding="utf-8")
    img_dir = (d / "images").as_posix()
    # Rewrite relative image paths to absolute ones
    text = re.sub(r'(src=")\./images/+', lambda m: m.group(1) + img_dir + "/", text)
    text = re.sub(r"(\]\()\./images/+", lambda m: m.group(1) + img_dir + "/", text)
    # Fix unclosed <div> typo carried over from the source (ch.12)
    text = text.replace("      <div>\n\n2. **受信側:**", "      </div>\n\n2. **受信側:**")
    # Cross-chapter link that only makes sense on GitHub
    text = text.replace("[デジタルウォレットの章](../chapter28)", "デジタルウォレットの章（第27章）")
    # A bare `---` can be read as a setext underline or the start of a
    # multiline table; turn it into an unambiguous thematic break.
    text = re.sub(r"(?m)^---\s*$", "\n* * *\n", text)
    # Pandoc needs a blank line before a pipe table (GitHub does not)
    text = re.sub(r"(?m)^([^|\n].*)\n(\|.*\|\s*\n\|[\s:|-]+\|)", r"\1\n\n\2", text)
    parts.append(text.strip() + "\n")

readme = (ja / "Readme.md").read_text(encoding="utf-8")
resources = readme[readme.index("# 追加リソース"):]
resources = resources.replace("# 追加リソース", "# 付録: 追加リソース", 1)
parts.append(resources)

front = ""
intro = """# はじめに {.unnumbered}

このノートは書籍『System Design Interview - An Insider's Guide』の Vol 1 および Vol 2 第2版に基づく学習ノートを日本語に翻訳したものです。

- 原著: [System Design Interview - An Insider's Guide](https://bytebytego.com/courses/system-design-interview)
- 原文ノートは作成途中のものです。

## この日本語版について {.unnumbered}

- オリジナル (<https://github.com/liquidslr/system-design-notes>) をAI翻訳したものです
- 2026/10/17 時点での最新版を元にしています
- Fork (<https://github.com/shigeya-t/system-design-notes>) の `ja` ディレクトリに訳したファイルがあります
- Fork の [Releases](https://github.com/shigeya-t/system-design-notes/releases) にPDFとepubがあります
- 訳やレイアウトがおかしいところがあれば Fork の Issue (<https://github.com/shigeya-t/system-design-notes/issues>) にてお知らせください

"""
out.write_text(front + intro + "\n\n".join(parts), encoding="utf-8")
print(f"wrote {out} ({len(chapters)} chapters)")
