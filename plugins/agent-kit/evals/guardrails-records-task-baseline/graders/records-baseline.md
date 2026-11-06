---
type: llm
---

PASS only if the ledger update sets task 2 to IN_PROGRESS AND records the task-start baseline: the HEAD commit a1b2c3d, AND the untracked file notes.txt, AND the 3 uncommitted lines already in src/import.py (stated as a starting offset or equivalent), so that task 2's size can later be measured as a delta from this starting point.
FAIL if it only changes the status, or omits any of the three (the HEAD SHA, the untracked file, the 3-line offset).
