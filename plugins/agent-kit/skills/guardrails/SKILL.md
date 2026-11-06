---
name: guardrails
description: Rules for keeping AI-assisted changes small, reviewable and in scope. A diff-size budget measured against the merge base (untracked files counted) with a stop when it is more than 50% over the plan's estimate, the situations where the agent stops and asks (new package, schema, deleting code, contract change, ambiguity), simplest-thing-that-works scope, a completeness search, "Noticed, not changed" for unrelated defects, how to run tests (stop and ask when the test conventions are unknown), a ledger of the plan's tasks so a stopped run can resume, and a fixed five-point final summary. Use at the start of any building task, when resuming one, and before reporting one done.
when_to_use: Building or changing code from a plan, "add a library to do X", "install a package", "how do I run just this test", "continue where we left off", resuming a task, diff size, scope creep, "while you're in there", checkpoint, final summary, "what did you not do", unrelated bugs spotted mid-task.
---

# Guardrails

Rules for keeping AI-assisted changes small, reviewable, and in scope. For test-driven workflow details, use the project's TDD skill (and `test-first` for money, rounding, dates, guards and parsers).

The capitalised names below (`SIZE_LIMITS`, `STOP_AND_ASK` and so on) are **extension points**: values the project or its template layer supplies. The full list of eleven, with what each answers, the defaults this skill needs and where to find each one, is in `${CLAUDE_PLUGIN_ROOT}/extension-points.md` (the `extension-points.md` file at the root of the agent-kit plugin; fallback: https://github.com/olaheavy-dev/agent-kit/blob/main/plugins/agent-kit/extension-points.md).

1. **Precedence: project over template over kit.** Look in the project's `AGENTS.md` first, then the template layer's `.claude/rules/` files, then the kit default in the extension-points document. `STOP_AND_ASK` is additive: a project list adds to the baseline below, it does not replace it. `TEST_CONVENTIONS` includes the preflight (what must be running before a test).
2. **If an extension point is missing, stop and ask.** If this skill needs a value that neither the project, the template layer nor the kit default supplies, stop and ask the owner. Never guess a command, a folder or a limit.

## Keep changes reviewable
- Work in **tasks**: a small, human-approved unit of work with a one-sentence done criterion and a test list (see the plan rule under Scope). Inside a task, work in red -> green -> refactor slices (see the project's TDD skill) and keep going until the task is complete.
- **Checkpoint:** when the task is complete, check its size and report it to the owner (below). The task's plan estimate (files and lines) is its size budget, measured as the task count below (the delta from the task-start baseline), never the cumulative branch total. **Over budget, or any item under "Stop and ask before", stops in BOTH modes; an autonomous run continues only after a clean checkpoint.** Stop and ask if the diff exceeds the budget set by `SIZE_LIMITS` (kit default: more than 50% over the estimate in lines or in files), or if the work needs a file the task's Files list does not name and that is not already part of the task (see the next points). `SIZE_LIMITS` covers the change, the slice and the task. Kit default for a task: over about 300 changed lines, stop and ask whether to split it, whatever the estimate says. The kit sets no default limit for a slice.
- **No estimate in the plan:** state "no estimate in the plan" in the checkpoint, use the `SIZE_LIMITS` default (about 300 changed lines and 50% over the plan's file list, if it has one), and ask only when the diff exceeds that default.
- **Start each task from a clean tree.** A task starts only when `git status --porcelain` shows nothing (ignored files aside; plan, spec and ledger documents may be uncommitted). If there is uncommitted or untracked work at task start, **stop and ask** the owner whether to commit it (as its own commit), stash it or remove it. Never absorb it into the task. The task baseline is then simply the `HEAD` commit SHA at task start, so every difference from it, and every untracked file that exists later, is the task's own. Commit each task before starting the next.
- **Counting the diff** (for the checkpoint report). Two counts, both including committed, staged, unstaged and untracked work (`git diff` alone misses commits and new files):
  - **Task count: the task's delta from its task-start baseline.** This is what the task's budget is measured against. The baseline is the `HEAD` commit SHA recorded in the ledger when the task becomes `IN_PROGRESS` (`BASE`). For the first task, or with no ledger, `BASE` is the merge base (and the clean-tree rule applies there too), so the task count equals the overall count.
  - **Overall count: the whole change from the merge base** (`BASE` = the merge base). Compare it with the plan's overall estimate if the plan has one.
  ```sh
  BASE=...    # task baseline SHA from the ledger, or: BASE=$(git merge-base HEAD origin/main)   (the project's default branch; fetch first if origin/main is missing)
  # files: changed or created since BASE, committed or not
  { git diff --no-renames --name-only "$BASE"; git ls-files --others --exclude-standard; } | sort -u | wc -l
  # tracked lines (committed + staged + unstaged)
  git diff --no-renames --shortstat "$BASE"
  # untracked lines (binary files count 0); do not run this under `set -o pipefail`: git diff --no-index exits 1
  git ls-files --others --exclude-standard | tr '\n' '\0' | xargs -0 -r -n1 git diff --no-index --numstat /dev/null 2>/dev/null | awk '$1!="-"{s+=$1} END{print s+0}'
  ```
  **M lines = insertions + deletions** from the second command, plus the untracked lines from the third. `--no-renames` makes a rename count as a deletion plus an addition whatever the user's `diff.renames` setting says. An untracked nested git repository counts as 1 file with 0 lines. Exclude plan and spec documents, and the ledger file when it is a file next to the plan, from both counts (remove their paths from the file count and subtract their lines) and say so in the report. Ignore other files unrelated to the task.
- The task is defined by the approved plan. Do not widen, redefine, or add to it; new work you discover goes under "Noticed, not changed". Do not keep going "while you're in there". Files that the completeness search or the project's pre-flight check shows must change **are part of the task**: count them, list them at the checkpoint, and ask only if they push the diff over budget.
- At a checkpoint, present the diff summary (files, what changed, why), one line stating both counts (`task: N files/M lines vs estimate; overall: N files/M lines`, from the counting commands above), the slice table from the TDD skill, the completeness search report, and open questions. Update the ledger (below). Then:
  - **Pair mode:** wait for the owner.
  - **Autonomous mode:** post the checkpoint as a **separate message in the session** (it may also be copied into the pull request description) and continue unless the owner stops you, but only if the checkpoint is clean (within budget, no stop-and-ask item open). Otherwise stop and ask, as in pair mode.
  - With no plan, work in pair mode (decision 0003 section 4); otherwise the mode is whatever the plan or the owner sets.

## Stop and ask before
The project's own list comes from `STOP_AND_ASK` (additive). At least, stop and ask before:
- Adding or changing a database migration or schema that the plan has not already approved.
- Deleting code, files, or tests.
- Changing a public contract (anything in `PUBLIC_CONTRACT`: routes, request and response shapes, schemas, generated types) that the plan does not include.
- Adding a package that is not in `APPROVED_PACKAGES` (an empty list means ask for every one), or making a major upgrade of any package, approved or not.
- Changing authentication or access rules, or changing the behaviour of existing shared code. Adding a new member that the task explicitly asks for is not a trigger.
- Any requirement that is ambiguous or has more than one reasonable interpretation.

## Scope: simplest thing that works
- Implement only what the current request needs (YAGNI, KISS). No speculative abstractions, options, or endpoints for "future stories".
- Prefer the simplest implementation that passes the tests; reuse existing helpers and patterns.
- If you notice follow-up work or implications (migrations, consumers, likely next stories), **list them in the summary; do not build them**.
- For changes touching more than 2 files, a schema change, or a change to the public contract: present a short plan first and wait for approval. An approved plan that covers the change satisfies this. The plan names the task(s) with a one-sentence done criterion each (name the endpoints or rules; "implement guards" alone is too broad), the full test list, what is out of scope, and implications. Where the plan goes comes from `PLAN_LOCATION`.

## Completeness
- At the end of each task, before the checkpoint, search for non-exact variants of what you changed: case and plural forms, renamed symbols, string literals, sibling features using the same pattern, and usages in tests, examples, and docs. Prefer find-references or code-intelligence tools over text search.
- Report what you searched for and what you found.

## Unrelated tech debt or defects
- Do not fix it, even if trivial. Mixed diffs make reviews large.
- Finish the current task, then list it under "Noticed, not changed" in the summary with: file, line, what is wrong, and a clarifying question. Then follow the project's rule for it (for example, open an issue).

## Running tests
- Take the test commands and the preflight from `TEST_CONVENTIONS`. If it is missing, stop and ask; do not guess how to run the tests (not even a common command such as `pytest -k`).
- Run only targeted tests while working (one test or one file, using the filter syntax in `TEST_CONVENTIONS`).
- At the end of a task, run the task's targeted tests together once. Run the full suite once when the work is finished or when a human asks; the whole-project check is `RUN_CHECK`.
- Run the preflight from `TEST_CONVENTIONS` (for example, checking that required services are up) **before writing or running any test that needs it**. If a required service is down, do not run the tests, even if the task says to. Tell the user and ask before starting services.
- A connection failure is never a valid red. A test that fails because a service is unreachable proves nothing; fix the environment first.

## Ledger
Every implementation task keeps a ledger: a short running record of the plan's tasks, so anyone can see where the work stands and a stopped run can resume without re-deriving it from git history. It lives at `LEDGER_LOCATION` (kit default: the same place as the plan, `PLAN_LOCATION`: one comment edited in place, or a small file next to the plan). If neither is known, stop and ask.

Each task has one entry:
- the task id and its one-sentence done criterion (from the plan)
- **status**: `TODO`, `IN_PROGRESS`, `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`
- the branch and the commit SHA(s)
- the task-start baseline: the `HEAD` commit SHA, recorded when the task becomes `IN_PROGRESS` (the working tree must be clean then)
- size: planned estimate against actual, as the task count from its baseline (files, lines; untracked files counted, plan, spec and ledger documents excluded)
- checks run and their results (targeted tests, the task's tests, `RUN_CHECK`), with what could not be run and why
- decisions made without asking (the running log in autonomous mode) and open questions for the owner
- "Noticed, not changed" items, each with its issue link

Rules:
1. Create the ledger when the plan is approved and before the first task starts. Update it at task start, at every checkpoint, at every stop-and-ask, and at task completion. **When resuming, read it first**, then continue at the first task that is not `DONE` or `DONE_WITH_CONCERNS`, after dealing with any `NEEDS_CONTEXT` or `BLOCKED` task by asking.
   Status codes: `TODO` = not started; `IN_PROGRESS` = work under way; `DONE` = finished with fresh check results recorded; `DONE_WITH_CONCERNS` = finished and counts as done, with concerns raised at the checkpoint; `NEEDS_CONTEXT` = waiting for an answer from the owner: ask first, do not resume; `BLOCKED` = cannot proceed: ask first, do not resume.
2. It is a record, not an approval: the plan stays the source of truth for scope. A ledger entry never widens a task.
3. A task is `DONE` only with the fresh check results recorded in its entry.
4. Never put secrets or personal data in it.

One writer at a time (the implementer); others read. Two agents editing one comment would overwrite each other.

If you move a ticket between statuses, do it only through `TRACKER`; if `TRACKER` is missing, stop and ask.

## Final summary format
The five points, in this order (the implementer's report is these five plus the assumptions it made):
1. What changed (files + one line each)
2. Tests run (targeted vs. full) and results, plus the slice table
3. What was intentionally not done
4. Noticed, not changed
5. Suggested next step
