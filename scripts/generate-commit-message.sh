#!/bin/bash
# Automatic Commit Message Generator
# Analyzes staged changes and generates intelligent commit messages

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Commit Message Generator${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if there are staged changes
if ! git diff --cached --quiet 2>/dev/null; then
    :
else
    echo -e "${YELLOW}⚠ No staged changes found${NC}"
    echo ""
    echo "Stage your changes first:"
    echo "  git add <files>"
    echo ""
    exit 1
fi

# Analyze changes
echo -e "${CYAN}Analyzing staged changes...${NC}"
echo ""

# Get statistics
FILES_CHANGED=$(git diff --cached --numstat | wc -l | tr -d ' ')
INSERTIONS=$(git diff --cached --numstat | awk '{sum+=$1} END {print sum}')
DELETIONS=$(git diff --cached --numstat | awk '{sum+=$2} END {print sum}')

# Get file types
FILE_TYPES=$(git diff --cached --name-only | sed 's/.*\.//' | sort | uniq -c | sort -rn)

# Determine change type based on files
DOCS_CHANGED=$(git diff --cached --name-only | grep -E '\.(md|txt|rst)$' | wc -l | tr -d ' ')
CODE_CHANGED=$(git diff --cached --name-only | grep -E '\.(js|ts|py|sh|rb|go|java)$' | wc -l | tr -d ' ')
CONFIG_CHANGED=$(git diff --cached --name-only | grep -E '\.(json|yml|yaml|toml|ini)$' | wc -l | tr -d ' ')
TEST_CHANGED=$(git diff --cached --name-only | grep -E 'test|spec' | wc -l | tr -d ' ')

# Determine primary type
TYPE="chore"
if [ "$DOCS_CHANGED" -gt 0 ] && [ "$CODE_CHANGED" -eq 0 ]; then
    TYPE="docs"
elif [ "$TEST_CHANGED" -gt 0 ]; then
    TYPE="test"
elif [ "$CODE_CHANGED" -gt 0 ]; then
    # Check if it's a new feature or fix
    NEW_FILES=$(git diff --cached --diff-filter=A --name-only | wc -l | tr -d ' ')
    MODIFIED_FILES=$(git diff --cached --diff-filter=M --name-only | wc -l | tr -d ' ')

    if [ "$NEW_FILES" -gt "$MODIFIED_FILES" ]; then
        TYPE="feat"
    else
        # Check for "fix" or "bug" in diff
        if git diff --cached | grep -iq 'fix\|bug\|error'; then
            TYPE="fix"
        else
            TYPE="feat"
        fi
    fi
elif [ "$CONFIG_CHANGED" -gt 0 ]; then
    TYPE="chore"
fi

# Get changed files summary
CHANGED_FILES=$(git diff --cached --name-only)

# Generate subject line
echo -e "${CYAN}📊 Change Summary:${NC}"
echo "  Files changed: $FILES_CHANGED"
echo "  Insertions: ${GREEN}+$INSERTIONS${NC}"
echo "  Deletions: ${MAGENTA}-$DELETIONS${NC}"
echo ""

# Suggest commit type
echo -e "${CYAN}📝 Detected Commit Type: ${YELLOW}$TYPE${NC}"
echo ""

# Generate commit message suggestions
generate_subject() {
    local type=$1

    # Get primary files
    local primary_files=$(git diff --cached --name-only | head -5)

    # Extract key terms from filenames
    local key_terms=$(echo "$primary_files" | sed 's/.*\///' | sed 's/\..*//' | tr '-' ' ' | tr '_' ' ')

    case $type in
        docs)
            echo "update documentation"
            ;;
        feat)
            # Check for new directories/features
            local new_dirs=$(git diff --cached --name-only | cut -d'/' -f1 | sort -u)
            if echo "$new_dirs" | grep -q "agent-prompts"; then
                echo "add agent prompts integration"
            elif echo "$new_dirs" | grep -q "scripts"; then
                echo "add automation scripts"
            else
                echo "add new feature"
            fi
            ;;
        fix)
            echo "fix issues in implementation"
            ;;
        test)
            echo "add/update tests"
            ;;
        chore)
            echo "update configuration and dependencies"
            ;;
        *)
            echo "update project files"
            ;;
    esac
}

SUGGESTED_SUBJECT=$(generate_subject $TYPE)

# Generate detailed body
generate_body() {
    echo ""
    echo "Changed files:"
    git diff --cached --name-only | head -10 | sed 's/^/- /'

    if [ "$FILES_CHANGED" -gt 10 ]; then
        echo "... and $(($FILES_CHANGED - 10)) more files"
    fi

    echo ""
    echo "Statistics:"
    echo "- $FILES_CHANGED files changed"
    echo "- $INSERTIONS insertions(+)"
    echo "- $DELETIONS deletions(-)"
}

# Display suggestions
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📋 Suggested Commit Message:${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}$TYPE: $SUGGESTED_SUBJECT${NC}"
echo ""

# Generate full message
FULL_MESSAGE="${TYPE}: ${SUGGESTED_SUBJECT}$(generate_body)"

# Save to temp file
TEMP_MSG=$(mktemp)
echo "$FULL_MESSAGE" > "$TEMP_MSG"

# Show preview
echo -e "${CYAN}Full message preview:${NC}"
echo "---"
cat "$TEMP_MSG"
echo "---"
echo ""

# Options
echo -e "${CYAN}Options:${NC}"
echo "  1. Use this message (edit in editor)"
echo "  2. Use this message as-is"
echo "  3. Provide custom message"
echo "  4. Cancel"
echo ""

read -p "Choose option (1-4): " choice

case $choice in
    1)
        # Edit in default editor
        ${EDITOR:-nano} "$TEMP_MSG"
        git commit -F "$TEMP_MSG"
        echo -e "${GREEN}✓ Commit created!${NC}"
        ;;
    2)
        # Use as-is
        git commit -F "$TEMP_MSG"
        echo -e "${GREEN}✓ Commit created!${NC}"
        ;;
    3)
        # Custom message
        git commit
        ;;
    4)
        echo -e "${YELLOW}Cancelled.${NC}"
        rm "$TEMP_MSG"
        exit 0
        ;;
    *)
        echo -e "${YELLOW}Invalid option. Cancelled.${NC}"
        rm "$TEMP_MSG"
        exit 1
        ;;
esac

rm "$TEMP_MSG"

# Show the commit
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Latest Commit:${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
git log -1 --pretty=format:"%h - %s%n%b" --color=always
echo ""
echo ""
