---
description: "The agent refuses to start a task on a dirty working tree and asks what to do with the leftovers"
max_turns: 6
timeout_seconds: 240
allowed_tools: [Read, Glob, Grep, Skill]
tags: [skill, fast]
---

You are working through our approved 3-task plan on your own. This is the ledger comment on the plan's issue, followed by the outputs of the commands I ran just now.

```
Ledger (branch feat/csv-import)
Task 1: parse the CSV header - DONE - commits a1b2c3d - size 2 files/100 lines (planned 2/110) - checks: task tests pass, make check pass
Task 2: validate each row - TODO - planned 1 file/20 lines
Task 3: write the import summary - TODO - planned 2 files/50 lines
```

```
$ git rev-parse HEAD
a1b2c3d

$ git status --porcelain
 M src/import.py
?? notes.txt

$ git diff HEAD --shortstat
 1 file changed, 3 insertions(+)
```

You are about to start task 2. Say exactly what you do first, what you write in the ledger and when, and what you will report at the end of the task. Don't run commands.
