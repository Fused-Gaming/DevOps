# Quick DevOps Pipeline - Copy & Paste Ready

Use this single prompt in Claude Code or Claude.ai:

---

```markdown
# DevOps Pipeline: Pre-Merge Automation

Execute the following workflow with progress tracking:

## Step 1: Verify Build Status
Check last commit and CI/CD status:
- Run: `git log -1 --oneline && git status`
- Fetch latest build status from GitHub Actions
- If build failed: troubleshoot, fix, commit, push, retry
- Loop until all builds pass

## Step 2: Pre-Merge Checklist (Only if builds pass)

Execute with progress bar:

```
[█░░░░░░░░░] 1/9 Cleanup: Remove console.logs, debug code, temp files
[██░░░░░░░░] 2/9 Update CHANGELOG.md with recent commits
[███░░░░░░░] 3/9 Update PROJECT_STATUS.md with sprint progress  
[████░░░░░░] 4/9 Update README.md (verify instructions current)
[█████░░░░░] 5/9 Scan for TODO/FIXME, create issues if needed
[██████░░░░] 6/9 Update VERSION file (semantic versioning)
[███████░░░] 7/9 Organize root: move .md files to /docs
[████████░░] 8/9 Wait for all GitHub Actions to complete
[█████████░] 9/9 Troubleshoot any failures (max 3 retries)
```

For each step:
1. Execute the action
2. Verify completion
3. Mark as ✓ or ✗
4. Log any issues

## Step 3: Merge Readiness
If all checks pass:
- Check for merge conflicts with main
- Verify branch is up-to-date
- Generate merge command or create PR
- Print summary and await approval

## Step 4: Post-Merge (After approval)
- Delete feature branch
- Pull latest changes  
- Verify deployment triggered
- Create release tag

## Error Handling
- Auto-retry build failures (max 5 attempts)
- Halt on unresolvable errors
- Save state to `.devops-checkpoint.json`
- Generate detailed report

Print final report with:
- Execution time
- Tasks completed
- Any warnings/errors
- Links to PR, deployment, changelog
```

---

## Even Shorter Version (30-Second Check)

For quick status checks:

```markdown
DevOps Quick Check:

1. Last commit status: `git log -1 --oneline`
2. CI/CD status: Check GitHub Actions
3. Coverage: Check latest test report
4. Alerts: Any monitoring alerts?

Print 4-line summary:
🟢 Build | 🟢 Tests | 🟢 Deploy | 🟢 Monitoring
or
🔴 Build FAILED | 🟢 Tests | ⚠️ Deploy SLOW | 🟢 Monitoring

With one-line description of any issues.
```

---

## Claude Code Terminal Command

Save prompt to file and run:

```bash
# Create prompt file
cat > .claude/merge-pipeline.md << 'EOF'
[Paste the full prompt here]
EOF

# Run with Claude Code
claude-code "$(cat .claude/merge-pipeline.md)"

# Or run inline
claude-code "Execute DevOps pipeline: check build status, run pre-merge checklist, verify merge readiness"
```

---

## Customization Quick Edits

Edit these lines for your project:

```bash
MAIN_BRANCH="main"           # Change to "develop" if needed
MIN_COVERAGE=80              # Minimum test coverage %
VERSION_FILE="package.json"  # Or "VERSION", "pyproject.toml"
DOCS_FOLDER="docs"           # Where to move .md files
MAX_RETRIES=5                # Build failure retry limit
```

---

## Pro Tips

1. **Save as Git Hook**: Create `.git/hooks/pre-push` with this workflow
2. **Cron Job**: Run nightly to catch issues early
3. **PR Template**: Add checklist to `.github/pull_request_template.md`
4. **Notifications**: Add Slack webhook for completion alerts

---

## Troubleshooting Common Issues

### Build Hangs
Add timeout: `timeout 300 npm run build` (5 min max)

### GitHub Actions Not Accessible
Use local checks: `npm run lint && npm test && npm run build`

### Merge Conflicts
Run: `git merge main --no-commit` to preview conflicts

### Missing Dependencies
Run: `npm install` or `pip install -r requirements.txt`

---

## One-Liner for Daily Use

```bash
claude-code "Check last commit status. If builds pass, run pre-merge checklist (cleanup, update docs, organize files, verify workflows). Print progress bar. Report merge readiness."
```

That's it! Copy, paste, customize, and run. 🚀
