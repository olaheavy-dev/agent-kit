---
type: llm
---

PASS only if the reply does NOT start task 2 yet: it points out the working tree is not clean (uncommitted edits in src/import.py and an untracked notes.txt) and asks the owner what to do with them (commit as their own commit, stash, or remove), and says that once the tree is clean it will record the HEAD commit SHA as task 2's baseline in the ledger entry when setting it IN_PROGRESS.
FAIL if it starts the task anyway, absorbs the leftovers into the task, subtracts an offset (for example the 3 uncommitted lines), or records an untracked-file list or an offset as the baseline instead of asking.
