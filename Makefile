# ═══════════════════════════════════════════════════════════════════════════════
# Dotfiles Makefile
# Common operations for managing dotfiles
# ═══════════════════════════════════════════════════════════════════════════════

.PHONY: help install uninstall backup restore update lint clean sync

# ── Configuration ──────────────────────────────────────────────────────────────
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(HOME)/.dotfiles.backup.$(shell date +%Y%m%d_%H%M%S)
STOW := stow

# Colors for output
COLOR_RESET := \033[0m
COLOR_GREEN := \033[0;32m
COLOR_YELLOW := \033[1;33m
COLOR_BLUE := \033[0;34m
COLOR_RED := \033[0;31m

# ── Help ───────────────────────────────────────────────────────────────────────
help: ## Show this help message
	@echo "$(COLOR_BLUE)╔═══════════════════════════════════════════════════════════╗$(COLOR_RESET)"
	@echo "$(COLOR_BLUE)║              Dotfiles Management Commands                 ║$(COLOR_RESET)"
	@echo "$(COLOR_BLUE)╚═══════════════════════════════════════════════════════════╝$(COLOR_RESET)"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(COLOR_GREEN)%-15s$(COLOR_RESET) %s\n", $$1, $$2}'
	@echo ""

# ── Installation ───────────────────────────────────────────────────────────────
install: ## Create symlinks for all dotfiles using GNU Stow
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Creating symlinks..."
	@$(STOW) -t ~ .
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Installation complete!"
	@echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) Restart your shell or run: source ~/.zshrc"

install-nvim: ## Install only Neovim configuration
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Creating Neovim symlink..."
	@$(STOW) -t ~ .config/nvim
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Neovim configuration installed!"

install-hypr: ## Install only Hyprland configuration
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Creating Hyprland symlinks..."
	@$(STOW) -t ~ .config/hypr
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Hyprland configuration installed!"

# ── Uninstallation ─────────────────────────────────────────────────────────────
uninstall: ## Remove all symlinks (preserves backup)
	@echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) Removing symlinks..."
	@$(STOW) -D -t ~ .
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Symlinks removed!"

uninstall-nvim: ## Remove Neovim symlinks
	@echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) Removing Neovim symlinks..."
	@$(STOW) -D -t ~ .config/nvim
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Neovim symlinks removed!"

# ── Backup & Restore ───────────────────────────────────────────────────────────
backup: ## Create backup of existing configurations
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Creating backup to $(BACKUP_DIR)..."
	@mkdir -p $(BACKUP_DIR)
	@for item in .config/hypr .config/nvim .config/waybar .config/rofi \
		.config/swaync .config/ghostty .config/kitty .config/tmux \
		.config/starship .config/yazi .config/fastfetch .zshrc; do \
		if [ -e "$(HOME)/$$item" ]; then \
			cp -r "$(HOME)/$$item" "$(BACKUP_DIR)/" 2>/dev/null || true; \
		fi; \
	done
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Backup created: $(BACKUP_DIR)"

restore: ## Restore from backup (requires BACKUP_DIR variable)
	@if [ -z "$(BACKUP_DIR)" ]; then \
		echo "$(COLOR_RED)[✗]$(COLOR_RESET) Please specify BACKUP_DIR=..."; \
		exit 1; \
	fi
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Restoring from $(BACKUP_DIR)..."
	@for item in .config/hypr .config/nvim .config/waybar .config/rofi \
		.config/swaync .config/ghostty .config/kitty .config/tmux \
		.config/starship .config/yazi .config/fastfetch .zshrc; do \
		if [ -e "$(BACKUP_DIR)/$$item" ]; then \
			cp -r "$(BACKUP_DIR)/$$item" "$(HOME)/" 2>/dev/null || true; \
		fi; \
	done
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Restore complete!"

# ── Updates ────────────────────────────────────────────────────────────────────
update: ## Pull latest changes from git repository
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Updating dotfiles..."
	@git pull --rebase
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Update complete!"
	@echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) Run 'make install' to apply changes"

sync: update install ## Pull latest changes and reinstall (update + install)
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Sync complete!"

# ── Maintenance ────────────────────────────────────────────────────────────────
lint: ## Run linting checks on configuration files
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Running lint checks..."
	@echo ""
	@echo "Checking shell scripts..."
	@shellcheck .config/hypr/scripts/*.sh install.sh 2>/dev/null || \
		echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) shellcheck not installed or found"
	@echo ""
	@echo "Checking Lua files..."
	@luacheck .config/nvim/lua/ 2>/dev/null || \
		echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) luacheck not installed or found"
	@echo ""
	@echo "Validating JSONC files (syntax check)..."
	@for f in .config/waybar/config.jsonc .config/fastfetch/config.jsonc; do \
		if [ -f "$$f" ]; then \
			if command -v python >/dev/null 2>&1; then \
				python -c "import json; import re; \
					content = open('$$f').read(); \
					content = re.sub(r'//.*', '', content); \
					content = re.sub(r',(\s*[]\}])', r'\1', content); \
					json.loads(content)" 2>/dev/null && \
					echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) $$f" || \
					echo "$(COLOR_RED)[✗]$(COLOR_RESET) $$f (invalid JSONC)"; \
			else \
				echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) python not installed"; \
			fi; \
		fi; \
	done
	@echo ""
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Lint complete!"

pre-commit: ## Run pre-commit checks before committing
	@./scripts/pre-commit-check.sh

clean: ## Clean up temporary files and caches
	@echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) Cleaning temporary files..."
	@rm -rf .cache/* 2>/dev/null || true
	@find . -name "*.swp" -delete 2>/dev/null || true
	@find . -name "*.swo" -delete 2>/dev/null || true
	@find . -name "*~" -delete 2>/dev/null || true
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Clean complete!"

check: ## Check current symlink status
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Checking symlinks..."
	@echo ""
	@for item in .zshrc .config/hypr .config/nvim .config/waybar \
		.config/rofi .config/swaync .config/ghostty .config/kitty \
		.config/tmux .config/starship .config/yazi; do \
		if [ -L "$(HOME)/$$item" ]; then \
			target=$$(readlink "$(HOME)/$$item"); \
			echo "$(COLOR_GREEN)→$(COLOR_RESET) $$item → $$target"; \
		elif [ -e "$(HOME)/$$item" ]; then \
			echo "$(COLOR_YELLOW)!$(COLOR_RESET) $$item (exists, not symlink)"; \
		else \
			echo "$(COLOR_RED)×$(COLOR_RESET) $$item (not installed)"; \
		fi; \
	done

# ── Neovim ─────────────────────────────────────────────────────────────────────
nvim-plugins: ## Install/update Neovim plugins
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Installing Neovim plugins..."
	@nvim --headless "+Lazy! sync" +qa
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Plugins installed!"

nvim-clean: ## Clean Neovim cache and plugins
	@echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) Cleaning Neovim cache..."
	@rm -rf ~/.local/share/nvim/lazy
	@rm -rf ~/.local/state/nvim/lazy
	@rm -rf ~/.cache/nvim
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Cache cleaned!"
	@echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) Run 'make nvim-plugins' to reinstall"

# ── Tmux ───────────────────────────────────────────────────────────────────────
tmux-plugins: ## Install Tmux plugins via TPM
	@echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) Installing Tmux plugins..."
	@$(HOME)/.tmux/plugins/tpm/bin/install_plugins 2>/dev/null || \
		echo "$(COLOR_YELLOW)[!]$(COLOR_RESET) TPM not installed yet"
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Plugins installed!"

# ── Git ────────────────────────────────────────────────────────────────────────
status: ## Show git status
	@git status --short

diff: ## Show git diff
	@git diff HEAD

log: ## Show recent commits
	@git log --oneline -10

commit: ## Stage all changes and commit
	@git add .
	@git status
	@read -p "Enter commit message: " msg; \
	git commit -m "$$msg"
	@echo "$(COLOR_GREEN)[✓]$(COLOR_RESET) Committed!"
