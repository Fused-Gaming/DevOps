#!/bin/bash

# Git Hooks Setup Script
# Installs pre-commit hook for Claude Code usage tracking
# Author: User (via git config)

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Git Hooks Setup for Claude Code Usage Tracking${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: Not in a git repository root${NC}"
    echo "Please run this script from the repository root directory"
    exit 1
fi

# Ensure scripts directory exists
if [ ! -d "scripts" ]; then
    echo -e "${YELLOW}Creating scripts directory...${NC}"
    mkdir -p scripts
fi

# Check if usage tracking script exists
if [ ! -f "scripts/track-claude-usage.sh" ]; then
    echo -e "${RED}Error: track-claude-usage.sh not found${NC}"
    echo "Please ensure scripts/track-claude-usage.sh exists"
    exit 1
fi

# Ensure hook is executable
chmod +x scripts/track-claude-usage.sh

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Backup existing pre-commit hook if it exists
if [ -f ".git/hooks/pre-commit" ]; then
    echo -e "${YELLOW}Backing up existing pre-commit hook...${NC}"
    cp .git/hooks/pre-commit .git/hooks/pre-commit.backup.$(date +%s)
    echo -e "${GREEN}✓ Backup created${NC}"
fi

# Install pre-commit hook
echo -e "${BLUE}→ Installing pre-commit hook...${NC}"
cat > .git/hooks/pre-commit << 'HOOK_EOF'
#!/bin/bash

# Pre-commit hook to track Claude Code usage
# This hook runs before each commit to update usage tracking

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Running pre-commit hooks...${NC}"

# Track Claude Code usage
if [ -f "scripts/track-claude-usage.sh" ]; then
    echo -e "${BLUE}→ Tracking Claude Code usage...${NC}"
    bash scripts/track-claude-usage.sh "$(git log -1 --pretty=%B 2>/dev/null || echo 'Pending commit')" || true

    # Add the updated usage file to this commit if it was modified
    if git diff --name-only | grep -q "CLAUDE_USAGE.md"; then
        git add CLAUDE_USAGE.md
        echo -e "${GREEN}✓ Usage tracking file updated and staged${NC}"
    fi
fi

echo -e "${GREEN}✓ Pre-commit hooks completed${NC}"
echo ""

exit 0
HOOK_EOF

# Make hook executable
chmod +x .git/hooks/pre-commit

echo -e "${GREEN}✓ Pre-commit hook installed${NC}"
echo ""

# Initialize CLAUDE_USAGE.md if it doesn't exist
if [ ! -f "CLAUDE_USAGE.md" ]; then
    echo -e "${BLUE}→ Creating CLAUDE_USAGE.md...${NC}"
    cat > CLAUDE_USAGE.md << 'USAGE_EOF'
# Claude Code Usage Tracking

This file automatically tracks Claude Code usage for this repository.

## Usage Summary

| Date | Feature/Fix | Tokens Used | Estimated Cost | Session ID |
|------|-------------|-------------|----------------|------------|
| *Initial setup* | Usage tracking initialized | 0 | $0.00 | - |

## Total Accumulated Usage

- **Total Tokens**: 0
- **Total Estimated Cost**: $0.00
- **Sessions**: 0

---

## Pricing Reference

Claude Sonnet 4.5 Pricing (as of 2025):
- Input tokens: $3.00 per million tokens
- Output tokens: $15.00 per million tokens

## Notes

This file is automatically updated by the pre-commit hook. Each commit will:
- Record the date and time
- Capture the commit message (feature/fix description)
- Track token usage from the Claude Code session
- Calculate estimated costs based on current pricing
- Accumulate totals over time

---

*Last Updated: 2025-11-16*
*Tracking Script Version: 1.0.0*
USAGE_EOF

    echo -e "${GREEN}✓ CLAUDE_USAGE.md created${NC}"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Git hooks are now configured to track Claude Code usage."
echo -e "Every commit will automatically update ${YELLOW}CLAUDE_USAGE.md${NC}"
echo ""
echo -e "${GREEN}What happens now:${NC}"
echo -e "  1. Make changes to your code"
echo -e "  2. Run: ${YELLOW}git add .${NC}"
echo -e "  3. Run: ${YELLOW}git commit -m 'your message'${NC}"
echo -e "  4. Usage will be tracked automatically"
echo -e "  5. CLAUDE_USAGE.md will be updated"
echo ""
echo -e "${BLUE}To view usage stats:${NC} cat CLAUDE_USAGE.md"
echo ""

exit 0
