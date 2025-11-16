#!/bin/bash

# Claude Code Usage Tracking Script
# Version: 1.0.0
# Author: User (tracked via git config)
# Purpose: Automatically track Claude Code usage on each commit

set -e

USAGE_FILE="CLAUDE_USAGE.md"
TEMP_FILE=$(mktemp)

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get current date/time
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
CURRENT_DATE_SHORT=$(date '+%Y-%m-%d')

# Get commit message (from git hook or arg)
if [ -n "$1" ]; then
    COMMIT_MSG="$1"
else
    COMMIT_MSG=$(git log -1 --pretty=%B 2>/dev/null || echo "Manual tracking")
fi

# Estimate token usage based on commit changes
# This is an approximation - actual usage may vary
FILES_CHANGED=$(git diff --cached --numstat 2>/dev/null | wc -l || echo 1)
LINES_ADDED=$(git diff --cached --numstat 2>/dev/null | awk '{sum+=$1} END {print sum}' || echo 0)
LINES_DELETED=$(git diff --cached --numstat 2>/dev/null | awk '{sum+=$2} END {print sum}' || echo 0)
TOTAL_CHANGES=$((LINES_ADDED + LINES_DELETED))

# Rough token estimation (1 line ≈ 10-15 tokens on average)
# Adding baseline for context and conversation
ESTIMATED_TOKENS=$((TOTAL_CHANGES * 12 + 500))

# Claude Sonnet 4.5 pricing (per million tokens)
# Input: $3.00, Output: $15.00
# Conservative estimate: 70% input, 30% output
INPUT_TOKENS=$((ESTIMATED_TOKENS * 70 / 100))
OUTPUT_TOKENS=$((ESTIMATED_TOKENS * 30 / 100))

# Calculate cost (in micro-dollars to avoid floating point)
INPUT_COST_MICRO=$((INPUT_TOKENS * 3000 / 1000000))
OUTPUT_COST_MICRO=$((OUTPUT_TOKENS * 15000 / 1000000))
TOTAL_COST_MICRO=$((INPUT_COST_MICRO + OUTPUT_COST_MICRO))

# Format cost in dollars
ESTIMATED_COST=$(printf "%.4f" $(echo "scale=4; $TOTAL_COST_MICRO / 1000" | bc))

# Generate session ID (short hash)
SESSION_ID=$(date +%s | sha256sum | head -c 8)

# Display tracking info
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Claude Code Usage Tracker${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Date:           ${YELLOW}$CURRENT_DATE${NC}"
echo -e "Commit:         ${YELLOW}${COMMIT_MSG:0:50}...${NC}"
echo -e "Files changed:  ${YELLOW}$FILES_CHANGED${NC}"
echo -e "Lines changed:  ${YELLOW}+$LINES_ADDED/-$LINES_DELETED${NC}"
echo -e "Est. tokens:    ${YELLOW}~$ESTIMATED_TOKENS${NC}"
echo -e "Est. cost:      ${YELLOW}\$${ESTIMATED_COST}${NC}"
echo -e "Session ID:     ${YELLOW}$SESSION_ID${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check if usage file exists
if [ ! -f "$USAGE_FILE" ]; then
    echo -e "${YELLOW}Warning: $USAGE_FILE not found. Please run from repository root.${NC}"
    exit 1
fi

# Backup current file
cp "$USAGE_FILE" "${USAGE_FILE}.bak"

# Read current totals
CURRENT_TOTAL_TOKENS=$(grep "Total Tokens" "$USAGE_FILE" | grep -oP '\d+' || echo 0)
CURRENT_TOTAL_COST=$(grep "Total Estimated Cost" "$USAGE_FILE" | grep -oP '\d+\.\d+' || echo "0.00")
CURRENT_SESSIONS=$(grep "Sessions:" "$USAGE_FILE" | grep -oP '\d+' || echo 0)

# Calculate new totals
NEW_TOTAL_TOKENS=$((CURRENT_TOTAL_TOKENS + ESTIMATED_TOKENS))
NEW_TOTAL_COST=$(echo "scale=4; $CURRENT_TOTAL_COST + $ESTIMATED_COST" | bc)
NEW_SESSIONS=$((CURRENT_SESSIONS + 1))

# Create new entry for the table
NEW_ENTRY="| $CURRENT_DATE_SHORT | ${COMMIT_MSG:0:40} | $ESTIMATED_TOKENS | \$$ESTIMATED_COST | $SESSION_ID |"

# Update the file
awk -v new_entry="$NEW_ENTRY" -v total_tokens="$NEW_TOTAL_TOKENS" -v total_cost="$NEW_TOTAL_COST" -v sessions="$NEW_SESSIONS" '
BEGIN {
    entry_added = 0
    in_summary = 0
}
{
    # Add new entry after the table header
    if (!entry_added && /^\| Date \| Feature/) {
        print $0
        getline
        print $0
        print new_entry
        entry_added = 1
        next
    }

    # Update total tokens
    if (/\*\*Total Tokens\*\*/) {
        print "- **Total Tokens**: " total_tokens
        next
    }

    # Update total cost
    if (/\*\*Total Estimated Cost\*\*/) {
        print "- **Total Estimated Cost**: $" total_cost
        next
    }

    # Update sessions
    if (/\*\*Sessions\*\*/) {
        print "- **Sessions**: " sessions
        next
    }

    # Update last updated date
    if (/\*Last Updated:/) {
        print "*Last Updated: " strftime("%Y-%m-%d") "*"
        next
    }

    print $0
}
' "$USAGE_FILE" > "$TEMP_FILE"

# Replace original file
mv "$TEMP_FILE" "$USAGE_FILE"

# Clean up backup
rm -f "${USAGE_FILE}.bak"

echo -e "${GREEN}✓ Usage tracking updated successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Display updated totals
echo -e "${GREEN}Updated Totals:${NC}"
echo -e "  Total Tokens:    ${YELLOW}$NEW_TOTAL_TOKENS${NC}"
echo -e "  Total Cost:      ${YELLOW}\$$NEW_TOTAL_COST${NC}"
echo -e "  Total Sessions:  ${YELLOW}$NEW_SESSIONS${NC}"
echo ""

exit 0
