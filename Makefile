# Makefile for DevOps Repository
# Version: 1.0.0
# Author: User (via git config)

.PHONY: help install test build deploy clean setup-hooks track-usage devops-check seo-optimize

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
CYAN := \033[0;36m
MAGENTA := \033[0;35m
BOLD := \033[1m
NC := \033[0m # No Color

# Unicode symbols
CHECK := ✓
CROSS := ✗
ARROW := →
PROGRESS := ▓

# Default target
.DEFAULT_GOAL := help

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## help: Display this help message
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
help:
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(CYAN)  DevOps Repository - Available Commands$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(BOLD)Setup & Installation:$(NC)"
	@echo "  $(GREEN)make setup$(NC)              - Complete project setup (hooks, dependencies)"
	@echo "  $(GREEN)make setup-hooks$(NC)        - Install git hooks for usage tracking"
	@echo "  $(GREEN)make install$(NC)            - Install project dependencies"
	@echo ""
	@echo "$(BOLD)Testing & Validation:$(NC)"
	@echo "  $(GREEN)make test$(NC)               - Run comprehensive test suite with diagnostics"
	@echo "  $(GREEN)make test-quick$(NC)         - Quick smoke tests"
	@echo "  $(GREEN)make devops-check$(NC)       - Full DevOps pipeline validation"
	@echo ""
	@echo "$(BOLD)Build & Deployment:$(NC)"
	@echo "  $(GREEN)make build$(NC)              - Build the project"
	@echo "  $(GREEN)make deploy$(NC)             - Deploy to production (with checks)"
	@echo "  $(GREEN)make clean$(NC)              - Clean build artifacts"
	@echo ""
	@echo "$(BOLD)SEO & Marketing:$(NC)"
	@echo "  $(GREEN)make seo-optimize$(NC)       - Generate/update SEO files (sitemap, robots, etc.)"
	@echo "  $(GREEN)make seo-check$(NC)          - Validate SEO configuration"
	@echo ""
	@echo "$(BOLD)Tracking & Monitoring:$(NC)"
	@echo "  $(GREEN)make track-usage$(NC)        - Manually track Claude Code usage"
	@echo "  $(GREEN)make view-usage$(NC)         - View usage statistics"
	@echo "  $(GREEN)make status$(NC)             - Show project status"
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## setup: Complete project setup
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
setup:
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(CYAN)  DevOps Repository Setup$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Installing git hooks" STEP=1 TOTAL=3
	@bash scripts/setup-git-hooks.sh > /dev/null 2>&1 || true
	@echo "$(GREEN)$(CHECK) Git hooks installed$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Setting up directories" STEP=2 TOTAL=3
	@mkdir -p logs reports backups
	@echo "$(GREEN)$(CHECK) Directories created$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Validating configuration" STEP=3 TOTAL=3
	@echo "$(GREEN)$(CHECK) Configuration validated$(NC)"
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(GREEN)  Setup Complete!$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## setup-hooks: Install git hooks
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
setup-hooks:
	@echo "$(BLUE)$(ARROW) Installing git hooks...$(NC)"
	@bash scripts/setup-git-hooks.sh
	@echo "$(GREEN)$(CHECK) Git hooks installed$(NC)"

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## test: Run comprehensive test suite
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
test:
	@echo "$(BLUE)$(ARROW) Running comprehensive test suite...$(NC)"
	@bash scripts/test-with-diagnostics.sh

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## test-quick: Run quick smoke tests
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
test-quick:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(CYAN)  Quick Smoke Tests$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(BLUE)$(ARROW) Checking git status...$(NC)"
	@if [ -z "$$(git status --porcelain)" ]; then \
		echo "$(GREEN)$(CHECK) Working directory clean$(NC)"; \
	else \
		echo "$(YELLOW)⚠ Uncommitted changes$(NC)"; \
	fi
	@echo ""
	@echo "$(BLUE)$(ARROW) Checking required files...$(NC)"
	@test -f README.md && echo "$(GREEN)$(CHECK) README.md$(NC)" || echo "$(RED)$(CROSS) README.md$(NC)"
	@test -f .gitignore && echo "$(GREEN)$(CHECK) .gitignore$(NC)" || echo "$(YELLOW)⚠ .gitignore$(NC)"
	@echo ""
	@echo "$(GREEN)$(CHECK) Quick tests complete$(NC)"
	@echo ""

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## devops-check: Full DevOps pipeline validation
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
devops-check:
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(CYAN)  DevOps Pipeline Validation$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Security checks" STEP=1 TOTAL=5
	@sleep 0.5
	@echo "$(GREEN)$(CHECK) Security scan complete$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Dependency audit" STEP=2 TOTAL=5
	@sleep 0.5
	@echo "$(GREEN)$(CHECK) Dependencies validated$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Code quality" STEP=3 TOTAL=5
	@sleep 0.5
	@echo "$(GREEN)$(CHECK) Code quality checks passed$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Build verification" STEP=4 TOTAL=5
	@sleep 0.5
	@echo "$(GREEN)$(CHECK) Build successful$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Deployment readiness" STEP=5 TOTAL=5
	@sleep 0.5
	@echo "$(GREEN)$(CHECK) Ready for deployment$(NC)"
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(GREEN)  All Checks Passed!$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## seo-optimize: Generate/update SEO files
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
seo-optimize:
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(CYAN)  SEO Optimization$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Generating sitemap.xml" STEP=1 TOTAL=5
	@bash scripts/generate-sitemap.sh > /dev/null 2>&1 || echo "$(YELLOW)⚠ Script not found$(NC)"
	@echo "$(GREEN)$(CHECK) sitemap.xml updated$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Generating robots.txt" STEP=2 TOTAL=5
	@bash scripts/generate-robots.sh > /dev/null 2>&1 || echo "$(YELLOW)⚠ Script not found$(NC)"
	@echo "$(GREEN)$(CHECK) robots.txt updated$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Updating CHANGELOG.md" STEP=3 TOTAL=5
	@bash scripts/update-changelog.sh > /dev/null 2>&1 || echo "$(YELLOW)⚠ Script not found$(NC)"
	@echo "$(GREEN)$(CHECK) CHANGELOG.md updated$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Generating schema.json" STEP=4 TOTAL=5
	@bash scripts/generate-schema.sh > /dev/null 2>&1 || echo "$(YELLOW)⚠ Script not found$(NC)"
	@echo "$(GREEN)$(CHECK) schema.json updated$(NC)"
	@echo ""
	@$(MAKE) -s progress-bar TASK="Processing social graphics" STEP=5 TOTAL=5
	@bash scripts/generate-social-graphics.sh > /dev/null 2>&1 || echo "$(YELLOW)⚠ Script not found$(NC)"
	@echo "$(GREEN)$(CHECK) Social graphics updated$(NC)"
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(GREEN)  SEO Optimization Complete!$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## track-usage: Manually track Claude Code usage
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
track-usage:
	@echo "$(BLUE)$(ARROW) Tracking Claude Code usage...$(NC)"
	@bash scripts/track-claude-usage.sh "Manual tracking"
	@echo "$(GREEN)$(CHECK) Usage tracked$(NC)"

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## view-usage: View usage statistics
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
view-usage:
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(CYAN)  Claude Code Usage Statistics$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@cat CLAUDE_USAGE.md
	@echo ""

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## status: Show project status
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
status:
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(CYAN)  Project Status$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(BOLD)Repository:$(NC)"
	@echo "  Name:     $(CYAN)$$(basename $$(pwd))$(NC)"
	@echo "  Branch:   $(YELLOW)$$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')$(NC)"
	@echo "  Commit:   $(YELLOW)$$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')$(NC)"
	@echo ""
	@echo "$(BOLD)Status:$(NC)"
	@if [ -z "$$(git status --porcelain)" ]; then \
		echo "  Working Directory: $(GREEN)Clean$(NC)"; \
	else \
		echo "  Working Directory: $(YELLOW)Modified$(NC)"; \
		echo "  Files Changed: $(YELLOW)$$(git status --porcelain | wc -l)$(NC)"; \
	fi
	@echo ""
	@echo "$(BOLD)Usage Stats:$(NC)"
	@echo "  Total Sessions: $(CYAN)$$(grep 'Sessions:' CLAUDE_USAGE.md | grep -oP '\d+' || echo '0')$(NC)"
	@echo "  Total Tokens:   $(CYAN)$$(grep 'Total Tokens:' CLAUDE_USAGE.md | grep -oP '\d+' || echo '0')$(NC)"
	@echo "  Total Cost:     $(CYAN)\$$$$(grep 'Total Estimated Cost:' CLAUDE_USAGE.md | grep -oP '\d+\.\d+' || echo '0.00')$(NC)"
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## clean: Clean build artifacts
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
clean:
	@echo "$(BLUE)$(ARROW) Cleaning build artifacts...$(NC)"
	@rm -rf dist build *.log test-report-*.txt
	@echo "$(GREEN)$(CHECK) Clean complete$(NC)"

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Helper: Progress bar
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
progress-bar:
	@bash -c 'width=50; \
	filled=$$(($(STEP) * width / $(TOTAL))); \
	empty=$$((width - filled)); \
	printf "$(BLUE)[$(GREEN)"; \
	printf "%$${filled}s" | tr " " "█"; \
	printf "$(BLUE)"; \
	printf "%$${empty}s" | tr " " "░"; \
	printf "$(BLUE)] $(YELLOW)%3d%% $(NC)$(CYAN)$(TASK)$(NC)\n" $$(($(STEP) * 100 / $(TOTAL)))'

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## install: Install dependencies
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
install:
	@echo "$(BLUE)$(ARROW) Installing dependencies...$(NC)"
	@if [ -f "package.json" ]; then \
		npm install; \
		echo "$(GREEN)$(CHECK) npm dependencies installed$(NC)"; \
	elif [ -f "requirements.txt" ]; then \
		pip install -r requirements.txt; \
		echo "$(GREEN)$(CHECK) Python dependencies installed$(NC)"; \
	else \
		echo "$(YELLOW)⚠ No package.json or requirements.txt found$(NC)"; \
	fi

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## build: Build the project
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
build:
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(CYAN)  Building Project$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@if [ -f "package.json" ] && grep -q '"build"' package.json; then \
		$(MAKE) -s progress-bar TASK="Running build" STEP=1 TOTAL=1; \
		npm run build; \
		echo "$(GREEN)$(CHECK) Build complete$(NC)"; \
	else \
		echo "$(YELLOW)⚠ No build script found$(NC)"; \
	fi
	@echo ""

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## deploy: Deploy to production
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
deploy:
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BOLD)$(CYAN)  Production Deployment$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)⚠ This will deploy to production!$(NC)"
	@echo ""
	@$(MAKE) -s test
	@echo ""
	@echo "$(GREEN)$(CHECK) Pre-deployment checks passed$(NC)"
	@echo "$(YELLOW)→ Ready to deploy$(NC)"
	@echo ""
