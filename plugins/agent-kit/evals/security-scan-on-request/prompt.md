---
description: The security-scan skill fires when asked to check a repository for secrets and vulnerable dependencies
max_turns: 6
timeout_seconds: 240
allowed_tools: [Read, Glob, Grep, Skill]
tags: [skill, fast]
---

Before I merge this, can you check the repository for leaked secrets, risky GitHub Actions workflows and dependencies with known vulnerabilities? Just tell me what you would run and why; don't run anything yet.
