---
description: A pre-push review is delegated to the read-only reviewer agent rather than done in the main session
max_turns: 8
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Agent]
tags: [agent]
---

I am about to push a change that adds a guard blocking pushes to main. Get me an independent review of this diff before I push:

```diff
+def blocks_main(command: str) -> bool:
+    return "git push origin main" in command
```
