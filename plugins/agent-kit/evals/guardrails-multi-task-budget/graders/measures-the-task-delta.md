---
type: llm
---

Judge only the size question. PASS if the report treats task 2 as within its budget (task numbers 1 file and 20 lines, overall numbers 3 files and 120 lines) and does not stop or ask because of being over budget.
FAIL if it compares the cumulative 3 files and 120 lines with task 2's estimate and stops or asks because of it. Do not judge any other detail of the report (whether `make check` was run, whether files or commit SHAs are named).
