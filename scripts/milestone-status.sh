#!/bin/bash
# Simple milestone status checker using gh CLI only
# No external dependencies required

set -e

REPO="Fused-Gaming/DevOps"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📊 DevOps MVP Milestone Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    exit 1
fi

# List milestones with progress
echo "Milestones:"
echo ""

gh api repos/$REPO/milestones --jq '.[] | "\(.title):\n  Progress: \(.closed_issues)/\((.open_issues + .closed_issues)) issues (\(if (.open_issues + .closed_issues) > 0 then ((.closed_issues * 100) / (.open_issues + .closed_issues)) else 0 end | floor)%)\n  Open: \(.open_issues) | Closed: \(.closed_issues)\n"'

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ⚠️  Critical Issues"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

CRITICAL_COUNT=$(gh issue list --repo "$REPO" --label "priority:critical" --state open --json number | gh api - --jq 'length')

if [ "$CRITICAL_COUNT" -gt 0 ]; then
    echo "Found $CRITICAL_COUNT critical issues:"
    echo ""
    gh issue list --repo "$REPO" --label "priority:critical" --state open
else
    echo "✓ No critical issues open"
fi

echo ""
echo "View all: https://github.com/${REPO}/milestones"
echo ""
