# Extension points

The agent-kit skills and agents are stack-neutral ([decision 0003](https://github.com/olaheavy-dev/agent-kit/blob/main/docs/decisions/0003-stack-neutral-kit.md); the list of eleven points is in [decision 0004](https://github.com/olaheavy-dev/agent-kit/blob/main/docs/decisions/0004-eleven-extension-points-ledger-and-tracker.md)). Where a skill needs something that depends on the stack or the project, it names an **extension point** in capitals, and the project or its template layer supplies the value.

This file sits at the root of the plugin folder so it travels with every installed copy: Claude Code copies only the plugin folder into its cache, and files outside it are not copied ([plugin loading, "In-place and copied plugins"](https://code.claude.com/docs/en/plugins/loading.md), read 6 November 2026). Skills and the implementer agent refer to it as `${CLAUDE_PLUGIN_ROOT}/extension-points.md`, a variable Claude Code substitutes in plugin skills ([skills reference](https://code.claude.com/docs/en/skills), read 6 November 2026). Agent file content is documented as substituted the same way; whether the variable is also substituted inside a skill that is preloaded into an agent through `skills:` is **unverified**, so each skill also says in words where this file is and gives its GitHub URL as a last fallback: https://github.com/olaheavy-dev/agent-kit/blob/main/plugins/agent-kit/extension-points.md.

## The rules

1. **Precedence: project over template over kit.** A value in the project's `AGENTS.md` wins over a template layer's `.claude/rules/` file, which wins over the default in this file. `STOP_AND_ASK` is the one additive point: a project list adds to the kit baseline instead of replacing it.
2. **A missing extension point means stop and ask.** If a skill needs a value that nothing supplies (no project value, no template value, and no default below), it stops and asks the owner. It never guesses a command, a folder or a limit.
3. **Say where you looked.** When a skill uses a value, or stops because it is missing, it names the file it read.

## The eleven points

| Point | What it answers | Kit default | Usually supplied by | If missing |
| --- | --- | --- | --- | --- |
| `RUN_CHECK` | The one command that runs every check before pushing | None | Project `AGENTS.md`, "Commands" | Stop and ask before reporting done |
| `TEST_CONVENTIONS` | Where tests live, how they are named, how to run one test or one file, the **preflight** (what must be running first, for example Docker or a database), and the test-first rules for the stack | None | Template layer rule file `.claude/rules/test-conventions.md` | Stop and ask; never guess a test command (not even `pytest -k`) |
| `STOP_AND_ASK` | Situations where the agent must stop and ask the owner | The baseline list in the `guardrails` skill (migration or schema change not already approved in the plan, deleting code or tests, public contract change not in the plan, adding or upgrading any package, auth or shared-code behaviour change, ambiguity). A project list **adds** to it | Project `AGENTS.md`, "Rules for every agent" and "When building" | Use the baseline list |
| `APPROVED_PACKAGES` | Dependencies that may be added without asking (a major upgrade of one still stops) | Empty: ask for every one | Project `AGENTS.md` or a decision it links | Ask for every package |
| `PUBLIC_CONTRACT` | Files that define the public contract (schemas, API description, generated types), which a plan fixes first | None | Project `AGENTS.md` | Stop and ask before a change that could touch a contract |
| `PLAN_LOCATION` | Where a plan is written (for example the GitHub issue) | None | Project `AGENTS.md`, "Planning" | Stop and ask |
| `SPEC_LOCATION` | Where a brainstorming spec is saved and how it is linked from the issue | None | Project `AGENTS.md` | Stop and ask |
| `SIZE_LIMITS` | The diff-size budget for one change, one slice and one task | More than 50% over the plan's estimate (lines or files) stops; a task over about 300 changed lines stops to ask whether to split it; no default limit for a slice | Project `AGENTS.md` | Use the kit default |
| `DESIGN_BRIEF_STEP` | Whether user-interface work goes through a design-brief step before planning, and which skill runs it | None | Project `AGENTS.md`, or a frontend template layer | Stop and ask when the work touches a user interface |
| `LEDGER_LOCATION` | Where the ledger of the plan's tasks is kept | The same place as the plan (`PLAN_LOCATION`): one comment edited in place, or a small file next to the plan | Project `AGENTS.md` | Use `PLAN_LOCATION`; with neither, stop and ask |
| `TRACKER` | The ticket tracker: its name, fields, status names and what each status requires | Suggested values once the project names its GitHub Project: statuses Backlog, Shaping, Ready, In progress, In review, Done; fields Type (feature, task, bug, decision, noticed, review-followup), Stage/Milestone and Size. Nothing moves to Ready without acceptance criteria, tests and an estimate | Project `AGENTS.md` | Stop and ask; never move a ticket another way |

Three points (`STOP_AND_ASK`, `SIZE_LIMITS`, `LEDGER_LOCATION`) have a usable default, so a missing project value does not block work. The `guardrails` skill uses `RUN_CHECK`, `TEST_CONVENTIONS`, `STOP_AND_ASK`, `APPROVED_PACKAGES`, `PUBLIC_CONTRACT`, `PLAN_LOCATION`, `SIZE_LIMITS`, `LEDGER_LOCATION` and `TRACKER`. `SPEC_LOCATION` and `DESIGN_BRIEF_STEP` are used by the planning skills that later pull requests add.

The size rule in numbers: the counting commands are in the `guardrails` skill. The diff is counted against the merge base, with untracked files included and plan and spec documents excluded.

## Examples

These show what a value can look like. They are examples, not defaults.

### FastAPI layer (house-template-fastapi: Python, pytest, uv, PostgreSQL)

Checked against the layer's `README.md`, `template/.claude/rules/fastapi.md.jinja` and `template/mk/fastapi.mk.jinja` on 6 November 2026.

| Point | Example value |
| --- | --- |
| `RUN_CHECK` | `make check` (the layer adds ruff, mypy, import-linter and pytest to it) |
| `TEST_CONVENTIONS` | Tests under `backend/tests/`, files `test_*.py`, async tests whose names are sentences (`test_a_protected_route_needs_a_user`). All tests: `make test`. One file: `uv --directory backend run --locked pytest tests/test_auth.py`. One test: `uv --directory backend run --locked pytest tests/test_auth.py::test_a_protected_route_needs_a_user`. Preflight: Docker is running, because database tests start PostgreSQL with testcontainers (or set `TEST_DATABASE_URL` to a database you provide); storage tests (storage extra only) start RustFS with testcontainers, so they also need Docker (`make storage-up` is for local development). If Docker is down, do not run the database tests and ask before starting anything |
| `STOP_AND_ASK` | The baseline list, plus "a new Alembic migration" and "changing the `/v1` router's public routes" |
| `APPROVED_PACKAGES` | A short list in `AGENTS.md`, or "none: ask for every one" (the layer's rule: add to `backend/pyproject.toml`, run `make lock`, commit both) |
| `PUBLIC_CONTRACT` | The `/v1` routes and their Pydantic models in `backend/src/app/api/`. The template commits no `openapi.json`; FastAPI serves it from the running app |
| `PLAN_LOCATION` | The GitHub issue, in the "Task" form |
| `SPEC_LOCATION` | `docs/specs/<issue-number>-<topic>.md`, linked from the issue |
| `SIZE_LIMITS` | The kit default, or a stricter project number |
| `DESIGN_BRIEF_STEP` | "None: this layer has no user interface" |
| `LEDGER_LOCATION` | The default (a comment on the plan's issue, edited in place) |
| `TRACKER` | The GitHub Project of the repository, with the default statuses and fields |

Migrations: the layer uses Alembic (`make migration name="..."` writes a revision on the `app` branch, `make migrate` applies `alembic upgrade heads`), so a schema change is a reviewed migration.

### .NET layer (C#, Docker Compose)

| Point | Example value |
| --- | --- |
| `RUN_CHECK` | `make check` |
| `TEST_CONVENTIONS` | Tests in a `test/` project, named `Method_condition_result`. One test or a group of tests, for NUnit or MSTest under Microsoft.Testing.Platform: `dotnet test --project <csproj> --filter "FullyQualifiedName~<name>"`. **UNVERIFIED, check per SDK version:** xUnit uses other options, and the exact syntax depends on the SDK in `global.json` and on how the runner is set up. Preflight: `docker ps` lists each container the integration tests need |
| `STOP_AND_ASK` | The baseline list, plus "touching shared kernel code" |
| `APPROVED_PACKAGES` | A short list in `AGENTS.md` or a decision it links |
| `PUBLIC_CONTRACT` | The API description file and the generated client types |
| `PLAN_LOCATION` | The GitHub issue |
| `SPEC_LOCATION` | `docs/specs/<issue-number>-<topic>.md` |
| `SIZE_LIMITS` | The kit default, or a stricter project number |
| `DESIGN_BRIEF_STEP` | "None" for a backend-only project |
| `LEDGER_LOCATION` | The default |
| `TRACKER` | The repository's GitHub Project |

## For layer and project authors

- Put `RUN_CHECK`, `STOP_AND_ASK`, `APPROVED_PACKAGES`, `PUBLIC_CONTRACT`, `PLAN_LOCATION`, `SPEC_LOCATION`, `SIZE_LIMITS`, `DESIGN_BRIEF_STEP`, `LEDGER_LOCATION` and `TRACKER` under clear headings in `AGENTS.md`, using the point's name in the heading or the first sentence so it can be found by search.
- Put `TEST_CONVENTIONS` (including the preflight) in the layer's `.claude/rules/test-conventions.md`.
- Until a layer ships `test-conventions.md`, the skills stop and ask whenever they need to run a test.
- GitHub Projects hold the tickets (whether the repository has its own board is named in `TRACKER`). A dependency on another repository is recorded as "blocked by owner/repo#n" in the issue body and listed in the plan.
