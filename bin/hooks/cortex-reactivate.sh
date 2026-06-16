#!/bin/bash
# SessionStart hook: injects .hot/{project}.md as additional context.
# Detects the active project from CWD and reads from the active repo.

set -euo pipefail

find_git_root_dir() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -d "$dir/.git" ]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  echo "$PWD"
}

GIT_ROOT=$(find_git_root_dir)
HOT="$GIT_ROOT/.hot/MEMORY.md"

[ ! -s "$HOT" ] && exit 0

# Resolve imprint_triage: per-vault overrides global; backwards compat true→suggest false→off
CONFIG="$HOME/.cortex-forge/config.yml"
VAULT_PATH=$(awk -v root="$GIT_ROOT" '
  /^    path:/ { p = $2 }
  /^    imprint_triage:/ && p == root { print $2; exit }
' "$CONFIG" 2>/dev/null)
IMPRINT_TRIAGE="${VAULT_PATH:-$(grep -m1 '^imprint_triage:' "$CONFIG" 2>/dev/null | awk '{print $2}')}"
# Backwards compat
case "$IMPRINT_TRIAGE" in
  true)  IMPRINT_TRIAGE="suggest" ;;
  false) IMPRINT_TRIAGE="off"     ;;
  "")    IMPRINT_TRIAGE="suggest" ;;
esac

NUDGE=""
if [ "$IMPRINT_TRIAGE" != "off" ]; then
  # Extract date header and candidate from the most recent history entry only
  # History is newest-first: first ### header after ## History is the most recent entry
  ENTRY_DATE=$(awk '
    /^## History$/ { in_hist=1; next }
    in_hist && /^### [0-9]{4}-[0-9]{2}-[0-9]{2}/ { print $2; exit }
  ' "$HOT" 2>/dev/null)

  CANDIDATE=""
  if [ -n "$ENTRY_DATE" ]; then
    # Check 30-day expiry
    ENTRY_TS=$(date -j -f "%Y-%m-%d" "$ENTRY_DATE" "+%s" 2>/dev/null || date -d "$ENTRY_DATE" "+%s" 2>/dev/null || echo 0)
    NOW_TS=$(date "+%s")
    DIFF_DAYS=$(( (NOW_TS - ENTRY_TS) / 86400 ))

    if [ "$DIFF_DAYS" -le 30 ]; then
      # Extract candidate line from the most recent history entry (between first ### and second ###)
      CANDIDATE=$(awk '
        /^## History$/ { in_hist=1; next }
        in_hist && /^### / { if (++entry_count == 2) exit; next }
        in_hist && entry_count == 1 && /^#### Imprint candidate$/ { found=1; next }
        found && /^- / { print; exit }
        found && /^####/ { exit }
      ' "$HOT" 2>/dev/null)
    fi
  fi

  if [ -n "$CANDIDATE" ]; then
    # Extract transcript path and clean description
    TRANSCRIPT_PATH=$(printf '%s' "$CANDIDATE" | grep -oE 'transcript: [^ ]+' | awk '{print $2}')
    CANDIDATE_TEXT=$(printf '%s' "$CANDIDATE" | sed 's/ — transcript:.*$//' | sed 's/^- //')

    # Write structured draft file
    DRAFT="$GIT_ROOT/.hot/imprint-draft.md"
    cat > "$DRAFT" <<DRAFTEOF
---
candidate: $CANDIDATE_TEXT
transcript: $TRANSCRIPT_PATH
detected: $(date '+%Y-%m-%d')
mode: $IMPRINT_TRIAGE
---
DRAFTEOF

    if [ "$IMPRINT_TRIAGE" = "auto" ]; then
      NUDGE="⚠ IMPRINT CANDIDATE (auto mode): $CANDIDATE_TEXT
Draft saved to .hot/imprint-draft.md. Run /cortex-imprint now — do not wait for user instruction. Confirm with the user only if the page type or title is ambiguous.

---

"
    else
      NUDGE="⚠ IMPRINT CANDIDATE from last session: $CANDIDATE_TEXT
Draft info saved to .hot/imprint-draft.md. Run /cortex-imprint to archive it as a permanent wiki page before it's lost.

---

"
    fi
  fi
fi

CONTENT=$({ printf '%s' "$NUDGE"; cat "$HOT"; } | jq -Rs .)

cat <<EOF
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":$CONTENT}}
EOF
