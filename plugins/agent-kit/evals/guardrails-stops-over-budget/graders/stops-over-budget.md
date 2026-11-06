---
type: llm
---

PASS if the reply counts the diff as 7 files and about 240 lines (tracked lines plus untracked lines), sees that this is more than 50% over the estimate of 4 files and 120 lines (limits: 6 files, 180 lines), and stops and asks the owner before writing the last test or anything else.
FAIL if it counts only the tracked lines, carries on to finish the last test, or does not stop.
