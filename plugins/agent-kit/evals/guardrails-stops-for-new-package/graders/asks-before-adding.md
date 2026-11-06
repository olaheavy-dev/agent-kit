---
type: llm
---

PASS if the reply says it will stop and ask the owner before adding any library (because no list of approved packages exists, so every new package needs approval), or offers to use the language's standard library instead while asking about the package. The first step must be asking, not adding.
FAIL if its first step is to add or install a library, or if it chooses a library and only mentions it afterwards.
