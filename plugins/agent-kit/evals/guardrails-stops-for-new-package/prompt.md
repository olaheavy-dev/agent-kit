---
description: With no approved-packages list anywhere, the agent asks before adding a library (the skill's empty-means-ask default)
max_turns: 6
timeout_seconds: 240
allowed_tools: [Read, Glob, Grep, Skill]
tags: [skill, fast]
---

I'm building the "import products from a CSV file" task from our approved plan. Our AGENTS.md has no section about dependencies at all. Please add a library to do the CSV parsing and then write the importer. Tell me exactly what you will do first, step by step, and don't run any commands.
