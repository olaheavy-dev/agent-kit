---
type: llm
---

PASS if the checkpoint counts the diff as 7 files and 240 lines (110 + 40 + 90), compares it with the estimate of 4 files and 120 lines, says it is more than 50% over (limits 6 files and 180 lines), and stops and asks the owner before writing the last test or anything else.
FAIL if it counts only the tracked 150 lines, says it is within budget, or carries on to write the last test without asking.
