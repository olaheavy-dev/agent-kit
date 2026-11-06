---
description: A stopped run is resumed from the ledger: read it first, continue at the first task that is not DONE, and update the ledger
max_turns: 6
timeout_seconds: 240
allowed_tools: [Read, Glob, Grep, Skill]
tags: [skill, fast]
---

My earlier session stopped. This is the ledger comment on the plan's issue. Please continue the work.

```
Ledger (branch feat/csv-import)
Task 1: parse the CSV header - DONE - commits a1b2c3d - size 2 files/60 lines (planned 2/70) - checks: task tests pass, make check pass
Task 2: validate each row and report bad rows - IN_PROGRESS - commits e4f5a6b - size 3 files/110 lines (planned 4/120) - checks: 3 of 5 task tests written, not yet run
Task 3: write the import summary - TODO - planned 2 files/50 lines
```
Don't run any commands; tell me exactly what you do first, next and at the end of the task.
