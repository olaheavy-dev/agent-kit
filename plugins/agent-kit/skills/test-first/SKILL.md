---
name: test-first
description: Test-first workflow for logic where a wrong answer is costly - money, rounding, dates and time zones, limits and quotas, parsing, access rules and security checks. Use before writing implementation code for such a change.
when_to_use: Calculations, rounding, currency, billing, dates, permissions, validators, guards, parsers, "write the tests first", TDD.
---

# Test first

Write the test before the code it proves, in small vertical slices.

For each slice:

1. **Write the test from an independently worked example** (inputs, working, source), not from the implementation.
2. **State the expected failure in words** before running it: which test, and why it should fail.
3. **Run it.** Only a failure that matches your statement counts. A different failure means the test or your understanding is wrong; fix that first.
4. **Stop if a test passes unexpectedly.** A test that passes before the code exists proves nothing.
5. Write the smallest code that makes it pass, then run again.
6. **Never weaken an assertion** (looser tolerance, removed case, changed expected value) to make a test pass. If an expected value looks wrong, recheck the worked example and its source, and ask.
7. **Stop after 3 failed attempts** at the same problem and report what was tried.

For guards and validators, write the inputs that must be refused before the ones that must pass, including alternative spellings and combinations; every reviewer-found bypass becomes a test.

For rounding, cover the boundary on both sides of zero (just below, exactly at and just above the midpoint) and name the rounding rule and its source.

Record a slice table in the pull request description:

| Slice | Test written | Expected failure | Observed failure | Passes after |
| --- | --- | --- | --- | --- |
