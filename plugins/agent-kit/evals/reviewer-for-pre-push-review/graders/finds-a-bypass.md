---
type: llm
---

PASS if the review points out that the substring check is easily bypassed and gives at least one concrete input that gets through (for example `git push origin HEAD:main`, `git -C . push`, extra spaces, or a force push).
FAIL if it approves the change or only comments on style.
