---
type: llm
---

PASS if the reply continues at task 2 (not restarting task 1, not skipping to task 3), treats the existing commits and the 3 tests already written as the starting point (checking the branch state against the ledger), and says it will update the ledger entry for task 2 (status, commits, size, checks) at its checkpoint and at completion, only marking DONE with fresh check results.
FAIL if it restarts from task 1, starts task 3, ignores the ledger, or never mentions updating it.
