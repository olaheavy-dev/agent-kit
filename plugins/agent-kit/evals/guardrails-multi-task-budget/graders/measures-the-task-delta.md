---
type: llm
---

PASS if the report treats task 2 as within its budget (1 file and 20 lines from the task-start baseline, against an estimate of 1 file and 20 lines), reports both the task numbers (1 file, 20 lines) and the overall numbers (3 files, 120 lines), and goes on (a clean checkpoint, then task 3) without stopping for being over budget.
FAIL if it compares the cumulative 3 files and 120 lines with task 2's estimate and stops or asks because of it, or if it reports only one of the two counts.
