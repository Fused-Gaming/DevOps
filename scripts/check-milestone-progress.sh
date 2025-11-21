#!/bin/bash
# Script to check and report milestone progress
# Automatically tracks MVP completion and generates reports

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

REPO="Fused-Gaming/DevOps"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📊 DevOps MVP Milestone Progress Tracker${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}You need to authenticate with GitHub CLI${NC}"
    echo "Run: gh auth login"
    exit 1
fi

# Function to draw progress bar
draw_progress_bar() {
    local percentage=$1
    local width=40
    local filled=$((percentage * width / 100))
    local empty=$((width - filled))

    printf "["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] %3d%%" "$percentage"
}

# Function to get milestone status emoji
get_status_emoji() {
    local percentage=$1

    if [ "$percentage" -eq 100 ]; then
        echo "✅"
    elif [ "$percentage" -ge 75 ]; then
        echo "🔥"
    elif [ "$percentage" -ge 50 ]; then
        echo "⚡"
    elif [ "$percentage" -ge 25 ]; then
        echo "📈"
    else
        echo "📋"
    fi
}

# Get all milestones
MILESTONES_JSON=$(gh api repos/$REPO/milestones --jq '.')

# Get milestone count
MILESTONE_COUNT=$(echo "$MILESTONES_JSON" | jq 'length')

if [ "$MILESTONE_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}No milestones found in repository${NC}"
    exit 0
fi

echo -e "${CYAN}Found ${MILESTONE_COUNT} active milestones${NC}"
echo ""

# Overall stats
TOTAL_ISSUES=0
TOTAL_CLOSED=0
MVP_ISSUES=0
MVP_CLOSED=0

# Process each milestone
echo "$MILESTONES_JSON" | jq -c '.[]' | while read -r milestone; do
    TITLE=$(echo "$milestone" | jq -r '.title')
    NUMBER=$(echo "$milestone" | jq -r '.number')
    OPEN_ISSUES=$(echo "$milestone" | jq -r '.open_issues')
    CLOSED_ISSUES=$(echo "$milestone" | jq -r '.closed_issues')
    STATE=$(echo "$milestone" | jq -r '.state')
    DUE_ON=$(echo "$milestone" | jq -r '.due_on // "No due date"')

    TOTAL=$((OPEN_ISSUES + CLOSED_ISSUES))

    if [ "$TOTAL" -eq 0 ]; then
        PERCENTAGE=0
    else
        PERCENTAGE=$((CLOSED_ISSUES * 100 / TOTAL))
    fi

    STATUS_EMOJI=$(get_status_emoji "$PERCENTAGE")

    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${STATUS_EMOJI}  ${CYAN}${TITLE}${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Progress bar
    echo -ne "   Progress: "
    draw_progress_bar "$PERCENTAGE"
    echo ""

    # Stats
    echo -e "   Issues:   ${GREEN}${CLOSED_ISSUES} completed${NC} / ${TOTAL} total (${RED}${OPEN_ISSUES} open${NC})"
    echo -e "   State:    ${STATE}"

    if [ "$DUE_ON" != "No due date" ]; then
        echo -e "   Due:      ${DUE_ON}"
    fi

    # Show critical issues for this milestone
    CRITICAL=$(gh issue list --repo "$REPO" --milestone "$NUMBER" --label "priority:critical" --state open --json number,title --jq '. | length')

    if [ "$CRITICAL" -gt 0 ]; then
        echo -e "   ${RED}⚠️  ${CRITICAL} critical issues open${NC}"
    fi

    echo ""

    # Add to totals (only for open milestones)
    if [ "$STATE" == "open" ]; then
        TOTAL_ISSUES=$((TOTAL_ISSUES + TOTAL))
        TOTAL_CLOSED=$((TOTAL_CLOSED + CLOSED_ISSUES))

        # Check if it's an MVP milestone (not "Future Goals")
        if [[ ! "$TITLE" =~ "Future" ]]; then
            MVP_ISSUES=$((MVP_ISSUES + TOTAL))
            MVP_CLOSED=$((MVP_CLOSED + CLOSED_ISSUES))
        fi
    fi
done

# Overall progress
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📈 Overall Progress${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$TOTAL_ISSUES" -gt 0 ]; then
    OVERALL_PERCENTAGE=$((TOTAL_CLOSED * 100 / TOTAL_ISSUES))

    echo -ne "All Milestones: "
    draw_progress_bar "$OVERALL_PERCENTAGE"
    echo ""
    echo -e "${GREEN}${TOTAL_CLOSED}${NC} / ${TOTAL_ISSUES} issues completed"
    echo ""
fi

if [ "$MVP_ISSUES" -gt 0 ]; then
    MVP_PERCENTAGE=$((MVP_CLOSED * 100 / MVP_ISSUES))

    echo -ne "MVP Progress:   "
    draw_progress_bar "$MVP_PERCENTAGE"
    echo ""
    echo -e "${GREEN}${MVP_CLOSED}${NC} / ${MVP_ISSUES} MVP issues completed"

    if [ "$MVP_PERCENTAGE" -eq 100 ]; then
        echo ""
        echo -e "${GREEN}🎉 MVP COMPLETE! Ready to tag v0.1.0 release${NC}"
    elif [ "$MVP_PERCENTAGE" -ge 75 ]; then
        echo -e "${YELLOW}🔥 Almost there! MVP is ${MVP_PERCENTAGE}% complete${NC}"
    fi

    echo ""
fi

# Check for critical issues
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  ⚠️  Critical Issues${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

CRITICAL_ISSUES=$(gh issue list --repo "$REPO" --label "priority:critical" --state open --json number,title,milestone)
CRITICAL_COUNT=$(echo "$CRITICAL_ISSUES" | jq '. | length')

if [ "$CRITICAL_COUNT" -gt 0 ]; then
    echo -e "${RED}Found ${CRITICAL_COUNT} open critical issues:${NC}"
    echo ""

    echo "$CRITICAL_ISSUES" | jq -r '.[] | "  #\(.number): \(.title) [\(.milestone.title // "No milestone")]"'
else
    echo -e "${GREEN}✓ No critical issues open${NC}"
fi

echo ""

# Next steps
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🎯 Next Steps${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$CRITICAL_COUNT" -gt 0 ]; then
    echo "1. 🔴 Address ${CRITICAL_COUNT} critical issues first"
fi

# Find milestone with lowest percentage
NEXT_MILESTONE=$(echo "$MILESTONES_JSON" | jq -r 'map(select(.state == "open" and (.title | contains("Future") | not))) | sort_by(.closed_issues / (.open_issues + .closed_issues)) | .[0].title // empty')

if [ -n "$NEXT_MILESTONE" ]; then
    echo "2. 📋 Focus on: ${NEXT_MILESTONE}"
fi

echo "3. 👀 View all issues: https://github.com/${REPO}/issues"
echo "4. 📊 View milestones: https://github.com/${REPO}/milestones"

if [ "$MVP_PERCENTAGE" -eq 100 ] && [ "$CRITICAL_COUNT" -eq 0 ]; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  🚀 MVP READY FOR RELEASE${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Run the following to create v0.1.0 release:"
    echo ""
    echo "  git tag -a v0.1.0 -m 'Release v0.1.0: MVP Complete'"
    echo "  git push origin v0.1.0"
    echo "  gh release create v0.1.0 --title 'v0.1.0: MVP Release' --notes-file CHANGELOG.md"
fi

echo ""
