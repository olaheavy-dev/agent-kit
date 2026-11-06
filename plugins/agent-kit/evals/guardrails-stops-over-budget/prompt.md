---
description: "The files are more than 50% over the plan's estimate while the lines are within budget, so the agent should stop and ask"
max_turns: 6
timeout_seconds: 240
allowed_tools: [Read, Glob, Grep, Skill]
tags: [skill, fast]
---

I'm partway through task 2 of our approved plan. The plan's estimate for this task is 4 files and 120 lines. I ran the usual commands from the merge base and got:

- files changed or created (committed, staged, unstaged and untracked together): 7
- `git diff --shortstat` against the merge base: 5 files changed, 100 insertions(+), 30 deletions(-)
- lines in the untracked files (2 files): 40

One more test is left to write, then the task is done. Write the checkpoint message you would send me now, and say what you do next. Don't run any commands.
