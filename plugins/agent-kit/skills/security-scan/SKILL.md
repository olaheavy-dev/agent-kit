---
name: security-scan
description: Scan the repository for leaked secrets, insecure GitHub Actions workflows and known-vulnerable dependencies with gitleaks, zizmor and OSV-Scanner, and report findings by severity. Use when asked for a security scan or audit, before an owner-only merge, or after changing workflows or dependencies.
when_to_use: Security scan, secrets check, vulnerable dependencies, workflow audit, "is this safe to merge", supply chain.
allowed-tools: Bash(uvx *) Bash(docker run *) Bash(git ls-files *)
---

# Security scan

Run each scanner the repository can use, then report findings most serious first with file, line, what's wrong and the fix. Don't change code: findings go back to the implementer or the owner.

```bash
# Secrets in the working tree and history (gitleaks, through pre-commit's pinned hook)
pre-commit run gitleaks --all-files

# GitHub Actions workflows, strictest persona
uvx zizmor@1.31.1 --persona=auditor .github/workflows

# Known vulnerabilities in every lockfile the repository has (OSV-Scanner, image pinned to a release)
docker run --rm -v "$PWD:/src" ghcr.io/google/osv-scanner:v2.7.0 scan source -r /src
```

- Use the versions the project pins where it pins them (`.pre-commit-config.yaml`, workflows). Check the tool's documentation for the current flags rather than relying on memory.
- A finding in a dependency only the template's tooling uses (for example a demo tool) is still a finding; say where the dependency is used so the owner can judge the risk.
- Report what each scanner covered and what it couldn't (for example no lockfile found), so a clean result isn't over-read.
