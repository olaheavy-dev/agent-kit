---
name: pr-review-loop
description: The procedure for taking a pull request through review - collect every unresolved comment, fix with regression tests, push once, confirm the commit landed, reply and resolve each thread, request one re-review, and fall back to a fresh-context reviewer when the external reviewer is stuck. Use when asked to address, fix, answer or follow up review comments or bot findings on a pull request.
when_to_use: Review comments, Codex findings, "address the review", "reply to the comments", "is the review done", a re-review that seems stuck.
allowed-tools: Bash(gh pr view *) Bash(gh pr checks *) Bash(gh pr diff *) Bash(gh api repos/*/pulls/*/comments*) Bash(git status) Bash(git log *) Bash(git rev-parse *)
---

# Pull request review loop

The project's `AGENTS.md` ("When reviewing", "Review rounds and debt", "When merging") sets the rules; this is the procedure. Replies and pushes are visible to others, so every claim in a reply must be true when it is posted.

## 1. Collect what is open

```bash
R=$(gh repo view --json nameWithOwner -q .nameWithOwner); N=$(gh pr view --json number -q .number)
gh api "repos/$R/pulls/$N/comments" --paginate \
  --jq '.[] | select(.in_reply_to_id == null) | "\(.id) | \(.path):\(.line // .original_line) | \(.user.login)\n\(.body)\n---"'
gh api graphql -f query="{repository(owner:\"${R%/*}\",name:\"${R#*/}\"){pullRequest(number:$N){reviewThreads(first:100){nodes{id isResolved comments(first:1){nodes{databaseId}}}}}}}"
```

Skip threads that are resolved. A comment whose `in_reply_to_id` is set is a reply, not a finding.

## 2. Decide each finding

Read the code the comment points at, its callers and its tests; line numbers refer to the reviewed commit, so find the code by content. Reproduce the failure before fixing it.

| Verdict | Action |
| --- | --- |
| Valid | Fix it with a regression test that fails without the fix |
| Partly valid | Fix the real part; say what was left and why |
| Already addressed | Point to the code or commit |
| Wrong | No change; reply with evidence and flag it for the owner |

When a guard keeps yielding new bypasses, prefer an allow-list over another blocklist entry: refuse what you can't positively judge.

## 3. Push once, then confirm before replying

```bash
make check && git push
git log --oneline -1 && git status -sb | head -1   # the commit exists and the branch is in sync
```

Only after the commit is confirmed on the remote, reply in each thread naming that commit, then resolve the thread:

```bash
gh api "repos/$R/pulls/$N/comments/<comment-id>/replies" -f body="Fixed in <sha>: <what changed and how it was tested>."
gh api graphql -f query='mutation{resolveReviewThread(input:{threadId:"<thread-id>"}){thread{isResolved}}}'
```

Never chain a reply after a command that can fail without stopping the chain: a reply that names a commit which doesn't contain the fix has to be corrected publicly.

## 4. Request one re-review and wait

```bash
gh pr comment "$N" --body "@codex review"
```

Wait in the background with long intervals for the review status on the new head commit and for every check to finish; don't poll in short loops.

## 5. When the external reviewer is stuck

If the review stays "running" for well over its usual time (about 30 minutes), trigger it once more. If it is still stuck and the owner agrees, run the `reviewer` agent in a fresh context on the commits the external reviewer hasn't seen, and post its report as one PR comment headed "Fallback review (external reviewer unavailable)". Every later fix commit gets a fixes-only re-review before merging.

## 6. Merge

Merge only when the latest commit is reviewed clean, every thread is resolved and every check has passed, and the pull request isn't on the owner-only list (or the owner has approved it). Squash-merge with `--match-head-commit` so nothing unreviewed slips in.
