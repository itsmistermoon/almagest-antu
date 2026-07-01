# Embedding dependency check

Disclosed reference for `cortex-forge-setup`. Reached from step 6d and menu option 4.

Run this before any indexing attempt. Also triggered if `cortex-index.py` fails with an import error.

## Detection

Detect platform: `uname -m` → `arm64` = Apple Silicon, anything else = generic.

Run:
```bash
python3 -c "import mlx_lm" 2>/dev/null && echo mlx || python3 -c "import sentence_transformers" 2>/dev/null && echo st || echo none
```

- **`mlx` or `st` available** → proceed silently (report which backend is active in the summary).
- **`none`** → do NOT fail silently. Present this message:

  ```
  Semantic search requires an embedding library to generate vectors locally.
  No compatible library was found on this machine.

  Why this matters: without embeddings, cortex-recall falls back to keyword search
  across the full index. With embeddings, it retrieves the most relevant pages
  semantically — useful as the vault grows beyond ~50 pages.

  Long-term implications of installing:
  • ~270 MB of model weights downloaded once, stored in ~/.cache/
  • On Apple Silicon: mlx-embeddings runs via Neural Engine (fast, low power)
  • On other platforms: sentence-transformers runs on CPU (slower but portable)
  • No network calls at query time — fully local after the first download

  Install now?
    [1] Yes — install for this platform ({mlx-embeddings | sentence-transformers})
    [2] No — skip semantic search for now (can re-run /cortex-forge-setup later)
  ```

## Installation

If user chooses **[1]**:
- Apple Silicon → `pip install mlx-embeddings` (primary); if it fails, fall back to `pip install sentence-transformers` and note the fallback.
- Other → `pip install sentence-transformers`.
- After install, re-run the detection snippet to confirm. If still failing, report the error and skip indexing — do not proceed blindly.

If user chooses **[2]**: skip indexing, note in the final summary that semantic search is not active.
