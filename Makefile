# ═══════════════════════════════════════════════════════════════════════════════
# Dotfiles Makefile
# ═══════════════════════════════════════════════════════════════════════════════
# Usage: make <target>
# ═══════════════════════════════════════════════════════════════════════════════

.PHONY: help install uninstall backup restore update sync lint pre-commit clean check

# ── Configuration ──────────────────────────────────────────────────────────────
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(HOME)/.dotfiles.backup.$(shell date +%Y%m%d_%H%M%S)
STOW := stow

# Colors
GREEN := \033[0;32m
CYAN := \033[0;36m
NC := \033[0m

# ── Help ───────────────────────────────────────────────────────────────────────
help: ## Show this help message
	@echo "Usage: make $(GREEN)<target>$(NC)"
	@echo ""
	@grep -E '^[a-z-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-15s$(NC) %s\n", $$1, $$2}'

# ── Installation ───────────────────────────────────────────────────────────────
install: ## Create symlinks for all dotfiles
	@echo -e "$(CYAN)→$(NC) Creating symlinks..."
	@$(STOW) -t ~ .
	@echo -e "$(GREEN)✓$(NC) Done. Run: source ~/.zshrc"

uninstall: ## Remove symlinks
	@echo -e "$(CYAN)→$(NC) Removing symlinks..."
	@$(STOW) -D -t ~ .
	@echo -e "$(GREEN)✓$(NC) Symlinks removed"

# ── Backup & Restore ───────────────────────────────────────────────────────────
backup: ## Backup existing configurations
	@mkdir -p $(BACKUP_DIR)
	@for i in .config/hypr .config/nvim .config/waybar .zshrc; do \
		[[ -e "$(HOME)/$$i" ]] && cp -r "$(HOME)/$$i" "$(BACKUP_DIR)/" 2>/dev/null || true; \
	done
	@echo -e "$(GREEN)✓$(NC) Backup: $(BACKUP_DIR)"

restore: ## Restore from backup (usage: make restore BACKUP_DIR=...)
	@if [[ -z "$(BACKUP_DIR)" ]]; then \
		echo "Specify BACKUP_DIR=..."; exit 1; \
	fi
	@for i in .config/hypr .config/nvim .config/waybar .zshrc; do \
		[[ -e "$(BACKUP_DIR)/$$i" ]] && cp -r "$(BACKUP_DIR)/$$i" "$(HOME)/" 2>/dev/null || true; \
	done
	@echo -e "$(GREEN)✓$(NC) Restored from $(BACKUP_DIR)"

# ── Updates ────────────────────────────────────────────────────────────────────
update: ## Pull latest changes from git
	@git pull --rebase
	@echo -e "$(GREEN)✓$(NC) Updated. Run 'make install' to apply"

sync: update install ## Update + install (git pull + symlinks)

# ── Linting ────────────────────────────────────────────────────────────────────
lint: pre-commit ## Run all linting checks

pre-commit: ## Run pre-commit checks
	@./scripts/pre-commit-check.sh

# ── Maintenance ────────────────────────────────────────────────────────────────
clean: ## Clean cache and temporary files
	@rm -rf .cache/* 2>/dev/null || true
	@find . -name "*.swp" -delete 2>/dev/null || true
	@find . -name "*~" -delete 2>/dev/null || true
	@echo -e "$(GREEN)✓$(NC) Cleaned"

check: ## Check symlink status
	@echo "Checking symlinks..."
	@for i in .zshrc .config/hypr .config/nvim .config/waybar; do \
		if [[ -L "$(HOME)/$$i" ]]; then \
			target=$$(readlink "$(HOME)/$$i"); \
			echo -e "$(GREEN)✓$(NC) $$i → $$target"; \
		elif [[ -e "$(HOME)/$$i" ]]; then \
			echo -e "$(CYAN)!$(NC) $$i (exists, not symlink)"; \
		else \
			echo -e "$(CYAN)×$(NC) $$i (missing)"; \
		fi; \
	done
	@echo ""
	@echo "Tip: Run 'make install' to create missing symlinks"

# ── Neovim ─────────────────────────────────────────────────────────────────────
nvim-plugins: ## Install/update Neovim plugins
	@echo -e "$(CYAN)→$(NC) Installing plugins..."
	@nvim --headless "+Lazy! sync" +qa
	@echo -e "$(GREEN)✓$(NC) Plugins installed"

nvim-clean: ## Clean Neovim cache and plugins
	@rm -rf ~/.local/share/nvim/lazy ~/.local/state/nvim/lazy ~/.cache/nvim
	@echo -e "$(GREEN)✓$(NC) Cache cleaned. Run 'make nvim-plugins' to reinstall"

# ── Tmux ───────────────────────────────────────────────────────────────────────
tmux-plugins: ## Install Tmux plugins via TPM
	@echo -e "$(CYAN)→$(NC) Installing Tmux plugins..."
	@$(HOME)/.tmux/plugins/tpm/bin/install_plugins 2>/dev/null || \
		echo -e "$(CYAN)!$(NC) TPM not installed yet"
	@echo -e "$(GREEN)✓$(NC) Plugins installed"
