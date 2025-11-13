# DevOps Quick Access System

## Option 1: Single Command Alias (FASTEST)

### Setup Once:
```bash
# Add to your ~/.bashrc, ~/.zshrc, or ~/.profile
alias devops='claude-code "$(cat ~/.devops-prompts/main.md)"'
alias devops-quick='claude-code "Run quick DevOps health check: build status, test coverage, deployment health, alerts. Traffic light format."'
alias devops-merge='claude-code "$(cat ~/.devops-prompts/merge-checklist.md)"'
alias devops-deploy='claude-code "$(cat ~/.devops-prompts/deploy-checklist.md)"'
alias devops-security='claude-code "$(cat ~/.devops-prompts/security-scan.md)"'

# NEW: Feature documentation workflow
alias devops-feature-start='claude-code "$(cat ~/.devops-prompts/feature-start.md)"'
alias devops-feature-validate='claude-code "$(cat ~/.devops-prompts/feature-validate.md)"'
```

### Create prompt library:
```bash
mkdir -p ~/.devops-prompts

# Main comprehensive check
cat > ~/.devops-prompts/main.md << 'EOF'
# DevOps Pipeline Check

Execute comprehensive pipeline with progress tracking:

[█░░░░░░░░░░░░] 1/15 🔒 Secret scanning (git-secrets)
[██░░░░░░░░░░░] 2/15 🔒 Dependency vulnerabilities (npm audit)
[███░░░░░░░░░░] 3/15 ✓ Environment validated (.env.example)
[████░░░░░░░░░] 4/15 ✓ Build status verified
[█████░░░░░░░░] 5/15 ✓ Cleanup (debug code, temp files)
[██████░░░░░░░] 6/15 🗄️ Database backup verified
[███████░░░░░░] 7/15 ✓ Docs updated (CHANGELOG, README, STATUS)
[████████░░░░░] 8/15 ✓ TODO/FIXME reviewed
[█████████░░░░] 9/15 ✓ VERSION updated & files organized
[██████████░░░] 10/15 📊 Performance (bundle size, benchmarks)
[███████████░░] 11/15 ✓ Wait for all workflows
[████████████░] 12/15 🧪 Smoke tests
[█████████████] 13/15 🔔 Notifications sent
[██████████████] 14/15 📈 Monitor deployment
[███████████████] 15/15 ✅ Final report

Auto-fix issues where possible. Max 3 retries per check.
EOF

# Quick health check (30 seconds)
cat > ~/.devops-prompts/quick.md << 'EOF'
Quick Health Check (30 seconds):

1. Last commit: git log -1 --oneline
2. CI/CD: Check GitHub Actions status
3. Coverage: Latest test report
4. Monitoring: Any active alerts?

Print: 🟢 Build | 🟢 Tests | 🟢 Deploy | 🟢 Monitoring
(or 🔴/⚠️ with issue description)
EOF

# Merge preparation
cat > ~/.devops-prompts/merge-checklist.md << 'EOF'
Pre-Merge Checklist:

If build fails: troubleshoot, fix, commit, retry (max 5 attempts)
If builds pass: run full checklist with progress bar
If all pass: verify merge readiness, create PR or merge

Include: cleanup, docs, version bump, file organization, workflow verification
EOF

# Security scan only
cat > ~/.devops-prompts/security-scan.md << 'EOF'
Security Scan Only:

1. git-secrets scan (no API keys/passwords)
2. npm audit --production (no high/critical vulns)
3. Check .env not committed
4. Verify .env.example up-to-date
5. Scan for TODO with credentials

Report issues and auto-fix where possible.
EOF
```

### Use anywhere:
```bash
# In any project directory
devops              # Run full pipeline
devops-quick        # 30-second health check
devops-merge        # Pre-merge checklist
devops-security     # Security scan only
```

---

## Option 2: NPM Global Package (MOST PORTABLE)

### Create package structure:
```bash
mkdir -p devops-cli
cd devops-cli

cat > package.json << 'EOF'
{
  "name": "@yourname/devops-cli",
  "version": "1.0.0",
  "bin": {
    "devops": "./bin/devops.js",
    "devops-check": "./bin/check.js",
    "devops-merge": "./bin/merge.js",
    "devops-deploy": "./bin/deploy.js"
  },
  "files": ["bin", "templates"],
  "dependencies": {
    "commander": "^11.0.0",
    "chalk": "^5.3.0",
    "ora": "^7.0.1"
  }
}
EOF

mkdir -p bin templates

cat > bin/devops.js << 'EOF'
#!/usr/bin/env node
const { program } = require('commander');
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

program
  .version('1.0.0')
  .description('Quick DevOps checks and automation');

program
  .command('check')
  .description('Quick health check')
  .action(() => {
    const template = fs.readFileSync(
      path.join(__dirname, '../templates/quick-check.md'),
      'utf8'
    );
    execSync(`claude-code "${template}"`, { stdio: 'inherit' });
  });

program
  .command('merge')
  .description('Pre-merge checklist')
  .action(() => {
    const template = fs.readFileSync(
      path.join(__dirname, '../templates/merge-checklist.md'),
      'utf8'
    );
    execSync(`claude-code "${template}"`, { stdio: 'inherit' });
  });

program
  .command('security')
  .description('Security scan')
  .action(() => {
    const template = fs.readFileSync(
      path.join(__dirname, '../templates/security-scan.md'),
      'utf8'
    );
    execSync(`claude-code "${template}"`, { stdio: 'inherit' });
  });

program
  .command('full')
  .description('Full pipeline check')
  .action(() => {
    const template = fs.readFileSync(
      path.join(__dirname, '../templates/full-pipeline.md'),
      'utf8'
    );
    execSync(`claude-code "${template}"`, { stdio: 'inherit' });
  });

program.parse();
EOF

chmod +x bin/devops.js
```

### Install globally:
```bash
npm install -g .

# Or publish to npm
npm publish --access public
```

### Use anywhere:
```bash
devops check        # Quick health check
devops merge        # Pre-merge checklist
devops security     # Security scan
devops full         # Full pipeline
```

---

## Option 3: GitHub Gist (SHAREABLE WITH TEAM)

### Create gist structure:
```bash
# Create files locally first
mkdir devops-gists

# Main comprehensive check
cat > devops-gists/full-pipeline.md << 'EOF'
# [Your full pipeline content]
EOF

cat > devops-gists/quick-check.md << 'EOF'
# [Your quick check content]
EOF

cat > devops-gists/merge-checklist.md << 'EOF'
# [Your merge checklist content]
EOF

cat > devops-gists/security-scan.md << 'EOF'
# [Your security scan content]
EOF

# Create installer script
cat > devops-gists/install.sh << 'EOF'
#!/bin/bash
# Install DevOps Quick Access

GIST_ID="your-gist-id-here"
INSTALL_DIR="$HOME/.devops-prompts"

mkdir -p "$INSTALL_DIR"

echo "📥 Downloading DevOps prompts..."
curl -L "https://gist.githubusercontent.com/yourname/$GIST_ID/raw/full-pipeline.md" -o "$INSTALL_DIR/full.md"
curl -L "https://gist.githubusercontent.com/yourname/$GIST_ID/raw/quick-check.md" -o "$INSTALL_DIR/quick.md"
curl -L "https://gist.githubusercontent.com/yourname/$GIST_ID/raw/merge-checklist.md" -o "$INSTALL_DIR/merge.md"
curl -L "https://gist.githubusercontent.com/yourname/$GIST_ID/raw/security-scan.md" -o "$INSTALL_DIR/security.md"

echo "✅ Prompts installed to $INSTALL_DIR"
echo ""
echo "Add these aliases to your shell config:"
echo "alias devops='claude-code \"\$(cat ~/.devops-prompts/full.md)\"'"
echo "alias devops-quick='claude-code \"\$(cat ~/.devops-prompts/quick.md)\"'"
echo "alias devops-merge='claude-code \"\$(cat ~/.devops-prompts/merge.md)\"'"
echo "alias devops-security='claude-code \"\$(cat ~/.devops-prompts/security.md)\"'"
EOF

chmod +x devops-gists/install.sh
```

### Create the gist:
1. Go to https://gist.github.com/
2. Create new gist with multiple files
3. Add all your prompt files
4. Make it public
5. Copy gist ID

### Team installation:
```bash
# One-liner install
curl -L https://gist.githubusercontent.com/yourname/gist-id/raw/install.sh | bash

# Or manual
gh gist clone your-gist-id
cd your-gist-id
./install.sh
```

---

## Option 4: Project Template (IN EVERY REPO)

### Create `.devops/` directory in each project:
```bash
# Add to your project
mkdir -p .devops/prompts .devops/scripts

# Copy prompts
cp ~/.devops-prompts/*.md .devops/prompts/

# Create Makefile for easy access
cat > Makefile << 'EOF'
.PHONY: devops devops-quick devops-merge devops-security devops-deploy

devops:
	@claude-code "$$(cat .devops/prompts/full-pipeline.md)"

devops-quick:
	@claude-code "$$(cat .devops/prompts/quick-check.md)"

devops-merge:
	@claude-code "$$(cat .devops/prompts/merge-checklist.md)"

devops-security:
	@claude-code "$$(cat .devops/prompts/security-scan.md)"

devops-deploy:
	@claude-code "$$(cat .devops/prompts/deploy-checklist.md)"
EOF

# Or use npm scripts
cat >> package.json << 'EOF'
{
  "scripts": {
    "devops": "claude-code \"$(cat .devops/prompts/full-pipeline.md)\"",
    "devops:quick": "claude-code \"$(cat .devops/prompts/quick-check.md)\"",
    "devops:merge": "claude-code \"$(cat .devops/prompts/merge-checklist.md)\"",
    "devops:security": "claude-code \"$(cat .devops/prompts/security-scan.md)\""
  }
}
EOF
```

### Use in project:
```bash
# With make
make devops
make devops-quick

# With npm
npm run devops
npm run devops:quick
```

---

## Option 5: Chrome/Browser Bookmarklet (NO TERMINAL NEEDED)

### Create bookmarklets:
```javascript
// Full Pipeline Check
javascript:(function(){
  const prompt = `[Your full pipeline prompt here]`;
  const claude = window.open('https://claude.ai', 'claude');
  setTimeout(() => {
    claude.postMessage({type: 'INSERT_PROMPT', text: prompt}, '*');
  }, 2000);
})();

// Quick Check
javascript:(function(){
  const prompt = `Quick DevOps health check: build, tests, deploy, alerts. Traffic light format.`;
  window.open(`https://claude.ai?q=${encodeURIComponent(prompt)}`);
})();
```

### Add to browser:
1. Create new bookmark
2. Name: "DevOps Check"
3. URL: [paste javascript code]
4. Click bookmark from any page to run

---

## Option 6: VS Code Extension (IDE INTEGRATION)

### Create `.vscode/` snippets:
```json
// .vscode/devops.code-snippets
{
  "DevOps Full Check": {
    "prefix": "devops-full",
    "body": [
      "# DevOps Pipeline Check",
      "",
      "[█░░░░░░░░░░░░] 1/15 🔒 Secret scanning",
      "[██░░░░░░░░░░░] 2/15 🔒 Dependency vulnerabilities",
      "... [rest of checklist]"
    ],
    "description": "Full DevOps pipeline check"
  },
  "DevOps Quick Check": {
    "prefix": "devops-quick",
    "body": [
      "Quick health check: build, tests, deploy, alerts"
    ],
    "description": "Quick 30-second health check"
  }
}
```

### Create tasks:
```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "DevOps: Full Check",
      "type": "shell",
      "command": "claude-code \"$(cat .devops/prompts/full-pipeline.md)\"",
      "problemMatcher": []
    },
    {
      "label": "DevOps: Quick Check",
      "type": "shell",
      "command": "claude-code \"Quick DevOps health check\"",
      "problemMatcher": []
    }
  ]
}
```

### Use:
- CMD/CTRL + SHIFT + P → "Run Task" → "DevOps: Full Check"

---

## 🎯 RECOMMENDED: Hybrid Approach

Combine multiple options:

```bash
# 1. Create gist for sharing with team
# 2. Add aliases for personal quick access
# 3. Add to each project's package.json
# 4. Setup GitHub Actions for automation

# Result: Access from anywhere, any way you prefer
```

---

## 📦 Ready-to-Use Installation Script

```bash
#!/bin/bash
# setup-devops-quick-access.sh

set -e

echo "🚀 Setting up DevOps Quick Access..."

# 1. Create prompt directory
PROMPT_DIR="$HOME/.devops-prompts"
mkdir -p "$PROMPT_DIR"

# 2. Download prompts (or create locally)
cat > "$PROMPT_DIR/full.md" << 'FULLEOF'
# DevOps Pipeline - Full Check

Execute comprehensive pipeline with progress tracking:

[█░░░░░░░░░░░░] 1/15 🔒 Secret scanning (git-secrets --scan)
[██░░░░░░░░░░░] 2/15 🔒 Dependency scan (npm audit --production)
[███░░░░░░░░░░] 3/15 ✓ Environment validated
[████░░░░░░░░░] 4/15 ✓ Build status verified
[█████░░░░░░░░] 5/15 ✓ Cleanup debug code
[██████░░░░░░░] 6/15 🗄️ Database backup verified
[███████░░░░░░] 7/15 ✓ Docs updated (CHANGELOG, README)
[████████░░░░░] 8/15 ✓ TODO/FIXME reviewed
[█████████░░░░] 9/15 ✓ VERSION bumped & files organized
[██████████░░░] 10/15 📊 Performance checks (bundle size)
[███████████░░] 11/15 ✓ All workflows passed
[████████████░] 12/15 🧪 Smoke tests run
[█████████████] 13/15 🔔 Team notified
[██████████████] 14/15 📈 Monitoring for 15 min
[███████████████] 15/15 ✅ COMPLETE

Check last commit status. If builds fail: troubleshoot, fix, retry (max 5).
Auto-fix where possible. Generate final report with metrics.
FULLEOF

cat > "$PROMPT_DIR/quick.md" << 'QUICKEOF'
Quick DevOps Health Check (30 seconds):

Check and report:
1. Last commit status
2. CI/CD pipeline status
3. Test coverage %
4. Active monitoring alerts

Format:
🟢 Build | 🟢 Tests (87%) | 🟢 Deploy | 🟢 Monitoring
(or 🔴/⚠️ with one-line issue description)
QUICKEOF

cat > "$PROMPT_DIR/merge.md" << 'MERGEEOF'
Pre-Merge Pipeline:

1. Verify build passing (auto-retry if failed)
2. Run checklist: cleanup, docs, version, organize
3. Check merge conflicts
4. Generate merge command or PR
5. Print summary

Show progress bar for each step.
MERGEEOF

cat > "$PROMPT_DIR/security.md" << 'SECEOF'
Security Scan:

1. git-secrets --scan (no API keys/passwords)
2. npm audit --production (fail on high/critical)
3. Verify .env not in git
4. Check .env.example up-to-date
5. Scan for credential TODOs

Auto-fix where possible. Report all issues.
SECEOF

cat > "$PROMPT_DIR/deploy.md" << 'DEPLOYEOF'
Deployment Pipeline:

1. Pre-deploy: backup database, verify env vars
2. Deploy: to staging/production
3. Post-deploy: smoke tests, monitor errors
4. Notifications: team alert on success/failure
5. Tag release if production

Show status for each phase.
DEPLOYEOF

# 3. Add aliases to shell config
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
fi

if [ -n "$SHELL_CONFIG" ]; then
    echo "" >> "$SHELL_CONFIG"
    echo "# DevOps Quick Access Aliases" >> "$SHELL_CONFIG"
    echo "alias devops='claude-code \"\$(cat $PROMPT_DIR/full.md)\"'" >> "$SHELL_CONFIG"
    echo "alias devops-quick='claude-code \"\$(cat $PROMPT_DIR/quick.md)\"'" >> "$SHELL_CONFIG"
    echo "alias devops-merge='claude-code \"\$(cat $PROMPT_DIR/merge.md)\"'" >> "$SHELL_CONFIG"
    echo "alias devops-security='claude-code \"\$(cat $PROMPT_DIR/security.md)\"'" >> "$SHELL_CONFIG"
    echo "alias devops-deploy='claude-code \"\$(cat $PROMPT_DIR/deploy.md)\"'" >> "$SHELL_CONFIG"
    
    echo "✅ Added aliases to $SHELL_CONFIG"
else
    echo "⚠️ Could not find shell config file. Add aliases manually."
fi

# 4. Create project template
mkdir -p "$HOME/.devops-templates/project"
cp "$PROMPT_DIR"/*.md "$HOME/.devops-templates/project/"

cat > "$HOME/.devops-templates/project/Makefile" << 'MAKEEOF'
.PHONY: devops devops-quick devops-merge devops-security devops-deploy

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

echo ""
echo "✅ DevOps Quick Access setup complete!"
echo ""
echo "Usage:"
echo "  devops              # Run full pipeline"
echo "  devops-quick        # 30-second health check"
echo "  devops-merge        # Pre-merge checklist"
echo "  devops-security     # Security scan only"
echo "  devops-deploy       # Deployment pipeline"
echo ""
echo "Restart your terminal or run: source $SHELL_CONFIG"
echo ""
echo "To add to a project:"
echo "  cp -r ~/.devops-templates/project/.devops ."
echo "  cp ~/.devops-templates/project/Makefile ."
```

### Install:
```bash
chmod +x setup-devops-quick-access.sh
./setup-devops-quick-access.sh
```

---

## 📝 Feature Documentation Workflow (NEW!)

Automated enforcement of feature branch documentation to prevent deviation from project goals.

### Quick Commands

```bash
# Start a new feature with documentation
devops-feature-start

# Validate feature documentation before PR
devops-feature-validate
```

### How It Works

1. **GitHub Actions Workflow** - Automatically checks feature branch PRs
   - File: `.github/workflows/feature-docs-check.yml`
   - Validates: documentation exists, required sections present, minimum quality

2. **CLI Tools** - Help developers create and validate documentation
   - `devops-feature-start` - Creates branch + documentation scaffold
   - `devops-feature-validate` - Checks documentation completeness

3. **Documentation Structure**
   ```
   docs/
   ├── features/          # Feature documentation goes here
   │   └── my-feature.md
   └── templates/         # Template for new features
       └── FEATURE_TEMPLATE.md
   ```

### Required Documentation Sections

Every feature must document:
- **Overview** - What is this feature and why?
- **Goals** - How does it align with project objectives?
- **Implementation** - Technical approach and key decisions
- **Testing** - Test strategy, coverage, and edge cases

### Benefits

- ✅ **100% documentation coverage** on feature branches
- ✅ **Better alignment** with project goals and guidelines
- ✅ **Faster code reviews** (reviewers have context)
- ✅ **Easier onboarding** (new devs can read feature history)
- ✅ **Prevents deviation** from planned objectives

### Getting Started

See comprehensive guides:
- **Quick Start:** `docs/FEATURE-DOCS-README.md`
- **Complete Guide:** `docs/FEATURE-DOCUMENTATION-GUIDE.md`
- **3 Implementation Options:** `docs/FEATURE-DOCS-IMPLEMENTATION-RECOMMENDATIONS.md`

---

## 🎯 My Recommendation for You:

**Use Option 1 (Aliases) + Option 4 (Project Templates) + Option 3 (Gist for team)**

This gives you:
1. ⚡ **Fast personal access** via aliases
2. 📁 **Per-project customization** via `.devops/` folder
3. 👥 **Easy team sharing** via gist

Would you like me to:
1. Create the complete installation script?
2. Generate the actual gist files?
3. Create a GitHub repo template with everything pre-configured?
4. Build an NPM package you can publish?

Let me know which approach resonates most with your workflow!
