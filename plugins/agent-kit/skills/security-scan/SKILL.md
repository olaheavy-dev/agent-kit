---
name: security-scan
description: Check a repository for leaked secrets (including in git history), risky GitHub Actions workflows and dependencies with known vulnerabilities, using gitleaks, zizmor and OSV-Scanner, and report findings by severity. Use whenever someone asks to check for secrets, audit workflows, look for vulnerable dependencies, or confirm a change is safe to merge.
when_to_use: Leaked secrets or API keys, "check before I merge", security scan or audit, risky or insecure workflows, GitHub Actions security, vulnerable or outdated dependencies, CVEs, supply chain.
allowed-tools: Bash(uvx *) Bash(docker run *) Bash(git ls-files *)
---

# Security scan

Run each scanner the repository can use, then report findings most serious first with file, line, what's wrong and the fix. Don't change code: findings go back to the implementer or the owner.

```bash
# Secrets in every commit, including ones deleted since, and in the working tree. Not through the
# pre-commit hook: it scans only staged changes (--staged), so it finds nothing on a clean checkout.
docker run --rm -v "$PWD:/repo" ghcr.io/gitleaks/gitleaks:v8.30.1 git /repo --redact --no-banner
docker run --rm -v "$PWD:/repo" ghcr.io/gitleaks/gitleaks:v8.30.1 dir /repo --redact --no-banner

# GitHub Actions workflows, strictest persona
uvx zizmor@1.31.1 --persona=auditor .github/workflows

# Known vulnerabilities in every lockfile the repository has (OSV-Scanner, image pinned to a release)
docker run --rm -v "$PWD:/src" ghcr.io/google/osv-scanner:v2.7.0 scan source -r /src
```

- Use the versions the project pins where it pins them (gitleaks matches `.pre-commit-config.yaml`; zizmor matches the workflows). Check the tool's documentation for the current flags rather than relying on memory.
- A finding in a dependency only the template's tooling uses (for example a demo tool) is still a finding; say where the dependency is used so the owner can judge the risk.
- Report what each scanner covered and what it couldn't (for example no lockfile found), so a clean result isn't over-read. A secret found only in history is still live until it's rotated: removing the file doesn't revoke it.
