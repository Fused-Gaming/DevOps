# PR & Commit Generation - Quick Reference

## 🚀 Quick Commands

```bash
# Generate commit message
./scripts/generate-commit-message.sh

# Generate PR description
./scripts/generate-pr-description.sh

# Generate PR description (specify base)
./scripts/generate-pr-description.sh main
```

## 📝 Commit Format

```
<type>: <description>
```

**Valid Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `chore` - Maintenance
- `test` - Tests
- `refactor` - Refactoring
- `perf` - Performance
- `style` - Formatting
- `build` - Build system
- `ci` - CI/CD

**Examples:**
```
feat: add user authentication
fix: resolve memory leak
docs: update API guide
```

## 🤖 Automatic Features

### On PR Creation
- ✅ Auto-generates description
- ✅ Analyzes commits
- ✅ Adds statistics
- ✅ Comments summary

### On PR Update
- ✅ Validates commit messages
- ✅ Checks format
- ✅ Reports errors

## ✅ Workflow

1. **Make changes**
2. **Stage:** `git add .`
3. **Generate commit:** `./scripts/generate-commit-message.sh`
4. **Push:** `git push`
5. **Generate PR:** `./scripts/generate-pr-description.sh`
6. **Create PR:** Automatic enhancement!

## 🔧 NPM Scripts (Optional)

```json
{
  "scripts": {
    "commit": "./scripts/generate-commit-message.sh",
    "pr": "./scripts/generate-pr-description.sh"
  }
}
```

Then: `npm run commit` or `npm run pr`

---

**Full Guide:** [AUTO-PR-COMMIT-GUIDE.md](AUTO-PR-COMMIT-GUIDE.md)
