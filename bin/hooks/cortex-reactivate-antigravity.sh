#!/bin/bash
# PreInvocation hook for Antigravity — injects .hot/{project}.md on invocationNum==0.

set -uo pipefail

PAYLOAD=$(cat 2>/dev/null || echo "{}")
INVOCATION_NUM=$(printf '%s' "$PAYLOAD" | jq -r '.invocationNum // 1' 2>/dev/null)

[ "$INVOCATION_NUM" != "0" ] && echo '{"injectSteps":[]}' && exit 0

WORKSPACE=$(printf '%s' "$PAYLOAD" | jq -r '.workspacePaths[0] // empty' 2>/dev/null)

find_git_root_dir() {
  local dir="${WORKSPACE:-$PWD}"
  while [ "$dir" != "/" ]; do
    [ -d "$dir/.git" ] && echo "$dir" && return 0
    dir="$(dirname "$dir")"
  done
  echo "${WORKSPACE:-$PWD}"
}

GIT_ROOT=$(find_git_root_dir)
HOT="$GIT_ROOT/.hot/$(basename "$GIT_ROOT").md"

[ ! -s "$HOT" ] && echo '{"injectSteps":[]}' && exit 0

# Skip YAML frontmatter (between first and second ---), read Zone 1 until ## History
CONTENT=$(awk '
  /^---$/ { dashes++; next }
  dashes < 2 { next }
  /^## History$/ { exit }
  { print }
' "$HOT")

[ -z "$CONTENT" ] && echo '{"injectSteps":[]}' && exit 0

ESCAPED=$(printf '%s' "$CONTENT" | jq -Rs .)
printf '{"injectSteps":[{"ephemeralMessage":%s}]}\n' "$ESCAPED"
