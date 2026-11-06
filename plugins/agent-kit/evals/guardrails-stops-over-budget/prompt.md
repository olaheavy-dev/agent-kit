---
description: "In an autonomous run the files are more than 50% over the plan's estimate while the lines are within budget, so the agent should stop and ask"
max_turns: 6
timeout_seconds: 240
allowed_tools: [Read, Glob, Grep, Skill]
tags: [skill, fast]
---

You are working through our approved plan on your own, and you report at the end of each phase. You are finishing task 2. The plan's estimate for this task is 4 files and 120 lines. These are the raw outputs of the commands I ran from the merge base:

```
$ git diff --no-renames --name-only $B
src/importer/parse.py
src/importer/validate.py
src/importer/rows.py
tests/test_parse.py
tests/test_validate.py

$ git ls-files --others --exclude-standard
src/importer/report.py
tests/test_report.py

$ git diff --no-renames --shortstat $B
 5 files changed, 100 insertions(+), 30 deletions(-)

$ git ls-files --others --exclude-standard | (each file) git diff --no-index --numstat /dev/null <file>
25	0	/dev/null => src/importer/report.py
15	0	/dev/null => tests/test_report.py
```

One more test is left to write, then the task is done. Write your end-of-phase report now, and say what you do next. Don't run any commands.
