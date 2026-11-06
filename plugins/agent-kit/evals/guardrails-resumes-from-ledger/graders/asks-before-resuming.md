---
type: llm
---

PASS if the reply reads the ledger first, sees that task 2 is NEEDS_CONTEXT with an open question, asks the owner that question (missing price: reject or import with price unknown) BEFORE continuing task 2, does not start task 3, and does not restart task 1. It may say it will update the ledger once the answer arrives.
FAIL if it carries on with task 2 (for example by choosing an answer itself), starts task 3, restarts task 1, or ignores the ledger.
