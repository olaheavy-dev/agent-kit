# 0003. Stack-neutral kit, extension points and third-party notices

Status: Accepted

## Context

The workflow skills in the founder's earlier project kit are stronger than agent-kit on how an agent works inside a session: brainstorming before planning, a choice between pair and autonomous work, phase checkpoints, a diff-size budget and a completeness search. agent-kit is stronger on review and enforcement. The founder decided on 6 November 2026 to port those workflow skills into agent-kit ([issue #7](https://github.com/olaheavy-dev/agent-kit/issues/7)).

Two things make that port harder than a copy:

1. **Project specifics.** The earlier text names one project's commands, folders, test style and limits. agent-kit is shared by every project built from the house template layers ([0002](0002-start-from-house-template.md)), whatever their stack.
2. **Third-party text.** Some of the founder's skills started from [obra/superpowers](https://github.com/obra/superpowers), which is published under the MIT licence. The founder's comparison found that the founder's `brainstorming` and `writing-plans` text matches upstream around v6.4.2. MIT lets us copy and change that text, but only if the copyright and permission notice travel with it. The rest of agent-kit is all rights reserved ([LICENSE](../../LICENSE)).

This record fixes the rules before any skill is ported (pull request 0 of the issue's plan). It adds no skills and changes no plugin files.

## Decision

### 1. The kit stays stack-neutral

agent-kit knows nothing about the template layers (Python, .NET, web or any other) or about any one project. A skill never names a stack's command, folder, tool or test framework. Where it needs one, it refers to a named **extension point**, and the template layer or the project supplies the value.

### 2. Extension points

| Extension point | What it answers | Usually supplied by |
| --- | --- | --- |
| `RUN_CHECK` | The one command that runs every check before pushing (in projects from the base template, `make check`) | Project `AGENTS.md`, "Commands" |
| `TEST_CONVENTIONS` | Where tests live, how they are named, how to run one test or one file, and the test-first rules for that stack | Each template layer, as a path-scoped rule `.claude/rules/test-conventions.md` |
| `STOP_AND_ASK` | The situations where the agent must stop and ask the owner | Project `AGENTS.md` ("Rules for every agent", "When building") |
| `APPROVED_PACKAGES` | Which dependencies may be added without asking (an empty list means "ask for every one") | Project `AGENTS.md` or a decision it links |
| `PUBLIC_CONTRACT` | The files that define the public contract (schemas, API description, generated types) that a plan fixes first | Project `AGENTS.md` |
| `PLAN_LOCATION` | Where a plan is written (for example the GitHub issue) | Project `AGENTS.md`, "Planning" |
| `SPEC_LOCATION` | Where a brainstorming spec is saved, and how it is linked from the issue | Project `AGENTS.md` |
| `SIZE_LIMITS` | The diff-size budget for one change and for one slice | Project `AGENTS.md` |
| `DESIGN_BRIEF_STEP` | Whether user-interface work goes through a design-brief step before planning, and which skill runs it | Project `AGENTS.md` (or a frontend template layer) |

The contract:

- **Precedence: project over template over kit.** A value in the project's `AGENTS.md` wins over a template layer's rule, which wins over any default the kit states.
- **A missing extension point means stop and ask.** If a skill needs a value that neither the project nor a template layer supplies, it stops and asks the owner. It never guesses a command, a folder or a limit.
- The exact wording each skill uses to look up an extension point is set in the extension-points document that pull request 1 of issue #7 adds. This record fixes the names and the rules; that document fixes the lookup.

### 3. The hybrid port

**Port** the founder's own copies, keeping the text as close as possible and replacing project specifics with extension points:

- `brainstorming`, adding upstream v7's "ask why first, fewer questions" and an optional builder check.
- `writing-plans`.
- `pair-tdd` (the founder's `tdd`, renamed so the name says the mode).
- `autonomous-tdd`.
- `guardrails`: the diff-size budget (`SIZE_LIMITS`, with up to 50% over allowed before stopping, and untracked files counted), the completeness search and the final summary format.

**Add, written fresh** with upstream as inspiration: `verification-before-completion` and `systematic-debugging`.

**Keep** `test-first` as the add-on for money, rounding, dates, guards and parsers, and remove from it the laws that `pair-tdd` and `autonomous-tdd` already state. Where they disagree, the stricter rule wins: an unexpected pass on such logic is a hard stop even in autonomous mode.

**Fold into `pr-review-loop`**, written fresh from the ideas in upstream's `receiving-code-review`: "no performative agreement" (don't thank or agree with a finding before checking it) and "verify before changing anything" (reproduce the finding first). The implementer agent adopts status codes and a ledger of what it did.

**Do not adopt** these upstream skills:

| Upstream skill | Why not |
| --- | --- |
| `using-superpowers` (the session-start bootstrap) | Upstream loads it through a SessionStart hook that runs a shell script from the plugin on every start, clear and compact ([hooks.json at the pinned commit](https://github.com/obra/superpowers/blob/22f0b463e7a5e579904dd6211a520321035526f7/hooks/hooks.json)): third-party shell code at session start. It would also sit above the project's rulebook and stop-and-ask rules |
| `subagent-driven-development` | Its own build-and-review loop conflicts with our planner, implementer, verifier and reviewer roles and our model rules (Opus plans and reviews, Sonnet builds) |
| `executing-plans` | Covered by the implementer agent and `autonomous-tdd`; a second way to run a plan would conflict with stop-and-ask |
| `finishing-a-development-branch` | Offers merging and branch clean-up, which our merge rules reserve for the review gate and the owner |
| `using-git-worktrees` | The implementer agent already runs in its own worktree (`isolation: worktree`) |
| `requesting-code-review` | Our pre-push review uses the read-only reviewer agents and the rules in `AGENTS.md`, "When reviewing" |
| `diagnosing-superpowers` | Only useful for the upstream plugin itself |

No new agent replaces planner, implementer, verifier, reviewer, deep-reviewer or review-handler.

### 4. Modes

- The plan **asks pair or autonomous every time**, from the main conversation, before any subagent starts. The founder's working assumption is that subagents can't ask the owner a question through the question tool (see "Unverified").
- With no plan, work defaults to pair mode.
- In autonomous mode each checkpoint is a **separate message in the session**, so the owner can read and stop at any phase.
- Guardrails reach every project through each template's `AGENTS.md`. There is **no SessionStart hook** for now.

### 5. Provenance and licence

- Skills derived from upstream text (`brainstorming`, `writing-plans`) carry an MIT header naming obra/superpowers and its copyright line, and are listed in [`THIRD_PARTY_NOTICES.md`](../../THIRD_PARTY_NOTICES.md) with the full MIT notice.
- `pair-tdd`, `autonomous-tdd` and `guardrails` are believed to be the founder's own. Upstream has a `test-driven-development` skill, so the pull request that ports each of these compares it with upstream and adds the header (and a notice entry) if it finds derived text.
- Skills and rules written fresh with upstream as inspiration (`verification-before-completion`, `systematic-debugging`, the `pr-review-loop` additions) copy no upstream wording and carry no header. If a later change does copy wording, it adds the header and the notice entry in the same pull request.
- Everything else in the repository stays all rights reserved under [LICENSE](../../LICENSE).
- Upstream reference: obra/superpowers commit `22f0b463e7a5e579904dd6211a520321035526f7` (tag v7.0.2, committed 3 November 2026), licence read on 6 November 2026.

### 6. No agent attribution

Commits and pull requests that port these skills carry no `Co-Authored-By` or "generated with" lines, as `AGENTS.md` rule 5 already requires. Upstream credit lives in the notice and the headers, not in commit trailers.

## Consequences

- Every template layer must ship a `.claude/rules/test-conventions.md`, and every project's `AGENTS.md` must give its size limits and the other extension points. Until it does, the skills stop and ask (issue #7, pull request 6).
- The licence position changes: the repository now contains MIT-licensed third-party material alongside all-rights-reserved material, so `THIRD_PARTY_NOTICES.md` and the per-skill headers must be kept up to date. The founder merges this pull request because it changes the licence position (issue #7, pull request 0).
- `test-first` becomes shorter, and the renamed `pair-tdd` is a breaking change for anyone invoking `tdd` by name (issue #7, pull request 2).
- Upstream improvements don't arrive automatically; we compare with a pinned upstream commit when we choose to.

**Revisit when:** a SessionStart hook becomes the only reliable way to deliver guardrails; subagents gain a way to ask the owner a question; a marketplace entry can pin a third-party plugin to a commit (making "install upstream alongside" safer); or upstream changes its licence.

## Alternatives considered

- **Install obra/superpowers as it is**, next to agent-kit: rejected. Its bootstrap runs third-party shell code at session start, its development and merge skills conflict with our stop-and-ask, review, merge and model rules, and we couldn't confirm that a marketplace entry can pin a third-party plugin to a reviewed commit.
- **Port the current upstream (v7.0.2) text instead of the founder's copies**: rejected. The founder's copies already fit the way we work, and a fresh port would bring in more upstream text (and more to keep in step) for little gain. Two v7 ideas are taken on purpose instead (section 3).
- **Use only the earlier kit's text**, with no upstream additions: rejected. It has no verification-before-completion or systematic-debugging step, and it would still need the third-party notice because two of its skills derive from upstream.

## Unverified

- Whether the question tool (AskUserQuestion) works inside subagents and inside `claude plugin eval` runs. This decides how the pair-or-autonomous evals are written.
- Whether a marketplace entry can pin a third-party plugin to a commit.
- Which parts of the founder's `brainstorming` and `writing-plans` text are derived from upstream, and exactly which upstream version: the comparison dated them to around v6.4.2, and that has not been rechecked line by line.

## Sources

- Issue #7, "Decisions" (founder, 6 November 2026): https://github.com/olaheavy-dev/agent-kit/issues/7
- obra/superpowers licence (MIT, "Copyright (c) 2025 Jesse Vincent"), read 6 November 2026: https://github.com/obra/superpowers/blob/main/LICENSE (identical at the pinned commit: https://raw.githubusercontent.com/obra/superpowers/22f0b463e7a5e579904dd6211a520321035526f7/LICENSE)
- obra/superpowers commit 22f0b46 ("Release v7.0.2"), read 6 November 2026: https://github.com/obra/superpowers/commit/22f0b463e7a5e579904dd6211a520321035526f7 (the `v7.0.2` tag points to this commit)
- obra/superpowers skills folder at the pinned commit (names of the skills not adopted): https://github.com/obra/superpowers/tree/22f0b463e7a5e579904dd6211a520321035526f7/skills
