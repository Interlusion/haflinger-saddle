#!/bin/bash
# Markdown links: relative Markdown links only (no Obsidian wiki-links, which
# GitHub shows as text), absolute ones into this repository in the README, and every local
# link and #anchor resolves.
set -euo pipefail
cd "$(dirname "$0")/.."

# Tracked files only, so a local run matches CI.
md() { git ls-files -z '*.md' | xargs -0 -r "$@"; }

# [[target]] or [[target|text]] outside code; `[[ -f x ]]` in shell has a space. A code block
# opens with three or more backticks or tildes, also in a blockquote, and closes with at least
# as many of the same character on a line of their own; code spans of one or two backticks.
wiki=$(md awk '
  FNR == 1 { fence = "" }
  {
    line = $0
    sub(/^[ \t]*(>[ \t]*)*/, "", line)
    if (match(line, /^(`+|~+)/) && RLENGTH >= 3) {
      run = substr(line, 1, RLENGTH); rest = substr(line, RLENGTH + 1)
      if (fence == "" && !(run ~ /^`/ && index(rest, "`"))) { fence = run; next }
      if (fence != "" && substr(run, 1, 1) == substr(fence, 1, 1) && length(run) >= length(fence) && rest ~ /^[ \t]*$/) { fence = ""; next }
    }
    if (fence != "") next
    gsub(/``([^`]|`[^`])*``/, "", line)
    gsub(/`[^`]*`/, "", line)
    if (line ~ /\[\[[^] []/) print FILENAME ":" FNR ": " $0
  }
')
if [ -n "$wiki" ]; then
  echo "$wiki"
  echo "::error::Obsidian wiki-links above; use relative Markdown links: [text](path.md)"
  exit 1
fi
docker build -q -t haflinger-saddle-lychee .github/lychee >/dev/null
# The README's links, as lychee parses them (inline, reference and HTML links, not code), without
# the remap below: none may resolve to a local file, an #anchor included, so that the README reads
# the same wherever it is shown.
# The dump first, so that a failing lychee fails the check instead of finding nothing.
dump=$(docker run --rm -v "$PWD":/w:ro -w /w haflinger-saddle-lychee --config /dev/null --dump README.md)
relative=$(grep '^file://' <<<"$dump" || true)
if [ -n "$relative" ]; then
  echo "$relative"
  echo "::error::README.md links above are relative; link https://github.com/Interlusion/haflinger-saddle/blob/main/<path>"
  exit 1
fi
md docker run --rm -v "$PWD":/w:ro -w /w haflinger-saddle-lychee --config lychee.toml --no-progress
