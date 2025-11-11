# DevOps Quick Access - Complete System

**TL;DR:** Type `devops` from anywhere to run comprehensive pipeline checks. 5-minute setup, lifetime productivity boost.

---

## 🚀 Quick Start (Choose Your Path)

### Path 1: Instant Setup (Recommended)
```bash
# Download and run installer
bash setup-devops-quick-access.sh

# Restart terminal or reload config
source ~/.zshrc  # or ~/.bashrc

# Try it!
devops-quick
```

**Result:** Commands available globally in all directories.

### Path 2: Manual Setup
```bash
# Create prompt directory
mkdir -p ~/.devops-prompts

# Copy prompt files (full.md, quick.md, merge.md, security.md, deploy.md)
# to ~/.devops-prompts/

# Add aliases to your shell config
echo 'alias devops="claude-code \"\$(cat ~/.devops-prompts/full.md)\""' >> ~/.zshrc

# Reload
source ~/.zshrc
```

### Path 3: Per-Project Setup Only
```bash
# In your project directory
mkdir -p .devops/prompts
# Copy prompt files to .devops/prompts/
# Add to Makefile or package.json scripts
make devops  # or npm run devops
```

---

## 📦 What You Get

### 5 Powerful Commands

| Command | Purpose | Time | When to Use |
|---------|---------|------|-------------|
| `devops` | Full 15-step pipeline check | 5-10 min | Before major deployments |
| `devops-quick` | Traffic light health check | 30 sec | Every morning, quick status |
| `devops-merge` | Pre-merge preparation | 3-5 min | Before creating PRs |
| `devops-security` | Security scan only | 2 min | Before commits, routine checks |
| `devops-deploy` | Deployment workflow | 10-15 min | Production deployments |

### What Each Command Checks

**devops (Full Pipeline)**
```
🔒 Secret scanning (no API keys committed)
🔒 Dependency vulnerabilities (npm audit)
✓ Build status & troubleshooting
✓ Code cleanup (console.logs, debug)
🗄️ Database backup verification
✓ Documentation updates (CHANGELOG, README)
✓ TODO/FIXME review
✓ VERSION bumping
📊 Performance checks (bundle size)
✓ CI/CD workflow verification
🧪 Smoke tests
```

**devops-quick (30-Second Check)**
```
🟢 Build | 🟢 Tests (87%) | 🟢 Deploy | 🟢 Monitoring
```
Or with issues:
```
🔴 Build FAILED | 🟢 Tests | ⚠️ Deploy SLOW | 🟢 Monitoring
```

**devops-merge (Pre-Merge)**
```
1. Verify builds passing (auto-retry if failed)
2. Run cleanup checklist
3. Update all documentation
4. Check for merge conflicts
5. Generate PR or merge command
```

**devops-security (Security Only)**
```
1. Scan for secrets (trufflehog/git-secrets)
2. Check dependency vulnerabilities
3. Verify .env not committed
4. Validate environment variables
```

**devops-deploy (Deployment)**
```
1. Pre-deploy: Backup database, verify env
2. Deploy: Execute deployment
3. Post-deploy: Run smoke tests
4. Monitor: Check errors for 15 min
5. Notify: Alert team of status
```

---

## 📂 Files Included

| File | Purpose | Size |
|------|---------|------|
| **setup-devops-quick-access.sh** | One-click installer | 13 KB |
| **DEVOPS-CHEATSHEET.txt** | Visual quick reference | 22 KB |
| **devops-quick-access.md** | Complete guide with all options | 17 KB |
| **effective-devops-prompts.md** | Advanced patterns & best practices | 22 KB |
| **security-implementation-guide.md** | Security tools setup guide | 19 KB |
| **github-actions-workflows.md** | CI/CD automation templates | 21 KB |
| **devops-pipeline-template.md** | Full pipeline prompt template | 13 KB |
| **devops-quickstart.md** | Copy-paste ready examples | 4 KB |

---

## 🎯 Recommended Setup Flow

### Day 1: Core Installation (5 minutes)
```bash
bash setup-devops-quick-access.sh
source ~/.zshrc
devops-quick  # Test it works
```

### Day 2: Add to Main Project (10 minutes)
```bash
cd /path/to/main-project
devops-add-to-project
make devops  # or npm run devops
```

### Week 1: Security Tools (30 minutes)
Follow `security-implementation-guide.md`:
- Install git-secrets
- Setup npm audit
- Create .env.example
- Add validation scripts

### Week 2: CI/CD Integration (1 hour)
Follow `github-actions-workflows.md`:
- Add workflows to .github/workflows/
- Configure secrets
- Test automation

### Month 1: Team Rollout
- Share setup script with team
- Create project-specific customizations
- Add to onboarding docs

---

## 🛠️ Customization Guide

### Per-Project Customization

1. **Add project to your system:**
```bash
cd your-project
devops-add-to-project
```

2. **Customize prompts for your project:**
```bash
# Edit project-specific prompts
vim .devops/prompts/full.md

# Add project-specific checks
echo "- [ ] Test Telegram bot responses" >> .devops/prompts/full.md
echo "- [ ] Verify affiliate links parsing" >> .devops/prompts/full.md
echo "- [ ] Check rate limiting" >> .devops/prompts/full.md
```

3. **Add to your workflow:**
```json
// package.json
{
  "scripts": {
    "precommit": "npm run devops:security",
    "prepush": "npm run devops:merge",
    "predeploy": "npm run devops"
  }
}
```

### Global Customization

Edit base prompts:
```bash
vim ~/.devops-prompts/full.md      # Full pipeline
vim ~/.devops-prompts/quick.md     # Quick check
vim ~/.devops-prompts/merge.md     # Pre-merge
vim ~/.devops-prompts/security.md  # Security
vim ~/.devops-prompts/deploy.md    # Deployment
```

---

## 🔗 Integration Options

### Git Hooks
```bash
# .git/hooks/pre-push
#!/bin/bash
claude-code "$(cat ~/.devops-prompts/merge.md)"
```

### Makefile
```makefile
.PHONY: check merge deploy

check:
	@claude-code "$$(cat .devops/prompts/full.md)"

merge:
	@claude-code "$$(cat .devops/prompts/merge.md)"

deploy:
	@claude-code "$$(cat .devops/prompts/deploy.md)"
```

### NPM Scripts
```json
{
  "scripts": {
    "check": "claude-code \"$(cat .devops/prompts/full.md)\"",
    "merge": "claude-code \"$(cat .devops/prompts/merge.md)\"",
    "deploy": "claude-code \"$(cat .devops/prompts/deploy.md)\""
  }
}
```

### GitHub Actions
See `github-actions-workflows.md` for complete CI/CD setup.

### VS Code Tasks
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "DevOps Check",
      "type": "shell",
      "command": "claude-code \"$(cat .devops/prompts/full.md)\"",
      "problemMatcher": []
    }
  ]
}
```

---

## 💡 Best Practices

### Daily Workflow

**Morning:**
```bash
devops-quick  # Check status from overnight builds
```

**Before Committing:**
```bash
devops-security  # Scan for secrets & vulnerabilities
```

**Before Creating PR:**
```bash
devops-merge  # Run full pre-merge checklist
```

**Before Deploying:**
```bash
devops  # Full pipeline validation
```

**During Deployment:**
```bash
devops-deploy  # Guided deployment with monitoring
```

### Team Workflows

1. **Standardize checks across team**
   - Share prompts via gist or repo
   - Include in project setup docs
   - Add to CI/CD for enforcement

2. **Customize per project type**
   - Frontend: Add Lighthouse, bundle size
   - Backend: Add API tests, DB migrations
   - Full-stack: Combine both

3. **Integrate with existing tools**
   - Don't replace tools, complement them
   - Use as pre-flight checks
   - Catch issues before CI/CD

---

## 🐛 Troubleshooting

### "Command not found"
```bash
# Reload shell config
source ~/.zshrc  # or ~/.bashrc

# Check aliases exist
alias | grep devops

# Re-run installer if needed
bash setup-devops-quick-access.sh
```

### "Claude Code not found"
```bash
# Install Claude Code
# Visit: https://docs.claude.com/claude-code

# Or use Claude.ai web interface instead
# (commands won't work, but prompts still useful)
```

### Prompts not loading
```bash
# Check files exist
ls ~/.devops-prompts/

# Should see: full.md, quick.md, merge.md, security.md, deploy.md

# If missing, re-run installer
bash setup-devops-quick-access.sh
```

### Want to update/reset prompts
```bash
# Backup current prompts
cp -r ~/.devops-prompts ~/.devops-prompts.backup

# Re-run installer (overwrites with defaults)
bash setup-devops-quick-access.sh

# Or manually edit
vim ~/.devops-prompts/full.md
```

---

## 📖 Documentation Index

| Document | What's Inside | Read When |
|----------|--------------|-----------|
| **DEVOPS-CHEATSHEET.txt** | Visual quick reference card | Keep handy, print it |
| **devops-quick-access.md** | All access methods & options | Planning implementation |
| **setup-devops-quick-access.sh** | Automated installer | First time setup |
| **effective-devops-prompts.md** | Advanced patterns & examples | Learning best practices |
| **security-implementation-guide.md** | Tool setup & configuration | Adding security scans |
| **github-actions-workflows.md** | CI/CD automation | Setting up automation |
| **devops-pipeline-template.md** | Detailed pipeline prompt | Understanding what runs |
| **devops-quickstart.md** | Copy-paste examples | Need quick examples |

---

## 🎓 Learning Path

### Beginner (Week 1)
1. Run `setup-devops-quick-access.sh`
2. Use `devops-quick` daily
3. Read `DEVOPS-CHEATSHEET.txt`
4. Try `devops-merge` before next PR

### Intermediate (Month 1)
1. Add to one project: `devops-add-to-project`
2. Customize prompts for your needs
3. Set up security tools from guide
4. Share with team

### Advanced (Month 2+)
1. Integrate with CI/CD (GitHub Actions)
2. Create custom project templates
3. Build team-specific workflows
4. Contribute improvements back

---

## 🚢 Deployment Strategy

### Phase 1: Personal Use (You)
- Install on your machine
- Use for your projects
- Refine based on your workflow

### Phase 2: Project Integration (Your Repos)
- Add to main projects
- Customize per project
- Add to CI/CD

### Phase 3: Team Adoption (Your Team)
- Share setup script
- Add to onboarding
- Create team standards

### Phase 4: Organization-Wide (Company)
- Publish internal package
- Standardize across teams
- Measure impact metrics

---

## 📊 Success Metrics

Track these to measure impact:

- **Time saved**: Manual checks vs automated
- **Issues caught**: Before vs after implementation
- **Deploy confidence**: Failed deploys before/after
- **Team adoption**: % of team using regularly
- **Incident reduction**: Production issues over time

---

## 🤝 Contributing & Sharing

### Share with Team
```bash
# Option 1: GitHub Gist
# Create gist with all prompt files
# Share install link: curl -L gist-url/install.sh | bash

# Option 2: Internal Repo
git init devops-toolkit
cp ~/.devops-prompts/* devops-toolkit/
git add . && git commit -m "Initial toolkit"
git push origin main

# Option 3: NPM Package
npm init
# Add scripts, publish
npm publish @yourcompany/devops-cli
```

### Customize & Improve
```bash
# Edit prompts to fit your stack
# Add company-specific checks
# Share improvements back
# Build internal best practices
```

---

## 🎉 You're Ready!

**Next Steps:**

1. **Install**: `bash setup-devops-quick-access.sh`
2. **Test**: `devops-quick`
3. **Use**: Add to your daily workflow
4. **Customize**: Edit prompts for your needs
5. **Share**: Roll out to team

**Questions?** Check:
- Cheat sheet: `cat ~/.devops-prompts/CHEATSHEET.txt`
- Quick ref: `cat ~/.devops-prompts/QUICKREF.md`
- Full docs: All `.md` files in outputs directory

---

## 📞 Support & Updates

**Get Help:**
- Check troubleshooting section above
- Review documentation files
- Test individual components

**Stay Updated:**
- Bookmark installer script location
- Check for prompt improvements
- Share learnings with team

---

**Happy DevOps-ing! 🚀**

_Making professional DevOps practices accessible to everyone, one command at a time._
