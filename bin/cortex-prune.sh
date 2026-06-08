#!/bin/bash
# cortex-prune.sh — health check for a cortex-forge vault wiki/
# Usage: cortex-prune.sh [vault-path]
# Exit: 0 = no HIGH findings, 1 = HIGH findings exist

set -uo pipefail

VAULT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
WIKI="$VAULT/wiki"
RAW="$VAULT/.raw"

if [ ! -d "$WIKI" ]; then
  echo "ERROR: No wiki/ found in $VAULT" >&2
  exit 2
fi

FINDINGS=$(mktemp)
trap 'rm -f "$FINDINGS"' EXIT

f() { echo "[$1] $2" >> "$FINDINGS"; }

# ── HIGH: Dead wikilinks ──────────────────────────────────────────────────────
grep -roh '\[\[wiki/[^]|]*' "$WIKI" 2>/dev/null \
  | sed 's/\[\[//' | sort -u \
  | while read -r link; do
      [ ! -f "$VAULT/${link}.md" ] && f HIGH "Dead link: [[${link}]]"
    done

# ── HIGH: Unprocessed .raw/ files ─────────────────────────────────────────────
if [ -d "$RAW" ]; then
  find "$RAW" -name "*.md" | while read -r raw; do
    rel="${raw#$VAULT/}"
    slug=$(basename "$raw" .md)
    if ! grep -rl "^raw: ${rel}$" "$WIKI/sources/" 2>/dev/null | grep -q .; then
      ls "$WIKI/sources/"*"${slug}"*.md 2>/dev/null | grep -q . || f HIGH "No source page for: $rel"
    fi
  done
fi

# ── HIGH: Pages without frontmatter ──────────────────────────────────────────
# index.md y log.md son intencionalmente sin frontmatter
find "$WIKI" -name "*.md" \
  | grep -v '_index\|/index\.md\|/log\.md' \
  | while read -r p; do
      head -1 "$p" | grep -q "^---" || f HIGH "No frontmatter: ${p#$VAULT/}"
    done

# ── MEDIUM: Orphan pages ──────────────────────────────────────────────────────
find "$WIKI" -name "*.md" \
  | grep -v '_index\|/index\.md\|/log\.md' \
  | while read -r page; do
      short=$(basename "$page" .md)
      hits=$(grep -rl "\[\[.*${short}" "$WIKI" 2>/dev/null \
             | grep -v "^${page}$" | wc -l | tr -d ' ')
      [ "$hits" -eq 0 ] && f MEDIUM "Orphan: ${page#$VAULT/}"
    done

# ── MEDIUM: Missing provenance — concepts + entities ──────────────────────────
# Source pages usan `source:` (URL) y `raw:`, no `sources:` wiki
for dir in "$WIKI/concepts" "$WIKI/entities"; do
  [ -d "$dir" ] || continue
  find "$dir" -name "*.md" | grep -v '_index' | while read -r p; do
    rel="${p#$VAULT/}"
    grep -q "^sources:" "$p" || f MEDIUM "No sources: $rel"
    grep -q "^confidence:" "$p" || f MEDIUM "No confidence: $rel"
  done
done

# ── MEDIUM: Sources without confidence ────────────────────────────────────────
[ -d "$WIKI/sources" ] && \
find "$WIKI/sources" -name "*.md" | grep -v '_index' | while read -r p; do
  grep -q "^confidence:" "$p" || f MEDIUM "No confidence: ${p#$VAULT/}"
done

# ── LOW: Sources without tags ─────────────────────────────────────────────────
[ -d "$WIKI/sources" ] && \
find "$WIKI/sources" -name "*.md" | grep -v '_index' | while read -r p; do
  val=$(grep "^tags:" "$p" 2>/dev/null | head -1)
  { [ -z "$val" ] || [ "$val" = "tags: []" ]; } && f LOW "No tags: ${p#$VAULT/}"
done

# ── Output ────────────────────────────────────────────────────────────────────
HIGH=$(grep -c '^\[HIGH\]'   "$FINDINGS" 2>/dev/null || true)
MED=$(grep  -c '^\[MEDIUM\]' "$FINDINGS" 2>/dev/null || true)
LOW=$(grep  -c '^\[LOW\]'    "$FINDINGS" 2>/dev/null || true)

for sev in HIGH MEDIUM LOW; do
  lines=$(grep "^\[${sev}\]" "$FINDINGS" 2>/dev/null || true)
  [ -n "$lines" ] && echo "" && echo "── ${sev} ────────────────" && echo "$lines"
done

echo ""
echo "── Summary ──────────────────────────────────────────────────────────────"
echo "HIGH: $HIGH  MEDIUM: $MED  LOW: $LOW"

[ "$HIGH" -gt 0 ] && exit 1 || exit 0
