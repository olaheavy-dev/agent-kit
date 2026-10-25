# Owned by agent-kit (not a template layer). Adds plugin validation to make check and make check-fast.
CLAUDE_CODE_VERSION := 2.1.310

CHECKS += check-plugin
FAST_CHECKS += check-plugin

.PHONY: check-plugin eval-plugin

check-plugin: ## Validate the plugin and the marketplace with Claude Code's own validator
	npx --yes "@anthropic-ai/claude-code@$(CLAUDE_CODE_VERSION)" plugin validate ./plugins/agent-kit
	npx --yes "@anthropic-ai/claude-code@$(CLAUDE_CODE_VERSION)" plugin validate .

eval-plugin: ## Run the plugin's eval suite (real model calls on your account; capped at $$10)
	cd plugins/agent-kit && npx --yes "@anthropic-ai/claude-code@$(CLAUDE_CODE_VERSION)" plugin eval . \
		--max-cost-usd 10 --no-publish
