# 0004. Eleven extension points, the ledger and the tracker

Status: Accepted

Supersedes the list of nine extension points in [0003](0003-stack-neutral-kit.md), sections 2 and 3. Sections 1 and 4 to 6 of 0003 (the kit stays stack-neutral, modes, provenance and licence, no agent attribution) and its hybrid-port decisions still stand.

## Context

[0003](0003-stack-neutral-kit.md) fixed nine extension points: the named values that a project or a template layer supplies so that kit skills stay stack-neutral. Two more needs came up while porting the `guardrails` skill (issue #7, founder decisions of 6 November 2026):

1. A stopped implementation run could only be resumed by re-deriving its state from git history. Upstream's `subagent-driven-development` keeps a progress ledger of the plan's tasks; the founder wanted the same for all implementation work.
2. Skills that move tickets need to know which tracker the project uses, what its statuses mean and what each status requires. Without a named point they would guess.

Because 0003 is an accepted record, it is not rewritten ([0001](0001-record-decisions.md)); this record changes the list instead.

## Decision

### 1. Eleven extension points

The contract in 0003 is unchanged: precedence is project over template over kit, and a missing extension point means the skill stops and asks, never guesses (`STOP_AND_ASK` is additive: a project list adds to the kit baseline). The list is now:

| Extension point | What it answers | Usually supplied by |
| --- | --- | --- |
| `RUN_CHECK` | The one command that runs every check before pushing | Project `AGENTS.md`, "Commands" |
| `TEST_CONVENTIONS` | Where tests live, how they are named, how to run one test or one file, the preflight, and the test-first rules for that stack | Each template layer, as `.claude/rules/test-conventions.md` |
| `STOP_AND_ASK` | The situations where the agent must stop and ask the owner | Project `AGENTS.md` |
| `APPROVED_PACKAGES` | Which dependencies may be added without asking (empty means ask for every one) | Project `AGENTS.md` or a decision it links |
| `PUBLIC_CONTRACT` | The files that define the public contract, which a plan fixes first | Project `AGENTS.md` |
| `PLAN_LOCATION` | Where a plan is written | Project `AGENTS.md`, "Planning" |
| `SPEC_LOCATION` | Where a brainstorming spec is saved and how it is linked | Project `AGENTS.md` |
| `SIZE_LIMITS` | The diff-size budget for one change, one slice and one task | Project `AGENTS.md` |
| `DESIGN_BRIEF_STEP` | Whether user-interface work goes through a design-brief step, and which skill runs it | Project `AGENTS.md` or a frontend template layer |
| `LEDGER_LOCATION` (new) | Where the ledger of the plan's tasks is kept. Default: the same place as the plan (`PLAN_LOCATION`): one comment edited in place, or a small file next to the plan. With neither, the skill stops and asks | Project `AGENTS.md` |
| `TRACKER` (new) | The ticket tracker: its name, fields, status names and what each status requires. Suggested values once the project names its GitHub Project: statuses Backlog, Shaping, Ready, In progress, In review, Done and fields Type, Stage/Milestone and Size. Nothing moves to Ready without acceptance criteria, tests and an estimate. Missing means stop and ask | Project `AGENTS.md` |

The extension-points document, [`plugins/agent-kit/extension-points.md`](../../plugins/agent-kit/extension-points.md), holds the defaults and examples.

### 2. The ledger

Every implementation task keeps a ledger, in every mode and for every stack: a short record of the plan's tasks, each with its done criterion, status (`TODO`, `IN_PROGRESS`, `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`), branch and commits, planned against actual size, checks run, decisions made without asking and noticed items. A resuming agent reads it first. A task is `DONE` only with fresh check results recorded. It is a record, not an approval: it never widens a task.

It lives in the `guardrails` skill, which is preloaded into the implementer agent. The idea is inspired by upstream's `subagent-driven-development` progress ledger and is written fresh, so it carries no MIT header and needs no change to the notice's "Derived" list (0003, section 5). There is one writer at a time (the implementer); others read, because two agents editing one comment would overwrite each other. This replaces 0003's wording that "the implementer agent adopts status codes and a ledger".

### 3. The tracker

GitHub Projects hold the tickets. Skills move tickets only through `TRACKER`. A dependency on another repository is recorded as "blocked by owner/repo#n" in the issue body and listed in the plan, and may also be tracked in a cross-repository Project. Whether a repository also has its own board is the project's choice, and `TRACKER` names it. GitHub's built-in workflows set an item's Status to Done when the item is closed or its pull request is merged; the other statuses follow the `TRACKER` rules. Setting up the Projects is a separate step, outside the kit.

### 4. Resolved from 0003's "Unverified"

- The FastAPI layer's migration tool is Alembic (`make migration name="..."`, `make migrate`), read from house-template-fastapi on 6 November 2026.
- The .NET test-filter syntax under Microsoft.Testing.Platform is **still unverified**; the extension-points document marks the example.

## Consequences

- Every project's `AGENTS.md` should name `LEDGER_LOCATION` (or accept the default) and `TRACKER`; until a project names `TRACKER`, skills that move tickets stop and ask.
- Later pull requests of issue #7 (`pair-tdd`, `autonomous-tdd`, the verifier and reviewer wiring) update or check the ledger.
- 0003 is marked partly superseded; a reader of 0003 section 2 must follow the link here for the current list.

**Revisit when:** several agents need to write the ledger at once; a tracker other than GitHub Projects is used; or GitHub changes how Projects statuses and built-in workflows work.

## Alternatives considered

- **Edit 0003 in place:** rejected, because accepted records are not rewritten ([0001](0001-record-decisions.md)).
- **Keep the ledger in the implementer agent only:** rejected, because `pair-tdd` and `autonomous-tdd` need the same rule, and the skill is the one place all three read.
- **No `TRACKER` point; skills assume GitHub Projects:** rejected, because a project without it would get guesses instead of a question.

## Sources

- Issue #7, founder decisions of 6 November 2026: https://github.com/olaheavy-dev/agent-kit/issues/7
- GitHub Docs, built-in automations for Projects, read 6 November 2026: https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/using-the-built-in-automations
- GitHub Docs, about Projects, read 6 November 2026: https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects
- obra/superpowers `subagent-driven-development` at commit `22f0b463e7a5e579904dd6211a520321035526f7`, the idea only: https://github.com/obra/superpowers/tree/22f0b463e7a5e579904dd6211a520321035526f7/skills/subagent-driven-development
- house-template-fastapi (Alembic migration targets), read 6 November 2026: https://github.com/olaheavy-dev/house-template-fastapi
