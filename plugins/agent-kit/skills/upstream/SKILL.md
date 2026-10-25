---
name: upstream
description: Carry a generic improvement from this project up to the template layer that owns the file, as a pull request on the template repository. Use when a merged pull request is labelled template-candidate or changed a template-owned file.
argument-hint: "[pull request number]"
disable-model-invocation: true
---

# Carry an improvement upstream

Opens a pull request on another repository, so it runs only when the owner asks (`/agent-kit:upstream <pr>`).

1. **Find what changed and who owns it.** Read pull request `$ARGUMENTS` (`gh pr view $ARGUMENTS --json files,title,body`). Match each changed path against `.github/template-owned/<layer>.txt`; the layer's repository is `_src_path` in `.copier-answers.<layer>.yml`.
2. **Decide what is generic.** Keep only what every project of that layer should get. Leave out project names, domains, secrets, figures and anything specific to this product. If nothing is generic, say so and stop.
3. **Make the change in the template.** Clone the layer repository, branch `feat/upstream-<short-name>`, and apply the change to the template source (files under `template/`, with Jinja where values come from answers). Add or update the template's tests so the improvement is checked in every generated project.
4. **Prove it.** Run the template's tests (`uv run pytest`), and render a project and run its checks as the template's CI does.
5. **Open the pull request** on the template repository with a Conventional Commit title, a description that links the project PR it came from, and how it was tested. Follow that repository's `AGENTS.md` and review loop.
6. **Close the loop.** Comment on the project PR with the template PR's link. After the template releases, the project's weekly template update brings the change back.
