#!/usr/bin/env bash
# cortex-embed: Bootstrap semantic index for a vault.
# Usage: cortex-embed [vault_name|vault_path]
#   No args → uses default vault from ~/.cortex-forge/config.yml
#   vault_name → looks up path in config.yml
#   vault_path → uses path directly
set -euo pipefail

CONFIG="$HOME/.cortex-forge/config.yml"

# Resolve forge path from config (first vault with cortex-forge in the path, or explicit name)
FORGE_PATH=""
while IFS= read -r line; do
  trimmed="${line#"${line%%[![:space:]]*}"}"
  if [[ "$trimmed" == path:* ]]; then
    candidate="${trimmed#path:}"
    candidate="${candidate#"${candidate%%[![:space:]]*}"}"
    if [[ -f "$candidate/.cortex/embeddings.py" ]]; then
      FORGE_PATH="$candidate"
      break
    fi
  fi
done < "$CONFIG"

if [[ -z "$FORGE_PATH" ]]; then
  echo "ERROR: Cannot locate cortex-forge in $CONFIG" >&2
  exit 1
fi

INDEXER="$FORGE_PATH/scripts/cortex-index.py"

# Resolve target vault path
resolve_vault() {
  local arg="$1"
  # Absolute or relative path
  if [[ -d "$arg" ]]; then
    echo "$(cd "$arg" && pwd)"
    return
  fi
  # Vault name lookup in config
  local in_vault=false
  local current_name=""
  while IFS= read -r line; do
    trimmed="${line#"${line%%[![:space:]]*}"}"
    if [[ "$trimmed" =~ ^([a-zA-Z0-9_-]+):$ ]]; then
      current_name="${BASH_REMATCH[1]}"
    fi
    if [[ "$current_name" == "$arg" && "$trimmed" == path:* ]]; then
      local p="${trimmed#path:}"
      p="${p#"${p%%[![:space:]]*}"}"
      echo "$p"
      return
    fi
  done < "$CONFIG"
  echo "ERROR: Vault '$arg' not found in $CONFIG" >&2
  exit 1
}

resolve_default_vault() {
  local default_name=""
  while IFS= read -r line; do
    trimmed="${line#"${line%%[![:space:]]*}"}"
    if [[ "$trimmed" == default:* ]]; then
      default_name="${trimmed#default:}"
      default_name="${default_name#"${default_name%%[![:space:]]*}"}"
      break
    fi
  done < "$CONFIG"
  if [[ -z "$default_name" ]]; then
    echo "ERROR: No default vault in $CONFIG" >&2
    exit 1
  fi
  resolve_vault "$default_name"
}

if [[ $# -eq 0 ]]; then
  VAULT_PATH="$(resolve_default_vault)"
elif [[ $# -eq 1 ]]; then
  VAULT_PATH="$(resolve_vault "$1")"
else
  echo "Usage: cortex-embed [vault_name|vault_path]" >&2
  exit 1
fi

echo "Vault:  $VAULT_PATH"
echo "Forge:  $FORGE_PATH"
echo ""

python3 "$INDEXER" "$VAULT_PATH"
