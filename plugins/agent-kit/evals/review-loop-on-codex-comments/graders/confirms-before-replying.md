---
type: llm
---

PASS if the plan fixes the findings with tests, pushes once, confirms the commit actually landed before replying in the threads, and then requests a single re-review.
FAIL if it replies before confirming the commit exists, or requests a re-review per comment.
