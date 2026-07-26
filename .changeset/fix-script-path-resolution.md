---
"antu": patch
---

Fix co-located script path resolution across skills (`wiki-ingest`, `wiki-query`, `wiki-lint`, `wiki-setup`) when invoked from a vault working directory, ensuring `sanitize.sh`, `index.py`, `search.py`, and `lint.sh` are correctly located and executed.
