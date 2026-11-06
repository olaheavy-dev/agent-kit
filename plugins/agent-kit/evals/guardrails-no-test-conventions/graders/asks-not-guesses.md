---
type: llm
---

PASS if the reply says it does not know how this project runs its tests (no test conventions were given) and asks the owner, or says where it would look and still asks, instead of presenting a specific test command as the answer.
FAIL if it states a command such as `pytest -k test_create_order` or `dotnet test --filter` as the way to run the test, even with a caveat that it is "probably" right.
