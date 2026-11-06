# Extension points

The agent-kit skills and agents are stack-neutral ([decision 0003](https://github.com/olaheavy-dev/agent-kit/blob/main/docs/decisions/0003-stack-neutral-kit.md)). Where a skill needs something that depends on the stack or the project, it names an **extension point** in capitals, and the project or its template layer supplies the value.

This file sits at the root of the plugin folder so it travels with every installed copy: Claude Code copies only the plugin folder into its cache, and files outside it are not copied ([plugin loading, "In-place and copied plugins"](https://code.claude.com/docs/en/plugins/loading.md), read 6 November 2026). Skills refer to it as `${CLAUDE_PLUGIN_ROOT}/extension-points.md`, a variable Claude Code substitutes in plugin skills ([skills reference](https://code.claude.com/docs/en/skills), read 6 November 2026). Whether the variable is also substituted when a skill is preloaded into an agent through `skills:` is **unverified**; each skill therefore also says in words where this file is.

## The rules

1. **Precedence: project over template over kit.** A value in the project's `AGENTS.md` wins over a template layer's `.claude/rules/` file, which wins over the default in this file.
2. **A missing extension point means stop and ask.** If a skill needs a value that nothing supplies (no project value, no template value, and no default below), it stops and asks the owner. It never guesses a command, a folder or a limit.
3. **Say where you looked.** When a skill uses a value, or stops because it is missing, it names the file it read.

## The nine points

| Point | What it answers | Kit default | Usually supplied by | If missing |
| --- | --- | --- | --- | --- |
| `RUN_CHECK` | The one command that runs every check before pushing | None | Project `AGENTS.md`, "Commands" | Stop and ask before reporting done |
| `TEST_CONVENTIONS` | Where tests live, how they are named, how to run one test or one file, the preflight (services that must be up), and the test-first rules for the stack | None | Template layer rule file `.claude/rules/test-conventions.md` | Stop and ask; never guess a test command |
| `STOP_AND_ASK` | Situations where the agent must stop and ask the owner | The baseline list in the `guardrails` skill (unapproved schema or migration, deleting code or tests, unplanned public contract change, unapproved package, auth or shared-code behaviour change, ambiguity). A project list adds to it | Project `AGENTS.md`, "Rules for every agent" and "When building" | Use the baseline list |
| `APPROVED_PACKAGES` | Dependencies that may be added without asking | Empty: ask for every one | Project `AGENTS.md` or a decision it links | Ask for every package |
| `PUBLIC_CONTRACT` | Files that define the public contract (schemas, API description, generated types), which a plan fixes first | None | Project `AGENTS.md` | Stop and ask before a change that could touch a contract |
| `PLAN_LOCATION` | Where a plan is written (for example the GitHub issue) | None | Project `AGENTS.md`, "Planning" | Stop and ask |
| `SPEC_LOCATION` | Where a brainstorming spec is saved and how it is linked from the issue | None | Project `AGENTS.md` | Stop and ask |
| `SIZE_LIMITS` | The diff-size budget for one change and for one slice | 50% over the plan's estimate in lines or files, and about 300 lines per task | Project `AGENTS.md` | Use the kit default |
| `DESIGN_BRIEF_STEP` | Whether user-interface work goes through a design-brief step before planning, and which skill runs it | None | Project `AGENTS.md`, or a frontend template layer | Stop and ask when the work touches a user interface |

Two points (`STOP_AND_ASK`, `SIZE_LIMITS`) have a usable default, so a missing project value does not block work. The `guardrails` skill uses `RUN_CHECK`, `TEST_CONVENTIONS`, `STOP_AND_ASK`, `APPROVED_PACKAGES`, `PUBLIC_CONTRACT`, `PLAN_LOCATION` and `SIZE_LIMITS`. `SPEC_LOCATION` and `DESIGN_BRIEF_STEP` are used by the planning skills that later pull requests add.

## Examples

These show what a value can look like. They are examples, not defaults.

### FastAPI layer (Python, pytest, uv, Docker Compose)

| Point | Example value |
| --- | --- |
| `RUN_CHECK` | `make check` |
| `TEST_CONVENTIONS` | Tests under `tests/`, files `test_*.py`, functions `test_<method>_<condition>_<result>`. One test: `uv run pytest tests/test_orders.py::test_create_order_missing_item_returns_422`. One file: `uv run pytest tests/test_orders.py`. By name: `uv run pytest -k create_order`. Preflight: `docker compose ps` lists the `db` service as running; if it is down, do not run integration tests and ask before `docker compose up` |
| `STOP_AND_ASK` | The baseline list, plus "changing the legacy `/v1` routes" |
| `APPROVED_PACKAGES` | A short list in `AGENTS.md`, or "none: ask for every one" |
| `PUBLIC_CONTRACT` | `openapi.json` and the Pydantic schemas it is generated from |
| `PLAN_LOCATION` | The GitHub issue, in the "Task" form |
| `SPEC_LOCATION` | `docs/specs/<issue-number>-<topic>.md`, linked from the issue |
| `SIZE_LIMITS` | "Stop at 50% over the estimate; about 300 lines per task" (the kit default, restated) |
| `DESIGN_BRIEF_STEP` | "None: this layer has no user interface" |

The migration tool (and its stop-and-ask wording) for the FastAPI layer is **unverified**; check the layer's own documentation before naming one.

### .NET layer (C#, NUnit or xUnit, Docker Compose)

| Point | Example value |
| --- | --- |
| `RUN_CHECK` | `make check` |
| `TEST_CONVENTIONS` | Tests in a `test/` project, named `Method_condition_result`. One test or a group of tests: `dotnet test <project> --filter "FullyQualifiedName~<name>"` (**UNVERIFIED** under Microsoft.Testing.Platform: the `--filter` syntax and whether `dotnet test` accepts it depend on the SDK version and on how the test runner is set up. Check the official documentation for the SDK version in `global.json` before writing this value into a layer). Preflight: `docker ps` lists each container the integration tests need |
| `STOP_AND_ASK` | The baseline list, plus "adding or changing a database migration" and "touching shared kernel code" |
| `APPROVED_PACKAGES` | A short list in `AGENTS.md` or a decision it links |
| `PUBLIC_CONTRACT` | The API description file and the generated client types |
| `PLAN_LOCATION` | The GitHub issue |
| `SPEC_LOCATION` | `docs/specs/<issue-number>-<topic>.md` |
| `SIZE_LIMITS` | The kit default, or a stricter project number |
| `DESIGN_BRIEF_STEP` | "None" for a backend-only project |

## For layer and project authors

- Put `RUN_CHECK`, `STOP_AND_ASK`, `APPROVED_PACKAGES`, `PUBLIC_CONTRACT`, `PLAN_LOCATION`, `SPEC_LOCATION`, `SIZE_LIMITS` and `DESIGN_BRIEF_STEP` under clear headings in `AGENTS.md`, using the point's name in the heading or the first sentence so it can be found by search.
- Put `TEST_CONVENTIONS` in the layer's `.claude/rules/test-conventions.md`.
- Until a layer ships `test-conventions.md`, the skills stop and ask whenever they need to run a test.
