#!/bin/bash
# Automatic PR Description Generator
# Analyzes commits and generates comprehensive PR descriptions

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Pull Request Description Generator${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get base branch (default to main)
BASE_BRANCH=${1:-main}
CURRENT_BRANCH=$(git branch --show-current)

echo -e "${CYAN}Current branch: ${YELLOW}$CURRENT_BRANCH${NC}"
echo -e "${CYAN}Base branch: ${YELLOW}$BASE_BRANCH${NC}"
echo ""

# Check if we can compare
if ! git rev-parse "$BASE_BRANCH" &>/dev/null; then
    echo -e "${YELLOW}⚠ Base branch '$BASE_BRANCH' not found${NC}"
    echo ""
    echo "Available branches:"
    git branch -a | grep -v HEAD
    exit 1
fi

# Get commit range
echo -e "${CYAN}Analyzing commits...${NC}"
COMMITS=$(git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH")
COMMIT_COUNT=$(echo "$COMMITS" | wc -l | tr -d ' ')

if [ "$COMMIT_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}⚠ No commits found between $BASE_BRANCH and $CURRENT_BRANCH${NC}"
    exit 1
fi

echo -e "${GREEN}Found $COMMIT_COUNT commit(s)${NC}"
echo ""

# Get statistics
FILES_CHANGED=$(git diff --stat "$BASE_BRANCH"..."$CURRENT_BRANCH" | tail -1 | awk '{print $1}')
INSERTIONS=$(git diff --stat "$BASE_BRANCH"..."$CURRENT_BRANCH" | tail -1 | awk '{print $4}' | tr -d '+')
DELETIONS=$(git diff --stat "$BASE_BRANCH"..."$CURRENT_BRANCH" | tail -1 | awk '{print $6}' | tr -d '-')

# Analyze file types
DOCS_FILES=$(git diff --name-only "$BASE_BRANCH"..."$CURRENT_BRANCH" | grep -E '\.(md|txt|rst)$' | wc -l | tr -d ' ')
CODE_FILES=$(git diff --name-only "$BASE_BRANCH"..."$CURRENT_BRANCH" | grep -E '\.(js|ts|py|sh|rb|go|java)$' | wc -l | tr -d ' ')
CONFIG_FILES=$(git diff --name-only "$BASE_BRANCH"..."$CURRENT_BRANCH" | grep -E '\.(json|yml|yaml|toml)$' | wc -l | tr -d ' ')
TEST_FILES=$(git diff --name-only "$BASE_BRANCH"..."$CURRENT_BRANCH" | grep -E 'test|spec' | wc -l | tr -d ' ')

# Categorize commits
FEAT_COMMITS=$(git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | grep -c "^[a-f0-9]* feat:" || echo 0)
FIX_COMMITS=$(git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | grep -c "^[a-f0-9]* fix:" || echo 0)
DOCS_COMMITS=$(git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | grep -c "^[a-f0-9]* docs:" || echo 0)
CHORE_COMMITS=$(git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | grep -c "^[a-f0-9]* chore:" || echo 0)

# Determine PR type
PR_TYPE="feat"
if [ "$DOCS_COMMITS" -gt "$FEAT_COMMITS" ] && [ "$DOCS_COMMITS" -gt "$FIX_COMMITS" ]; then
    PR_TYPE="docs"
elif [ "$FIX_COMMITS" -gt "$FEAT_COMMITS" ]; then
    PR_TYPE="fix"
fi

# Generate title
echo -e "${CYAN}Generating PR title...${NC}"

# Extract main feature from commits
MAIN_FEATURE=$(git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | head -1 | sed 's/^[a-f0-9]* //' | sed 's/^[a-z]*: //')

PR_TITLE="${PR_TYPE}: ${MAIN_FEATURE}"

# Generate description
OUTPUT_FILE=".github/PR_DESCRIPTION_GENERATED.md"

cat > "$OUTPUT_FILE" << 'EOF'
## Summary

<!-- Brief overview of the changes in this PR -->

EOF

# Add what's new section based on commits
cat >> "$OUTPUT_FILE" << EOF
## What's New

EOF

# Group commits by type
if [ "$FEAT_COMMITS" -gt 0 ]; then
    echo "### ✨ Features" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | grep "feat:" | sed 's/^[a-f0-9]* feat: /- /' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

if [ "$FIX_COMMITS" -gt 0 ]; then
    echo "### 🐛 Bug Fixes" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | grep "fix:" | sed 's/^[a-f0-9]* fix: /- /' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

if [ "$DOCS_COMMITS" -gt 0 ]; then
    echo "### 📚 Documentation" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | grep "docs:" | sed 's/^[a-f0-9]* docs: /- /' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

if [ "$CHORE_COMMITS" -gt 0 ]; then
    echo "### 🔧 Chores" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    git log --online "$BASE_BRANCH".."$CURRENT_BRANCH" | grep "chore:" | sed 's/^[a-f0-9]* chore: /- /' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Add statistics
cat >> "$OUTPUT_FILE" << EOF
## 📊 Statistics

**Changes:**
- **$FILES_CHANGED files changed**
- **${INSERTIONS:-0}+ lines added**
- **${DELETIONS:-0}- lines removed**

**File Types:**
- Documentation: $DOCS_FILES files
- Code: $CODE_FILES files
- Configuration: $CONFIG_FILES files
- Tests: $TEST_FILES files

**Commits:**
- Total: $COMMIT_COUNT commits
- Features: $FEAT_COMMITS
- Bug Fixes: $FIX_COMMITS
- Documentation: $DOCS_COMMITS
- Chores: $CHORE_COMMITS

EOF

# Add commit history
cat >> "$OUTPUT_FILE" << EOF
## 📝 Commit History

EOF

git log --oneline "$BASE_BRANCH".."$CURRENT_BRANCH" | sed 's/^/- /' >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"

# Add testing section
cat >> "$OUTPUT_FILE" << 'EOF'
## ✅ Testing

### Manual Testing
- [ ] All features tested manually
- [ ] No regressions found
- [ ] Edge cases verified

### Integration
- [ ] Compatible with existing code
- [ ] No conflicts with current files
- [ ] Self-contained changes

EOF

# Add checklist
cat >> "$OUTPUT_FILE" << 'EOF'
## 📋 Checklist

- [ ] Code follows repository style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests completed
- [ ] Integration verified
- [ ] Commit messages follow conventions

EOF

# Add breaking changes section
cat >> "$OUTPUT_FILE" << 'EOF'
## 💥 Breaking Changes

None.

EOF

# Add migration guide
cat >> "$OUTPUT_FILE" << 'EOF'
## 🔄 Migration Guide

Not applicable - backward compatible changes.

EOF

# Display results
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ PR Description Generated${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Title:${NC}"
echo "$PR_TITLE"
echo ""
echo -e "${YELLOW}Description saved to:${NC}"
echo "$OUTPUT_FILE"
echo ""

# Show preview
echo -e "${CYAN}Preview (first 30 lines):${NC}"
echo "---"
head -30 "$OUTPUT_FILE"
echo "..."
echo "---"
echo ""

# Options
echo -e "${CYAN}Options:${NC}"
echo "  1. Edit in editor"
echo "  2. Use as-is"
echo "  3. Create PR now (requires gh CLI)"
echo "  4. Save and exit"
echo ""

read -p "Choose option (1-4): " choice

case $choice in
    1)
        ${EDITOR:-nano} "$OUTPUT_FILE"
        echo -e "${GREEN}✓ Description updated${NC}"
        ;;
    2)
        echo -e "${GREEN}✓ Using generated description${NC}"
        ;;
    3)
        if command -v gh &> /dev/null; then
            gh pr create --title "$PR_TITLE" --body-file "$OUTPUT_FILE" --base "$BASE_BRANCH"
            echo -e "${GREEN}✓ PR created!${NC}"
        else
            echo -e "${YELLOW}⚠ GitHub CLI (gh) not installed${NC}"
            echo "Install with: brew install gh"
        fi
        ;;
    4)
        echo -e "${GREEN}✓ Description saved${NC}"
        ;;
esac

echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. Review: cat $OUTPUT_FILE"
echo "  2. Edit: nano $OUTPUT_FILE"
echo "  3. Create PR: gh pr create --title \"$PR_TITLE\" --body-file $OUTPUT_FILE"
echo ""
