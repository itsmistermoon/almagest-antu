#!/bin/bash
# PreCompact / Stop hook: appends a session snapshot to .hot/{project}.md.
# Preserves the two-zone structure — Current state zone is not modified here.
# Current state is only updated by /cortex-crystallize invoked manually.

set -uo pipefail

PAYLOAD=$(cat 2>/dev/null || echo "{}")
TRANSCRIPT_PATH=$(printf '%s' "$PAYLOAD" | jq -r '.transcript_path // empty' 2>/dev/null)
TRIGGER=$(printf '%s' "$PAYLOAD" | jq -r '.hook_event_name // "manual"' 2>/dev/null)
CWD=$(printf '%s' "$PAYLOAD" | jq -r '.cwd // empty' 2>/dev/null)

find_git_root_dir() {
  local dir="${CWD:-$PWD}"
  while [ "$dir" != "/" ]; do
    if [ -d "$dir/.git" ]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  echo "${CWD:-$PWD}"
}

GIT_ROOT=$(find_git_root_dir)
PROJECT=$(basename "$GIT_ROOT")

if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  TRANSCRIPT_PATH=$(ls -t "$HOME/.claude/projects/"*/*.jsonl 2>/dev/null | head -1)
fi
[ -z "$TRANSCRIPT_PATH" ] && exit 0
[ ! -f "$TRANSCRIPT_PATH" ] && exit 0

mkdir -p "$GIT_ROOT/.hot" 2>/dev/null || exit 0

if ! grep -qF '.hot/' "$GIT_ROOT/.gitignore" 2>/dev/null; then
  echo '.hot/' >> "$GIT_ROOT/.gitignore"
fi

NOW=$(date '+%Y-%m-%d %H:%M %Z')

FILES_TOUCHED=$(jq -r '
select(.type == "assistant")
| .message.content[]?
| select(.type == "tool_use" and (.name == "Edit" or .name == "Write" or .name == "NotebookEdit"))
| .input.file_path // empty
' "$TRANSCRIPT_PATH" 2>/dev/null | sort -u | grep -v '^$' || true)

EXTERNAL_ACTIONS=$(jq -r '
select(.type == "assistant")
| .message.content[]?
| select(.type == "tool_use" and .name == "Bash")
| .input.command
| select(test("git (commit|push|tag)|gh (issue|pr) (create|edit|close)|sam deploy"; "i"))
| split("\n")[0]
' "$TRANSCRIPT_PATH" 2>/dev/null | tail -n 10)

HOT_FILE="$GIT_ROOT/.hot/$PROJECT.md"
TMP=$(mktemp -t hot-cache.XXXXXX) || exit 0
trap 'rm -f "$TMP"' EXIT

# Preserve Current state zone (before first ---), append new History entry after it
if [ -f "$HOT_FILE" ]; then
  CURRENT_STATE=$(awk '/^---$/{exit} {print}' "$HOT_FILE")
  PREV_HISTORY=$(awk 'found && !/^## History$/{print} /^---$/{found=1}' "$HOT_FILE")
else
  CURRENT_STATE="## Current state

### Pending
_(none)_

### Active decisions
_(none)_"
  PREV_HISTORY=""
fi

{
printf '%s\n' "$CURRENT_STATE"
echo ""
echo "---"
echo ""
echo "## History"
echo ""
echo "### $NOW — Claude Code ($TRIGGER)"
echo ""
echo "#### What was done"
if [ -n "$FILES_TOUCHED" ]; then
  printf '%s\n' "$FILES_TOUCHED" | sed 's|^|- |'
else
  echo "_(none)_"
fi
echo ""
if [ -n "$EXTERNAL_ACTIONS" ]; then
  echo "#### External actions"
  echo '```bash'
  printf '%s\n' "$EXTERNAL_ACTIONS"
  echo '```'
  echo ""
fi
echo "#### Discarded"
echo "_(none)_"
echo ""
echo "#### Fragile context"
echo "_(none)_"
if [ -n "$PREV_HISTORY" ]; then
  echo ""
  printf '%s\n' "$PREV_HISTORY"
fi
} > "$TMP"

mv "$TMP" "$HOT_FILE"
exit 0
