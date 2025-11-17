# Automatic PR & Commit Message Generation

**Version:** 1.0.0
**Created:** 2025-11-17
**Purpose:** Automated generation of PR descriptions and commit messages

---

## Overview

This system provides automatic generation of:
1. **Commit Messages** - AI-assisted commit message suggestions based on staged changes
2. **PR Descriptions** - Automated PR description generation based on commits
3. **Commit Linting** - Validation of commit message format

## Features

### 🤖 Automatic PR Description Generation

When you open a PR, GitHub Actions automatically:
- ✅ Analyzes all commits in the PR
- ✅ Categorizes commits by type (feat, fix, docs, etc.)
- ✅ Generates statistics (files changed, insertions, deletions)
- ✅ Creates a comprehensive PR description
- ✅ Adds a summary comment

**Workflow:** `.github/workflows/auto-pr-description.yml`

### ✍️ Commit Message Generator

Interactive script that helps you write better commit messages:
- ✅ Analyzes staged changes
- ✅ Detects change type automatically
- ✅ Suggests commit message
- ✅ Provides statistics
- ✅ Follows conventional commits format

**Script:** `scripts/generate-commit-message.sh`

### 🔍 Commit Message Linting

Validates all commits in a PR:
- ✅ Checks format: `type: description`
- ✅ Validates commit types
- ✅ Checks subject length (max 72 chars)
- ✅ Warns about capitalization
- ✅ Provides helpful error messages

**Workflow:** `.github/workflows/commit-lint.yml`

### 📝 PR Description Generator

Script to generate PR descriptions locally:
- ✅ Compares current branch to base
- ✅ Analyzes all commits
- ✅ Generates comprehensive description
- ✅ Includes statistics and history
- ✅ Saves to `.github/PR_DESCRIPTION_GENERATED.md`

**Script:** `scripts/generate-pr-description.sh`

---

## Usage

### Method 1: Automatic (GitHub Actions)

**For PR Descriptions:**

Simply open a PR, and the workflow will automatically:
1. Analyze your commits
2. Generate a description
3. Update the PR body
4. Add a comment with statistics

**No manual action needed!**

**For Commit Validation:**

All PRs are automatically validated:
- Commits must follow format: `type: description`
- Invalid commits will fail the check
- Helpful error messages guide you to fix issues

### Method 2: Manual Scripts (Local)

#### Generate Commit Message

```bash
# Stage your changes
git add .

# Generate commit message
./scripts/generate-commit-message.sh
```

**The script will:**
1. Analyze staged changes
2. Detect change type (feat, fix, docs, etc.)
3. Suggest a commit message
4. Show statistics
5. Let you choose:
   - Edit in editor
   - Use as-is
   - Provide custom message
   - Cancel

**Example Output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Commit Message Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Analyzing staged changes...

📊 Change Summary:
  Files changed: 5
  Insertions: +245
  Deletions: -12

📝 Detected Commit Type: feat

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Suggested Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

feat: add automation scripts

Changed files:
- scripts/generate-commit-message.sh
- scripts/generate-pr-description.sh
- .github/workflows/auto-pr-description.yml
- .github/workflows/commit-lint.yml
- docs/AUTO-PR-COMMIT-GUIDE.md

Statistics:
- 5 files changed
- 245 insertions(+)
- 12 deletions(-)

Options:
  1. Use this message (edit in editor)
  2. Use this message as-is
  3. Provide custom message
  4. Cancel

Choose option (1-4):
```

#### Generate PR Description

```bash
# From your feature branch
./scripts/generate-pr-description.sh

# Or specify base branch
./scripts/generate-pr-description.sh main
```

**The script will:**
1. Analyze commits between branches
2. Categorize commits by type
3. Generate statistics
4. Create comprehensive description
5. Save to `.github/PR_DESCRIPTION_GENERATED.md`
6. Let you choose:
   - Edit in editor
   - Use as-is
   - Create PR now (with gh CLI)
   - Save and exit

**Example Output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pull Request Description Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current branch: feature/auto-pr-generation
Base branch: main

Analyzing commits...
Found 7 commit(s)

Generating PR title...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ PR Description Generated
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Title:
feat: add automation scripts for PR and commit generation

Description saved to:
.github/PR_DESCRIPTION_GENERATED.md

Options:
  1. Edit in editor
  2. Use as-is
  3. Create PR now (requires gh CLI)
  4. Save and exit

Choose option (1-4):
```

---

## Commit Message Format

### Conventional Commits

All commit messages must follow this format:

```
<type>: <description>

[optional body]

[optional footer]
```

### Valid Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat: add user authentication` |
| `fix` | Bug fix | `fix: resolve null pointer exception` |
| `docs` | Documentation | `docs: update installation guide` |
| `style` | Formatting changes | `style: fix indentation` |
| `refactor` | Code restructuring | `refactor: simplify validation logic` |
| `perf` | Performance improvement | `perf: optimize database queries` |
| `test` | Add/update tests | `test: add unit tests for auth` |
| `chore` | Maintenance | `chore: update dependencies` |
| `build` | Build system changes | `build: update webpack config` |
| `ci` | CI/CD changes | `ci: add new workflow` |
| `revert` | Revert previous commit | `revert: undo feature X` |

### Rules

1. **Type is required** - Must be one of the valid types
2. **Description is required** - Brief summary of the change
3. **Lowercase description** - Start with lowercase letter
4. **Imperative mood** - "add" not "added", "fix" not "fixed"
5. **Max 72 chars** - Keep subject line concise
6. **No period at end** - Don't end subject with period

### Examples

**Good:**
```
feat: add automatic PR description generation
fix: resolve issue with commit parsing
docs: add guide for PR automation
chore: update GitHub Actions workflows
```

**Bad:**
```
Add feature              ❌ Missing type
feat Add feature         ❌ Missing colon
feat: Add Feature        ❌ Capitalized description
feat: added feature      ❌ Past tense
Feature: add something   ❌ Invalid type
```

---

## GitHub Actions Workflows

### Auto PR Description

**File:** `.github/workflows/auto-pr-description.yml`

**Triggers:**
- When PR is opened

**Actions:**
1. Checkout code with full history
2. Analyze commits between base and head
3. Categorize commits by type
4. Generate statistics
5. Build comprehensive description
6. Update PR body
7. Add summary comment

**Permissions Required:**
- `pull-requests: write` - To update PR
- `contents: read` - To read commits

**Example Generated Description:**

```markdown
<!-- AUTO-GENERATED -->
## Summary

This PR includes 7 commit(s) with 5 file(s) changed.

## 📋 What's New

### ✨ Features

- add automatic PR description generation
- add commit message generator script

### 📚 Documentation

- add comprehensive guide for automation

## 📊 Statistics

**Changes:**
- **5 files changed**
- **245+ lines added**
- **12- lines removed**

**Commits:**
- Total: 7
- Features: 2
- Documentation: 1

## 📝 Commit History

- `a1b2c3d` feat: add automatic PR description generation
- `e4f5g6h` feat: add commit message generator script
- `i7j8k9l` docs: add comprehensive guide for automation

## ✅ Testing

- [ ] Manual testing completed
- [ ] No regressions found
- [ ] Integration verified
- [ ] Documentation updated
```

### Commit Lint

**File:** `.github/workflows/commit-lint.yml`

**Triggers:**
- When PR is opened
- When PR is synchronized (new commits)
- When PR is reopened

**Actions:**
1. Checkout code with full history
2. Get all commits in PR
3. Validate each commit message
4. Check format, type, length
5. Report errors and warnings
6. Comment on PR if validation fails

**Validation Rules:**
- ✅ Format: `type: description`
- ✅ Valid type from allowed list
- ⚠️ Subject length ≤ 72 characters
- ⚠️ Description starts with lowercase

**Example Comment on Failure:**

```markdown
## ❌ Commit Message Validation Failed

Some commits don't follow the required format.

**Required Format:**
```
<type>: <description>
```

**Valid Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
...

**Examples:**
```
feat: add user authentication
fix: resolve null pointer exception
docs: update installation guide
```

Use our commit message generator:
```bash
./scripts/generate-commit-message.sh
```
```

---

## Configuration

### Customize Auto PR Description

Edit `.github/workflows/auto-pr-description.yml`:

**Skip auto-generation for certain PRs:**
```yaml
- name: Check if should skip
  if: contains(github.event.pull_request.labels.*.name, 'skip-auto-description')
  run: echo "Skipping auto-generation"
```

**Customize description template:**

Modify the `Generate Enhanced Description` step:
```javascript
enhancedBody += '## Custom Section\n\n';
enhancedBody += 'Your custom content here\n\n';
```

### Customize Commit Linting

Edit `.github/workflows/commit-lint.yml`:

**Add custom types:**
```bash
VALID_TYPES="feat|fix|docs|custom1|custom2"
```

**Adjust length limit:**
```bash
if [ $LENGTH -gt 100 ]; then  # Changed from 72
  echo "  ⚠ WARNING: Subject too long"
fi
```

### Customize Scripts

Both scripts support environment variables:

**Commit Message Generator:**
```bash
export EDITOR=vim  # Default editor for editing messages
./scripts/generate-commit-message.sh
```

**PR Description Generator:**
```bash
./scripts/generate-pr-description.sh develop  # Custom base branch
```

---

## Integration with Automation Levels

### Option 1: Full Automation

**Includes:**
- ✅ Auto PR description on PR creation
- ✅ Commit message linting
- ✅ Auto-comment with statistics

**Setup:**
Already enabled via GitHub Actions workflows.

### Option 2: Smart Wizard

**Includes:**
- ✅ Manual commit message generator script
- ✅ Manual PR description generator script
- ✅ Local validation before push

**Setup:**
```bash
# Add to your workflow
./scripts/generate-commit-message.sh  # Before committing
./scripts/generate-pr-description.sh  # Before creating PR
```

### Option 3: Lite Templates

**Includes:**
- Templates for commit messages
- Templates for PR descriptions

**Setup:**
Use generated files as templates:
```bash
# View generated commit message
cat /tmp/commit_msg_*.tmp

# View generated PR description
cat .github/PR_DESCRIPTION_GENERATED.md
```

---

## Troubleshooting

### Commit Message Generator Issues

**Problem:** "No staged changes found"
```bash
# Solution: Stage your changes first
git add .
./scripts/generate-commit-message.sh
```

**Problem:** Script suggests wrong type
```bash
# Solution: Choose option 3 to provide custom message
# Or edit the generated message (option 1)
```

### PR Description Generator Issues

**Problem:** "Base branch not found"
```bash
# Solution: Fetch remote branches
git fetch origin
./scripts/generate-pr-description.sh main
```

**Problem:** "No commits found"
```bash
# Solution: Make sure you're on a feature branch
git checkout -b feature/my-feature
# Make commits
./scripts/generate-pr-description.sh
```

### GitHub Actions Issues

**Problem:** Workflow doesn't trigger
- Check workflow file syntax
- Verify permissions are set correctly
- Check if PR is from a fork (limited permissions)

**Problem:** Description not updated
- Check if PR already has `<!-- AUTO-GENERATED -->` marker
- Verify workflow has write permissions
- Check workflow logs for errors

---

## Examples

### Example 1: Feature Development

```bash
# 1. Create feature branch
git checkout -b feature/user-auth

# 2. Make changes
# ... edit files ...

# 3. Generate commit message
git add .
./scripts/generate-commit-message.sh
# Choose option 1 to edit, option 2 to use as-is

# 4. Push changes
git push -u origin feature/user-auth

# 5. Generate PR description
./scripts/generate-pr-description.sh main
# Review generated description

# 6. Create PR (manual or with gh CLI)
gh pr create --title "feat: add user authentication" \
  --body-file .github/PR_DESCRIPTION_GENERATED.md

# 7. Auto-description workflow enhances PR automatically
```

### Example 2: Bug Fix

```bash
# 1. Create fix branch
git checkout -b fix/null-pointer

# 2. Fix the bug
# ... edit files ...

# 3. Generate commit message
git add .
./scripts/generate-commit-message.sh
# Script detects "fix" in diff and suggests: "fix: resolve null pointer exception"

# 4. Commit
# Choose option 2 to use suggested message

# 5. Push and create PR
git push -u origin fix/null-pointer
gh pr create --base main

# 6. Workflows automatically:
#    - Generate enhanced description
#    - Validate commit messages
#    - Add statistics comment
```

### Example 3: Documentation Update

```bash
# 1. Create docs branch
git checkout -b docs/update-guide

# 2. Update documentation
# ... edit .md files ...

# 3. Generate commit message
git add .
./scripts/generate-commit-message.sh
# Script detects .md files and suggests: "docs: update installation guide"

# 4. Review and commit
# Choose option 1 to edit and add details

# 5. Create PR
./scripts/generate-pr-description.sh
gh pr create --body-file .github/PR_DESCRIPTION_GENERATED.md

# 6. Auto-enhancement adds:
#    - Documentation section
#    - File statistics
#    - Commit history
```

---

## Best Practices

### For Commit Messages

1. **Be descriptive** - Explain what and why, not how
2. **Keep it short** - Subject under 72 chars
3. **Use imperative mood** - "add" not "added"
4. **One commit per logical change** - Don't combine unrelated changes
5. **Use the generator** - Let the script help you

### For PR Descriptions

1. **Let automation help** - Use generated descriptions as base
2. **Review and enhance** - Add context automation can't know
3. **Update checklists** - Mark completed items
4. **Add screenshots** - For UI changes
5. **Link related issues** - Use "Fixes #123" syntax

### For Workflows

1. **Don't bypass linting** - Fix commit messages instead
2. **Review auto-generated content** - Edit if needed
3. **Use labels** - Add `skip-auto-description` if needed
4. **Keep workflows updated** - Customize for your needs

---

## NPM Scripts

Add to your `package.json`:

```json
{
  "scripts": {
    "commit": "./scripts/generate-commit-message.sh",
    "pr": "./scripts/generate-pr-description.sh",
    "pr:main": "./scripts/generate-pr-description.sh main",
    "pr:develop": "./scripts/generate-pr-description.sh develop"
  }
}
```

Then use:
```bash
npm run commit   # Generate commit message
npm run pr       # Generate PR description
```

---

## Advanced Usage

### Custom Commit Types

Add project-specific types:

```bash
# In scripts/generate-commit-message.sh
# Add to type detection logic:
if echo "$CHANGED_FILES" | grep -q "migrations/"; then
    TYPE="migration"
elif echo "$CHANGED_FILES" | grep -q "locales/"; then
    TYPE="i18n"
fi
```

### Pre-commit Hook

Automatically suggest commit messages:

```bash
# .git/hooks/prepare-commit-msg
#!/bin/bash
if [ -z "$(cat $1)" ]; then
    ./scripts/generate-commit-message.sh --auto > $1
fi
```

### Custom PR Templates

Combine with PR templates:

```bash
# .github/pull_request_template.md
<!-- Generated description will be appended below -->

## Additional Context

[Add any context here]
```

---

## FAQ

**Q: Will auto-generation overwrite my PR description?**
A: No. If your PR already has content, it's appended below a separator line. If you add `<!-- AUTO-GENERATED -->` marker, it won't run again.

**Q: Can I disable auto-generation for specific PRs?**
A: Yes. Add label `skip-auto-description` or add `<!-- AUTO-GENERATED -->` to your description.

**Q: Do commit messages need to be perfect?**
A: Linting will fail for invalid format, but warnings (length, capitalization) don't block merging.

**Q: Can I use this with other version control systems?**
A: The scripts work with git only. Workflows are GitHub-specific.

**Q: How do I test scripts locally?**
A: Just run them! They're safe and don't modify anything until you confirm.

---

## Support

**Issues:** https://github.com/Fused-Gaming/DevOps/issues
**Documentation:** This file
**Scripts:** `scripts/generate-*.sh`
**Workflows:** `.github/workflows/`

---

**Version:** 1.0.0
**Last Updated:** 2025-11-17
**Maintained By:** Fused Gaming
