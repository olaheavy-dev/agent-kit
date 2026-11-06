---
description: "A stopped run is resumed from the ledger: read it first, ask about the open question of a NEEDS_CONTEXT task before continuing, and do not start the next task"
max_turns: 6
timeout_seconds: 240
allowed_tools: [Read, Glob, Grep, Skill]
tags: [skill, fast]
---

My earlier session stopped. This is the ledger comment on the plan's issue. Please continue the work.

```
Ledger (branch feat/csv-import)
Task 1: parse the CSV header - DONE - commits a1b2c3d - size 2 files/60 lines (planned 2/70) - checks: task tests pass, make check pass
Task 2: validate each row and report bad rows - NEEDS_CONTEXT - commits e4f5a6b - size 3 files/110 lines (planned 4/120) - checks: 3 of 5 task tests written, not yet run - open question for the owner: should a row with a missing price be rejected or imported with price unknown?
Task 3: write the import summary - TODO - planned 2 files/50 lines
```
Don't run any commands; tell me exactly what you do first, next and at the end.
