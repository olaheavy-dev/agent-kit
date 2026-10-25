# agent-kit

A Claude Code plugin marketplace with the shared coding-agent kit for my projects. Projects generated from [house-template-base](https://github.com/olaheavy-dev/house-template-base) turn it on in `.claude/settings.json`; each project's `AGENTS.md` is the rulebook the agents follow.

## Install

```text
/plugin install agent-kit --marketplace olaheavy-dev/agent-kit
```

Or declare it for a repository in `.claude/settings.json`, as the template does:

```json
{
  "extraKnownMarketplaces": { "olaheavy-dev": { "source": { "source": "github", "repo": "olaheavy-dev/agent-kit" } } },
  "enabledPlugins": { "agent-kit@olaheavy-dev": true }
}
```

## What's in it

| Agent | Model | Does | Can't |
| --- | --- | --- | --- |
| `agent-kit:planner` | Opus | Plans a change with acceptance criteria, each with its test, and sources | Edit files |
| `agent-kit:implementer` | Sonnet | Builds one planned issue in its own worktree, with tests, and runs `make check` | Push to main |
| `agent-kit:verifier` | Sonnet | Runs every check and maps each criterion to a named test | Edit files |
| `agent-kit:reviewer` | Opus | Fresh-context pre-push review, reproducing each finding, trying to get past guards; also the fallback review | Edit files |
| `agent-kit:deep-reviewer` | Fable | The same for owner-only and stage-gate changes, tracing effects on live systems and reversibility | Edit files |
| `agent-kit:review-handler` | Opus | Works review comments through the review rounds with the `pr-review-loop` skill | Merge owner-only PRs |

| Skill | Invoked by | Does |
| --- | --- | --- |
| `agent-kit:pr-review-loop` | Claude or you | Collect comments, fix with regression tests, push once, confirm the commit landed, reply and resolve, request one re-review, fall back when the reviewer is stuck |
| `agent-kit:test-first` | Claude or you | Test-first work for money, rounding, dates, rules and guards |
| `agent-kit:security-scan` | Claude or you | gitleaks, zizmor and OSV-Scanner, reported by severity |
| `agent-kit:upstream` | You only (it opens a PR elsewhere) | Carry a generic improvement from a project to the template layer that owns the file |

Read-only agents use a tools allow-list and deny `Edit` and `Write`: plugin agents can't set a permission mode or hooks, so the restriction lives in their tools.

## Quality

- `make check` validates the plugin and the marketplace with a pinned Claude Code (`claude plugin validate`), in CI on every pull request.
- `plugins/agent-kit/evals/` holds the eval suite: each case checks that a piece of the kit triggers on natural phrasing (or stays quiet), and how good the result is. Each case is compared with a run without the plugin. `make eval-plugin` runs it with real model calls, capped at $10.

## Licence

Copyright © 2026 Sunkanmi Olawuwo. All rights reserved. Public for portfolio purposes; see [LICENSE](LICENSE).
