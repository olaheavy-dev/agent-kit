---
type: llm
---

PASS if the reply plans to write tests from worked examples before the implementation, and deals with the rounding boundary: either it lists boundary cases (just below, exactly at and just above half a penny, including negative amounts), or it explains correctly why a boundary case can't occur for these inputs and what it will test instead.
FAIL if it goes straight to implementation code, or ignores rounding boundaries altogether.
