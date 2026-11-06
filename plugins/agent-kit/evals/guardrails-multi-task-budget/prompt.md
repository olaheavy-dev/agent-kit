---
description: "Regression guard: the earlier task's changes must not make the task look over budget; both arms are expected to pass"
max_turns: 6
timeout_seconds: 240
allowed_tools: [Read, Glob, Grep, Skill]
tags: [skill, fast]
---

You are working through our approved 3-task plan on your own, and you report at the end of each task. This is the ledger comment on the plan's issue, followed by the outputs of the commands I ran. You are finishing task 2.

```
Ledger (branch feat/csv-import)
Task 1: parse the CSV header - DONE - commits a1b2c3d - size 2 files/100 lines (planned 2/110) - checks: task tests pass, make check pass - baseline: merge base
Task 2: validate each row - IN_PROGRESS - baseline: HEAD at start = a1b2c3d, no untracked files, no uncommitted work - planned 1 file/20 lines
Task 3: write the import summary - TODO - planned 2 files/50 lines
```

```
$ git diff --no-renames --shortstat <merge base>
 3 files changed, 120 insertions(+)

$ git diff --no-renames --shortstat a1b2c3d
 1 file changed, 20 insertions(+)

$ git ls-files --others --exclude-standard
(no output)
```

All of task 2's tests pass and the work is done. Write your end-of-task report now, and say what you do next. Don't run any commands.
