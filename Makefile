# Dotfiles Makefile - Minimal
.PHONY: help install uninstall backup restore update sync lint pre-commit clean check

DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(HOME)/.dotfiles.backup.$(shell date +%Y%m%d_%H%M%S)
STOW := stow

help: ## Show help
	@echo "Usage: make <command>"
	@echo ""
	@grep -E '^[a-z-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

install: ## Create symlinks
	@$(STOW) -t ~ .
	@echo "✓ Done. Run: source ~/.zshrc"

uninstall: ## Remove symlinks
	@$(STOW) -D -t ~ .

backup: ## Backup existing configs
	@mkdir -p $(BACKUP_DIR)
	@for i in .config/hypr .config/nvim .config/waybar .zshrc; do \
		[[ -e "$(HOME)/$$i" ]] && cp -r "$(HOME)/$$i" "$(BACKUP_DIR)/" 2>/dev/null || true; \
	done
	@echo "✓ Backup: $(BACKUP_DIR)"

restore: ## Restore from backup (usage: make restore BACKUP_DIR=...)
	@if [[ -z "$(BACKUP_DIR)" ]]; then echo "Specify BACKUP_DIR=..."; exit 1; fi
	@for i in .config/hypr .config/nvim .config/waybar .zshrc; do \
		[[ -e "$(BACKUP_DIR)/$$i" ]] && cp -r "$(BACKUP_DIR)/$$i" "$(HOME)/" 2>/dev/null || true; \
	done
	@echo "✓ Restored"

update: ## Git pull
	@git pull --rebase
	@echo "✓ Updated. Run 'make install' to apply"

sync: update install ## Update + install

lint: pre-commit ## Run linting (alias)

pre-commit: ## Run pre-commit checks
	@./scripts/pre-commit-check.sh

clean: ## Clean cache
	@rm -rf .cache/* 2>/dev/null || true
	@find . -name "*.swp" -delete 2>/dev/null || true
	@echo "✓ Cleaned"

check: ## Check symlink status
	@echo "Checking symlinks..."
	@for i in .zshrc .config/hypr .config/nvim .config/waybar; do \
		if [[ -L "$(HOME)/$$i" ]]; then \
			target=$$(readlink "$(HOME)/$$i"); \
			echo "✓ $$i → $$target"; \
		elif [[ -e "$(HOME)/$$i" ]]; then \
			echo "! $$i (exists, not symlink - may overwrite)"; \
		else \
			echo "× $$i (missing - run 'make install')"; \
	fi; \
	done
	@echo ""
	@echo "Tip: Run 'make install' to create missing symlinks"
