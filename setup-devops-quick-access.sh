#!/bin/bash
# DevOps Quick Access Installer
# Run: bash setup-devops-quick-access.sh

set -e

echo "🚀 Setting up DevOps Quick Access System..."
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create prompt directory
PROMPT_DIR="$HOME/.devops-prompts"
echo "📁 Creating prompt directory: $PROMPT_DIR"
mkdir -p "$PROMPT_DIR"

# Create full pipeline prompt
echo "📝 Creating full pipeline prompt..."
cat > "$PROMPT_DIR/full.md" << 'FULLEOF'
# DevOps Pipeline - Complete Check

Execute comprehensive pipeline with real-time progress:

## Phase 1: Security & Dependencies
[█░░░░░░░░░░░░░] 1/15 🔒 Secret scanning (git-secrets --scan || trufflehog)
[██░░░░░░░░░░░░] 2/15 🔒 Dependency vulnerabilities (npm audit --production)
[███░░░░░░░░░░░] 3/15 🔒 Environment validation (.env.example check)

## Phase 2: Build & Quality
[████░░░░░░░░░░] 4/15 ✓ Last commit & build status
[█████░░░░░░░░░] 5/15 ✓ Code cleanup (console.logs, debug statements)
[██████░░░░░░░░] 6/15 ✓ Linting & formatting

## Phase 3: Infrastructure
[███████░░░░░░░] 7/15 🗄️ Database backup verified (if applicable)
[████████░░░░░░] 8/15 ✓ Check pending migrations

## Phase 4: Documentation
[█████████░░░░░] 9/15 ✓ Update CHANGELOG.md, PROJECT_STATUS.md
[██████████░░░░] 10/15 ✓ Update README.md & .env.example
[███████████░░░] 11/15 ✓ Review TODO/FIXME comments

## Phase 5: Release Prep
[████████████░░] 12/15 ✓ VERSION file updated (semantic versioning)
[█████████████░] 13/15 ✓ Organize project root (move .md files to /docs)

## Phase 6: Validation
[██████████████] 14/15 📊 Performance checks (bundle size, benchmarks)
[███████████████] 15/15 ✓ Wait for all CI/CD workflows, run smoke tests

If builds fail: troubleshoot, fix, commit, retry (max 5 attempts)
Auto-fix issues where possible
Generate final report with metrics and next steps
FULLEOF

# Create quick check prompt
echo "📝 Creating quick check prompt..."
cat > "$PROMPT_DIR/quick.md" << 'QUICKEOF'
# Quick DevOps Health Check (30 seconds)

Run rapid status check and report:

1. **Last Commit**: git log -1 --oneline
2. **Build Status**: Check GitHub Actions / CI status
3. **Test Coverage**: Latest coverage percentage
4. **Monitoring**: Any active alerts (Sentry, DataDog, etc)

Output format:
```
🟢 Build | 🟢 Tests (87%) | 🟢 Deploy | 🟢 Monitoring
```

Or if issues:
```
🔴 Build FAILED (syntax error in api.js:42) | 🟢 Tests | 🟢 Deploy | 🟢 Monitoring
```

Keep it under 30 seconds. Traffic light only. One-line issues.
QUICKEOF

# Create merge checklist prompt
echo "📝 Creating merge checklist prompt..."
cat > "$PROMPT_DIR/merge.md" << 'MERGEEOF'
# Pre-Merge Pipeline

Check last commit status. If builds fail, troubleshoot and retry.

If builds pass, execute with progress bar:

[█░░░░░░░░░] 1/10 Cleanup scripts (debug code, temp files)
[██░░░░░░░░] 2/10 Update CHANGELOG.md
[███░░░░░░░] 3/10 Update PROJECT_STATUS.md
[████░░░░░░] 4/10 Update README.md
[█████░░░░░] 5/10 Check unfinished deliverables (TODO/FIXME)
[██████░░░░] 6/10 Update VERSION file
[███████░░░] 7/10 Organize project root (move stray .md to /docs)
[████████░░] 8/10 Wait for all GitHub Actions to complete
[█████████░] 9/10 Troubleshoot any workflow failures
[██████████] 10/10 Verify merge readiness

If all pass:
- Check for merge conflicts with target branch
- Generate merge command or PR creation command
- Print final summary with recommendations

If failures: Generate detailed report and halt for manual intervention
MERGEEOF

# Create security scan prompt
echo "📝 Creating security scan prompt..."
cat > "$PROMPT_DIR/security.md" << 'SECEOF'
# Security Scan - Comprehensive

Run all security checks:

## 1. Secret Detection
- Run: git-secrets --scan
- Or: trufflehog git file://. --only-verified
- Check for: API keys, passwords, tokens, credentials
- Fail if any secrets found

## 2. Dependency Vulnerabilities
- Run: npm audit --production
- Fail on: high or critical vulnerabilities
- Generate: audit report with fix recommendations

## 3. Environment Security
- Verify: .env files NOT in git
- Check: .env.example is up-to-date
- Validate: all required env vars present

## 4. Code Security
- Scan for: credential TODOs ("TODO: add API key")
- Check for: hardcoded secrets in code
- Verify: sensitive data not logged

Auto-fix where possible (npm audit fix)
Report all findings with severity levels
Block merge if critical issues found
SECEOF

# Create deploy checklist prompt
echo "📝 Creating deployment checklist prompt..."
cat > "$PROMPT_DIR/deploy.md" << 'DEPLOYEOF'
# Deployment Pipeline

## Phase 1: Pre-Deployment
[█░░░░░] 1/6 Database backup created & verified
[██░░░░] 2/6 Environment variables validated
[███░░░] 3/6 All CI checks passing
[████░░] 4/6 Merge conflicts resolved

## Phase 2: Deployment
[█████░] 5/6 Deploy to staging/production
          - Tag release: git tag vX.Y.Z
          - Push to deployment branch
          - Monitor deployment progress

## Phase 3: Post-Deployment
[██████] 6/6 Smoke tests & monitoring
          - Run smoke tests on deployed URL
          - Check health endpoints
          - Monitor error rates for 15 minutes
          - Send team notification

If any step fails: Execute rollback procedure
After success: Update docs, send notifications, clean up branches
DEPLOYEOF

# Detect shell config file
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
fi

if [ -n "$SHELL_CONFIG" ]; then
    echo "📝 Adding aliases to $SHELL_CONFIG..."
    
    # Check if aliases already exist
    if grep -q "# DevOps Quick Access Aliases" "$SHELL_CONFIG"; then
        echo "⚠️  Aliases already exist in $SHELL_CONFIG, skipping..."
    else
        cat >> "$SHELL_CONFIG" << ALIASEOF

# DevOps Quick Access Aliases
alias devops='claude-code "\$(cat $PROMPT_DIR/full.md)"'
alias devops-quick='claude-code "\$(cat $PROMPT_DIR/quick.md)"'
alias devops-merge='claude-code "\$(cat $PROMPT_DIR/merge.md)"'
alias devops-security='claude-code "\$(cat $PROMPT_DIR/security.md)"'
alias devops-deploy='claude-code "\$(cat $PROMPT_DIR/deploy.md)"'

# DevOps helper functions
devops-add-to-project() {
    if [ ! -d ".devops" ]; then
        mkdir -p .devops/prompts
        cp $PROMPT_DIR/*.md .devops/prompts/
        echo "✅ DevOps prompts added to project"
    else
        echo "⚠️  .devops directory already exists"
    fi
}
ALIASEOF
        echo "✅ Aliases added to $SHELL_CONFIG"
    fi
else
    echo "${YELLOW}⚠️  Could not find shell config file${NC}"
    echo "Add these aliases manually to your shell config:"
    echo ""
    echo "alias devops='claude-code \"\$(cat $PROMPT_DIR/full.md)\"'"
    echo "alias devops-quick='claude-code \"\$(cat $PROMPT_DIR/quick.md)\"'"
    echo "alias devops-merge='claude-code \"\$(cat $PROMPT_DIR/merge.md)\"'"
    echo "alias devops-security='claude-code \"\$(cat $PROMPT_DIR/security.md)\"'"
    echo "alias devops-deploy='claude-code \"\$(cat $PROMPT_DIR/deploy.md)\"'"
    echo ""
fi

# Create project template
echo "📁 Creating project template..."
TEMPLATE_DIR="$HOME/.devops-templates/project"
mkdir -p "$TEMPLATE_DIR/.devops/prompts"
cp "$PROMPT_DIR"/*.md "$TEMPLATE_DIR/.devops/prompts/"

# Create Makefile template
cat > "$TEMPLATE_DIR/Makefile" << 'MAKEEOF'
.PHONY: devops devops-quick devops-merge devops-security devops-deploy help

help:
	@echo "DevOps Quick Commands:"
	@echo "  make devops          - Run full pipeline check"
	@echo "  make devops-quick    - Quick 30-second health check"
	@echo "  make devops-merge    - Pre-merge checklist"
	@echo "  make devops-security - Security scan only"
	@echo "  make devops-deploy   - Deployment pipeline"

devops:
	@claude-code "$$(cat .devops/prompts/full.md)"

devops-quick:
	@claude-code "$$(cat .devops/prompts/quick.md)"

devops-merge:
	@claude-code "$$(cat .devops/prompts/merge.md)"

devops-security:
	@claude-code "$$(cat .devops/prompts/security.md)"

devops-deploy:
	@claude-code "$$(cat .devops/prompts/deploy.md)"
MAKEEOF

# Create package.json template snippet
cat > "$TEMPLATE_DIR/package.json.snippet" << 'PKGEOF'
{
  "scripts": {
    "devops": "claude-code \"$(cat .devops/prompts/full.md)\"",
    "devops:quick": "claude-code \"$(cat .devops/prompts/quick.md)\"",
    "devops:merge": "claude-code \"$(cat .devops/prompts/merge.md)\"",
    "devops:security": "claude-code \"$(cat .devops/prompts/security.md)\"",
    "devops:deploy": "claude-code \"$(cat .devops/prompts/deploy.md)\""
  }
}
PKGEOF

# Create README
cat > "$TEMPLATE_DIR/README.md" << 'READMEEOF'
# DevOps Quick Access - Project Setup

This project has DevOps quick access configured.

## Usage

### Using Make:
```bash
make devops          # Full pipeline check
make devops-quick    # Quick health check
make devops-merge    # Pre-merge checklist
make devops-security # Security scan
make devops-deploy   # Deployment pipeline
```

### Using NPM:
```bash
npm run devops
npm run devops:quick
npm run devops:merge
npm run devops:security
npm run devops:deploy
```

### Using Claude Code directly:
```bash
claude-code "$(cat .devops/prompts/full.md)"
```

## Customization

Edit prompts in `.devops/prompts/` to customize for your project needs.
READMEEOF

echo "✅ Project template created at $TEMPLATE_DIR"

# Create quick reference card
cat > "$HOME/.devops-prompts/QUICKREF.md" << 'QUICKREFEOF'
# DevOps Quick Access - Reference Card

## Shell Aliases (Anywhere)
```bash
devops              # Full pipeline (15 checks)
devops-quick        # 30-second health check
devops-merge        # Pre-merge checklist
devops-security     # Security scan only
devops-deploy       # Deployment pipeline
```

## Add to New Project
```bash
devops-add-to-project
# Then use: make devops, npm run devops, etc
```

## Manual Project Setup
```bash
cp -r ~/.devops-templates/project/.devops .
cp ~/.devops-templates/project/Makefile .
```

## Customize Prompts
Edit: ~/.devops-prompts/*.md
Per-project: .devops/prompts/*.md

## Update from Source
```bash
# Re-run installer
curl -L https://your-gist-url/setup.sh | bash
```

## Prompts Available
- full.md       - Complete 15-step pipeline
- quick.md      - 30-second status check
- merge.md      - Pre-merge preparation
- security.md   - Security scanning only
- deploy.md     - Deployment workflow
EOF

echo ""
echo "${GREEN}✅ DevOps Quick Access setup complete!${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📚 Quick Reference:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  ${GREEN}devops${NC}              Run full pipeline (15 checks)"
echo "  ${GREEN}devops-quick${NC}        Quick 30-second health check"
echo "  ${GREEN}devops-merge${NC}        Pre-merge checklist"
echo "  ${GREEN}devops-security${NC}     Security scan only"
echo "  ${GREEN}devops-deploy${NC}       Deployment pipeline"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Add to a Project:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  ${GREEN}devops-add-to-project${NC}   (adds .devops/ + Makefile)"
echo ""
echo "  Or manually:"
echo "  cp -r ~/.devops-templates/project/.devops ."
echo "  cp ~/.devops-templates/project/Makefile ."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -n "$SHELL_CONFIG" ]; then
    echo ""
    echo "${YELLOW}⚡ Restart your terminal or run:${NC}"
    echo "  source $SHELL_CONFIG"
    echo ""
fi

echo "📖 View quick reference: cat ~/.devops-prompts/QUICKREF.md"
echo ""
