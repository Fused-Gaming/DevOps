# Production DevOps Pipeline - Automated Health Check & Merge

## Execution Instructions
Run this prompt after completing feature development to automate the entire merge preparation workflow.

---

## Primary Objective
Check the status of our last commit. If build logs show success, proceed with cleanup and merge preparation. If failures exist, troubleshoot and retry until resolved.

---

## Phase 1: Build Status Verification

### Step 1.1: Check Last Commit
```bash
git log -1 --oneline
git status --short
```

### Step 1.2: Fetch CI/CD Build Status
Query GitHub Actions / GitLab CI / Jenkins for latest build:
- Build ID
- Status (success/failure/running)
- Duration
- Error logs (if failed)

### Step 1.3: Parse Build Logs
If build failed:
- Extract error messages
- Identify failure category (lint, test, build, deploy)
- Apply automated fix
- Commit fix with message: `fix(ci): resolve {issue_type} - automated fix`
- Push and wait for new build
- **LOOP back to Step 1.2** until build passes

---

## Phase 2: Pre-Merge Checklist with Progress Bar

Only execute if all builds are passing.

Display real-time progress with this format:
```
╔═══════════════════════════════════════════════════════════════╗
║          Pre-Merge Checklist - Progress Tracker               ║
╚═══════════════════════════════════════════════════════════════╝

[█░░░░░░░░░] 1/10 Cleanup scripts (removing debug code & temp files)
[██░░░░░░░░] 2/10 Update CHANGELOG.md
[███░░░░░░░] 3/10 Update PROJECT_STATUS.md
[████░░░░░░] 4/10 Update README.md
[█████░░░░░] 5/10 Check unfinished deliverables (scan for TODO/FIXME)
[██████░░░░] 6/10 Update VERSION file
[███████░░░] 7/10 Organize project root (move stray .md to /docs)
[████████░░] 8/10 Wait for GitHub Actions completion
[█████████░] 9/10 Troubleshoot any workflow failures
[██████████] 10/10 Final verification complete

Status: ✓ ALL CHECKS PASSED - Ready for merge
```

### Detailed Steps:

#### 2.1: Cleanup Scripts
**Action**: Remove all debug artifacts
```bash
# Remove debug code
grep -r "console.log" src/ --exclude-dir=node_modules
grep -r "debugger" src/ --exclude-dir=node_modules
# Remove temp files
find . -name "*.tmp" -o -name "*.log" -o -name ".DS_Store" | xargs rm -f
```
**Verify**: No console.logs, no temp files
**Status**: [✓] or [✗]

#### 2.2: Update CHANGELOG.md
**Action**: Generate changelog from commits
```bash
# Get commits since last tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Format for CHANGELOG.md:
## [Version X.Y.Z] - 2025-11-10
### Added
- Feature descriptions

### Changed
- Updates

### Fixed  
- Bug fixes
```
**Verify**: CHANGELOG.md has entry for current version
**Status**: [✓] or [✗]

#### 2.3: Update PROJECT_STATUS.md
**Action**: Update project tracking file
```markdown
# Project Status - Updated: 2025-11-10

## Current Sprint
Sprint: 23
Status: 80% complete

## Completed This Week
- [x] Feature: User authentication
- [x] Bug fix: Payment processing timeout

## In Progress
- [ ] Feature: Email notifications

## Blocked
None

## Metrics
- Code coverage: 87%
- Build time: 2m 34s
- Open issues: 12
- PRs pending: 3
```
**Status**: [✓] or [✗]

#### 2.4: Update README.md
**Action**: Ensure README is current
Check for:
- Installation instructions match current setup
- Environment variables list is complete
- API documentation links work
- Screenshots/demos are up-to-date
- Contributing guide exists

**Updates needed**: List any found
**Status**: [✓] or [✗]

#### 2.5: Check Unfinished Deliverables
**Action**: Scan codebase for incomplete work
```bash
# Find TODO comments
grep -rn "TODO" src/ --exclude-dir=node_modules

# Find FIXME comments  
grep -rn "FIXME" src/ --exclude-dir=node_modules

# Find XXX comments
grep -rn "XXX" src/ --exclude-dir=node_modules
```

**Analysis**: 
For each TODO/FIXME found:
- Is it blocking merge? (Critical vs. Nice-to-have)
- Create GitHub issue if needed
- Add issue number to TODO comment

**Status**: [✓] or [⚠] with issue links

#### 2.6: Update VERSION File
**Action**: Increment version using semantic versioning

Current version: Read from `package.json` or `VERSION` file

Determine version bump:
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

New version: X.Y.Z

Update files:
- package.json
- VERSION
- Any config files referencing version

**Status**: [✓] or [✗]

#### 2.7: Organize Project Root
**Action**: Clean up project root directory
```bash
# List files in root
ls -la | grep "\.md$"

# Move to appropriate locations:
# .md files → /docs (except README.md, CHANGELOG.md, LICENSE.md)
# .txt files → /docs or delete if temporary
```

**Actions taken**:
- Moved: file1.md → docs/file1.md
- Deleted: temp_notes.txt

**Status**: [✓] or [✗]

#### 2.8: Wait for GitHub Actions Completion
**Action**: Poll GitHub Actions API
```bash
# Get workflow runs
gh run list --limit 5

# Wait for in-progress runs
while [ $(gh run list --json status --jq '.[] | select(.status=="in_progress") | .status' | wc -l) -gt 0 ]; do
  echo "Waiting for workflows to complete..."
  sleep 10
done
```

**Status**: 
- Completed: X workflows
- Failed: Y workflows (if Y > 0, proceed to 2.9)
- Status: [✓] or [⚠]

#### 2.9: Troubleshoot Workflow Failures
**Action**: If step 2.8 found failures

For each failed workflow:
1. Download logs: `gh run view {run_id} --log`
2. Parse error message
3. Identify failure type:
   - Test failure → Fix test or code
   - Lint failure → Run `npm run lint:fix`
   - Build failure → Check dependencies
   - Deploy failure → Check credentials/config
4. Apply fix
5. Push commit: `fix(ci): resolve {workflow_name} failure`
6. **LOOP to Step 2.8** - Wait for new run

Maximum retries: 3
If still failing after 3 attempts: **HALT and report for manual intervention**

**Status**: [✓] All workflows passing or [✗] Manual intervention required

#### 2.10: Final Verification
**Action**: Comprehensive final check
- [ ] All previous steps completed successfully
- [ ] No uncommitted changes: `git status`
- [ ] Branch is up-to-date with origin
- [ ] All CI/CD workflows passing
- [ ] No merge conflicts with target branch

**Status**: [✓] or [✗]

---

## Phase 3: Merge Readiness Assessment

### Step 3.1: Check Merge Conflicts
```bash
git fetch origin main  # or develop
git merge-base --is-ancestor HEAD origin/main
```

**Result**:
- No conflicts: Proceed to 3.2
- Conflicts detected: Show conflicted files, offer to resolve

### Step 3.2: Generate Merge Strategy
Based on project workflow (Git Flow, GitHub Flow, etc.):

**Option A: Direct Merge**
```bash
git checkout main
git merge feature/branch-name --no-ff
git push origin main
```

**Option B: Pull Request**
```bash
gh pr create \
  --title "Feature: {description}" \
  --body "$(cat .github/pull_request_template.md)" \
  --base main \
  --head feature/branch-name
```

**Recommended**: Option B (Pull Request)
**Status**: Awaiting user confirmation

### Step 3.3: Execute Merge
After user approval:
1. Create PR or merge directly
2. Verify merge succeeded
3. Check post-merge CI/CD triggers
4. Monitor for immediate issues

**Status**: [✓] Merged or [⏳] Awaiting approval

---

## Phase 4: Post-Merge Cleanup

### Step 4.1: Delete Feature Branch
```bash
git branch -d feature/branch-name  # Local
git push origin --delete feature/branch-name  # Remote
```

### Step 4.2: Pull Latest Changes
```bash
git checkout main
git pull origin main
```

### Step 4.3: Verify Deployment
Check deployment environment:
- Staging deployment successful?
- Production deployment triggered?
- Health checks passing?

### Step 4.4: Create Release Tag (if applicable)
```bash
git tag -a v{X.Y.Z} -m "Release version {X.Y.Z}"
git push origin v{X.Y.Z}
```

---

## Phase 5: Final Report

Generate comprehensive summary:

```
╔═══════════════════════════════════════════════════════════════╗
║                    MERGE COMPLETION REPORT                    ║
╚═══════════════════════════════════════════════════════════════╝

Branch: feature/new-checkout-flow
Merged to: main
Timestamp: 2025-11-10 04:20:35 UTC

📊 Statistics
─────────────────────────────────────────────────────────────────
Total execution time: 8m 42s
Commits merged: 14
Files changed: 27
Lines added: +892
Lines removed: -234
Tests passed: 347/347
Code coverage: 87.3%

✅ Completed Tasks
─────────────────────────────────────────────────────────────────
[✓] Build status verified
[✓] All workflows passing
[✓] Cleanup scripts executed
[✓] CHANGELOG.md updated
[✓] PROJECT_STATUS.md updated
[✓] README.md updated
[✓] Deliverables verified (2 TODOs converted to issues)
[✓] VERSION bumped: 1.4.2 → 1.5.0
[✓] Project root organized (3 files moved to /docs)
[✓] Merge completed successfully
[✓] Feature branch deleted
[✓] Release tag created: v1.5.0

🚀 Deployments
─────────────────────────────────────────────────────────────────
Staging: ✓ Deployed successfully
Production: ⏳ Scheduled for 2025-11-10 18:00 UTC

🔗 Links
─────────────────────────────────────────────────────────────────
PR: https://github.com/user/repo/pull/123
Release: https://github.com/user/repo/releases/tag/v1.5.0
Staging: https://staging.example.com
Changelog: https://github.com/user/repo/blob/main/CHANGELOG.md

⚠️ Action Items
─────────────────────────────────────────────────────────────────
1. Monitor production deployment at 18:00 UTC
2. Review 2 TODO issues created:
   - #456: Optimize database queries
   - #457: Add email notification feature

✅ MERGE PROCESS COMPLETED SUCCESSFULLY
```

---

## Error Handling & Recovery

### If Build Fails (Phase 1)
- Maximum 5 auto-fix attempts
- After 5 failures: Generate detailed error report and halt
- Save logs to: `logs/build-failure-{timestamp}.log`

### If Checklist Step Fails (Phase 2)
- Mark step as failed
- Continue with remaining steps
- Generate summary of all failures at end
- Require manual review before merge

### If Merge Conflicts (Phase 3)
- Show conflict diff
- Offer automated conflict resolution for simple cases
- For complex conflicts: Halt and request manual resolution

### Emergency Abort
User can type `ABORT` at any time to:
1. Stop current operation
2. Save progress state to `.devops-checkpoint.json`
3. Provide resume command

---

## Configuration

### Customization Options
Edit these at the top of the script:

```bash
# Project settings
PROJECT_TYPE="nextjs"  # nextjs, react, node, python
VERSION_FILE="package.json"
MAIN_BRANCH="main"
CI_PLATFORM="github_actions"  # github_actions, gitlab_ci, jenkins

# Behavior settings
AUTO_FIX_ATTEMPTS=5
REQUIRE_PR=true
AUTO_DELETE_BRANCH=true
TAG_RELEASES=true

# Notification settings  
NOTIFY_ON_SUCCESS=true
NOTIFY_ON_FAILURE=true
SLACK_WEBHOOK_URL="https://hooks.slack.com/..."
```

---

## Resume from Checkpoint

If interrupted, resume with:
```bash
claude-devops --resume .devops-checkpoint.json
```

This will:
1. Load saved state
2. Skip completed steps
3. Continue from last step

---

## Logs & Audit Trail

All operations logged to:
- Console output: Real-time progress
- File: `logs/devops-{timestamp}.log`
- JSON: `.devops-state.json` (machine-readable)

Log retention: 30 days
Log rotation: Daily

---

## Success Criteria

✅ Merge considered successful when:
1. All builds passing
2. All checklist items completed (or waived with justification)
3. No merge conflicts
4. Feature branch merged to main
5. Post-merge CI/CD triggered
6. No immediate errors in deployment

🎉 **READY TO EXECUTE** - Run this prompt to begin automated pipeline
