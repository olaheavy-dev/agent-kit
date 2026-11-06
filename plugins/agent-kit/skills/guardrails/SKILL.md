---
name: guardrails
description: Always-on rules for keeping AI-assisted changes small, reviewable and in scope - a diff-size budget with a stop at 50% over the plan's estimate, the situations where the agent stops and asks, simplest-thing-that-works scope, a completeness search, "Noticed, not changed" for unrelated defects, test-running etiquette and a fixed final summary format. Use at the start of any building task and before reporting one done.
when_to_use: Building or changing code from a plan, "keep the change small", diff size, scope creep, "while you're in there", checkpoint or final summary, "what did you not do", unrelated bugs spotted mid-task.
---

# Guardrails

Always-on rules for keeping AI-assisted changes small, reviewable, and in scope. For test-driven workflow details, use the project's TDD skill (and `test-first` for money, rounding, dates, guards and parsers).

The capitalised names below (`SIZE_LIMITS`, `STOP_AND_ASK` and so on) are **extension points**: values the project or its template layer supplies. The full list, with what each answers and where to find it, is in `${CLAUDE_PLUGIN_ROOT}/extension-points.md` (the `extension-points.md` file at the root of the agent-kit plugin).

**Precedence: project over template over kit.** Look in the project's `AGENTS.md` first, then the template layer's `.claude/rules/` files, then the kit default in the extension-points document.

**If an extension point is missing, stop and ask.** If this skill needs a value that neither the project, the template layer nor the kit default supplies, stop and ask the owner. Never guess a command, a folder or a limit.

## Keep changes reviewable
- Work in **tasks**: a small, human-approved unit of work with a one-sentence done criterion and a test list (see the plan rule under Scope). Inside a task, work in red -> green -> refactor slices (see the project's TDD skill) and keep going until the task is complete.
- **Checkpoint:** stop for human review when the task is complete. The task's plan estimate (files and lines) is its size budget. Stop and ask if the diff exceeds the estimate by more than 50% in lines or files, or if the work needs a file the task's Files list does not name. `SIZE_LIMITS` can change the 50%; with no override the kit default applies: 50% over the estimate, and about 300 lines per task. If the plan gives no estimate, stop and ask for one.
- **Counting the diff (for the checkpoint report):** count every file the task changed or created, including untracked files (`git diff` alone does not show new files). Run `git status --short -uall` for the file count (`-uall` lists untracked files individually), `git diff HEAD --shortstat` for tracked lines, and `git ls-files --others --exclude-standard -z | xargs -0 wc -l` for untracked lines (use the `total` line it prints). Exclude plan and spec documents from the count, and say so in the report. Ignore other files unrelated to the task.
- The task is defined by the approved plan. Do not widen, redefine, or add to it; new work you discover goes under "Noticed, not changed". Do not keep going "while you're in there".
- At a checkpoint, present the diff summary (files, what changed, why), one line stating the diff count (`N files, M lines` from the counting commands above), the slice table from the TDD skill, the completeness search report, and open questions. Then wait. In autonomous mode the checkpoint report is a **separate message in the session**, posted to the owner there; it may also be copied into the pull request description.

## Stop and ask before
The project's own list comes from `STOP_AND_ASK`. At least, stop and ask before:
- Adding or changing a database schema or migration that the plan does not approve.
- Deleting code, files, or tests.
- Changing a public contract (anything in `PUBLIC_CONTRACT`: routes, request and response shapes, schemas, generated types) that the plan does not include.
- Adding or upgrading a package that is not in `APPROVED_PACKAGES` (an empty list means ask for every one).
- Changing authentication or access rules, or changing the behaviour of existing shared code. Adding a new member that the task explicitly asks for is not a trigger.
- Any requirement that is ambiguous or has more than one reasonable interpretation.

## Scope: simplest thing that works
- Implement only what the current request needs (YAGNI, KISS). No speculative abstractions, options, or endpoints for "future stories".
- Prefer the simplest implementation that passes the tests; reuse existing helpers and patterns.
- If you notice follow-up work or implications (migrations, consumers, likely next stories), **list them in the summary; do not build them**.
- For changes touching more than 2 files, a schema change, or a change to the public contract: present a short plan first and wait for approval. The plan names the task(s) with a one-sentence done criterion each (name the endpoints or rules; "implement guards" alone is too broad), the full test list, what is out of scope, and implications. Where the plan goes comes from `PLAN_LOCATION`.

## Completeness
- At the end of each task, before the checkpoint, search for non-exact variants of what you changed: case and plural forms, renamed symbols, string literals, sibling features using the same pattern, and usages in tests, examples, and docs. Prefer find-references or code-intelligence tools over text search.
- Report what you searched for and what you found.

## Unrelated tech debt or defects
- Do not fix it, even if trivial. Mixed diffs make reviews large.
- Finish the current task, then list it under "Noticed, not changed" in the summary with: file, line, what is wrong, and a clarifying question.

## Running tests
- Take the test commands and the preflight from `TEST_CONVENTIONS`. If it is missing, stop and ask; do not guess how to run the tests.
- Run only targeted tests while working (one test or one file, using the filter syntax in `TEST_CONVENTIONS`).
- At the end of a task, run the task's targeted tests together once. Run the full suite once when the work is finished or when a human asks; the whole-project check is `RUN_CHECK`.
- Run the preflight from `TEST_CONVENTIONS` (for example, checking that required services are up) **before writing or running any test that needs it**. If a required service is down, do not run the tests, even if the task says to. Tell the user and ask before starting services.
- A connection failure is never a valid red. A test that fails because a service is unreachable proves nothing; fix the environment first.

## Final summary format
1. What changed (files + one line each)
2. Tests run (targeted vs. full) and results, plus the slice table
3. What was intentionally not done
4. Noticed, not changed
5. Suggested next step
