#!/bin/bash

# Per-Feature Cost Breakdown Script
# Version: 1.0.0
# Purpose: Analyze usage by feature type and generate cost breakdown

set -e

USAGE_FILE="CLAUDE_USAGE.md"
BREAKDOWN_FILE="reports/feature-breakdown.md"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Ensure reports directory exists
mkdir -p reports

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Feature Cost Breakdown Analysis${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Parse usage data and categorize by feature type
if [ ! -f "$USAGE_FILE" ]; then
    echo -e "${YELLOW}Warning: $USAGE_FILE not found${NC}"
    exit 1
fi

# Extract and categorize entries
awk '
BEGIN {
    # Initialize counters
    feat_tokens = 0; feat_cost = 0; feat_count = 0
    fix_tokens = 0; fix_cost = 0; fix_count = 0
    chore_tokens = 0; chore_cost = 0; chore_count = 0
    docs_tokens = 0; docs_cost = 0; docs_count = 0
    refactor_tokens = 0; refactor_cost = 0; refactor_count = 0
    test_tokens = 0; test_cost = 0; test_count = 0
    other_tokens = 0; other_cost = 0; other_count = 0
}

/^\| [0-9]{4}-[0-9]{2}-[0-9]{2} \|/ && !/Date/ {
    # Extract fields
    match($0, /\| [0-9-]+ \| ([^|]+) \| ([0-9]+) \| \$([0-9.]+)/, arr)

    feature = arr[1]
    tokens = arr[2]
    cost = arr[3]

    # Categorize by prefix
    if (feature ~ /^feat:/ || feature ~ /^feature:/) {
        feat_tokens += tokens
        feat_cost += cost
        feat_count++
    } else if (feature ~ /^fix:/) {
        fix_tokens += tokens
        fix_cost += cost
        fix_count++
    } else if (feature ~ /^chore:/) {
        chore_tokens += tokens
        chore_cost += cost
        chore_count++
    } else if (feature ~ /^docs:/) {
        docs_tokens += tokens
        docs_cost += cost
        docs_count++
    } else if (feature ~ /^refactor:/) {
        refactor_tokens += tokens
        refactor_cost += cost
        refactor_count++
    } else if (feature ~ /^test:/) {
        test_tokens += tokens
        test_cost += cost
        test_count++
    } else {
        other_tokens += tokens
        other_cost += cost
        other_count++
    }
}

END {
    # Calculate totals
    total_tokens = feat_tokens + fix_tokens + chore_tokens + docs_tokens + refactor_tokens + test_tokens + other_tokens
    total_cost = feat_cost + fix_cost + chore_cost + docs_cost + refactor_cost + test_cost + other_cost
    total_count = feat_count + fix_count + chore_count + docs_count + refactor_count + test_count + other_count

    # Print breakdown
    print "# Feature Cost Breakdown Report\n"
    print "*Generated: " strftime("%Y-%m-%d %H:%M:%S") "*\n"
    print "## Summary by Feature Type\n"
    print "| Category | Sessions | Tokens | Cost | Avg/Session | % of Total |"
    print "|----------|----------|--------|------|-------------|------------|"

    if (feat_count > 0) {
        pct = (feat_cost / total_cost) * 100
        avg = feat_cost / feat_count
        printf "| 🎯 Features | %d | %d | $%.4f | $%.4f | %.1f%% |\n", feat_count, feat_tokens, feat_cost, avg, pct
    }

    if (fix_count > 0) {
        pct = (fix_cost / total_cost) * 100
        avg = fix_cost / fix_count
        printf "| 🐛 Bug Fixes | %d | %d | $%.4f | $%.4f | %.1f%% |\n", fix_count, fix_tokens, fix_cost, avg, pct
    }

    if (chore_count > 0) {
        pct = (chore_cost / total_cost) * 100
        avg = chore_cost / chore_count
        printf "| 🔧 Chores | %d | %d | $%.4f | $%.4f | %.1f%% |\n", chore_count, chore_tokens, chore_cost, avg, pct
    }

    if (docs_count > 0) {
        pct = (docs_cost / total_cost) * 100
        avg = docs_cost / docs_count
        printf "| 📚 Documentation | %d | %d | $%.4f | $%.4f | %.1f%% |\n", docs_count, docs_tokens, docs_cost, avg, pct
    }

    if (refactor_count > 0) {
        pct = (refactor_cost / total_cost) * 100
        avg = refactor_cost / refactor_count
        printf "| ♻️  Refactoring | %d | %d | $%.4f | $%.4f | %.1f%% |\n", refactor_count, refactor_tokens, refactor_cost, avg, pct
    }

    if (test_count > 0) {
        pct = (test_cost / total_cost) * 100
        avg = test_cost / test_count
        printf "| 🧪 Tests | %d | %d | $%.4f | $%.4f | %.1f%% |\n", test_count, test_tokens, test_cost, avg, pct
    }

    if (other_count > 0) {
        pct = (other_cost / total_cost) * 100
        avg = other_cost / other_count
        printf "| 📦 Other | %d | %d | $%.4f | $%.4f | %.1f%% |\n", other_count, other_tokens, other_cost, avg, pct
    }

    print "|----------|----------|--------|------|-------------|------------|"
    printf "| **TOTAL** | **%d** | **%d** | **$%.4f** | **$%.4f** | **100.0%%** |\n", total_count, total_tokens, total_cost, total_cost/total_count

    print "\n## Cost Distribution\n"
    print "```"
    print "Features:      " sprintf("%6.2f%%", (feat_cost/total_cost)*100) " [$" sprintf("%.4f", feat_cost) "]"
    print "Bug Fixes:     " sprintf("%6.2f%%", (fix_cost/total_cost)*100) " [$" sprintf("%.4f", fix_cost) "]"
    print "Chores:        " sprintf("%6.2f%%", (chore_cost/total_cost)*100) " [$" sprintf("%.4f", chore_cost) "]"
    print "Documentation: " sprintf("%6.2f%%", (docs_cost/total_cost)*100) " [$" sprintf("%.4f", docs_cost) "]"
    print "Refactoring:   " sprintf("%6.2f%%", (refactor_cost/total_cost)*100) " [$" sprintf("%.4f", refactor_cost) "]"
    print "Tests:         " sprintf("%6.2f%%", (test_cost/total_cost)*100) " [$" sprintf("%.4f", test_cost) "]"
    print "Other:         " sprintf("%6.2f%%", (other_cost/total_cost)*100) " [$" sprintf("%.4f", other_cost) "]"
    print "```\n"

    print "## Key Insights\n"

    # Find most expensive category
    max_cost = 0
    max_category = ""
    if (feat_cost > max_cost) { max_cost = feat_cost; max_category = "Features" }
    if (fix_cost > max_cost) { max_cost = fix_cost; max_category = "Bug Fixes" }
    if (chore_cost > max_cost) { max_cost = chore_cost; max_category = "Chores" }
    if (docs_cost > max_cost) { max_cost = docs_cost; max_category = "Documentation" }
    if (refactor_cost > max_cost) { max_cost = refactor_cost; max_category = "Refactoring" }
    if (test_cost > max_cost) { max_cost = test_cost; max_category = "Tests" }
    if (other_cost > max_cost) { max_cost = other_cost; max_category = "Other" }

    print "- **Highest Cost Category:** " max_category " ($" sprintf("%.4f", max_cost) ")"
    print "- **Average Cost per Session:** $" sprintf("%.4f", total_cost/total_count)
    print "- **Total Sessions Analyzed:** " total_count
    print "- **Total Cost:** $" sprintf("%.4f", total_cost)

    print "\n## Recommendations\n"

    if ((feat_cost/total_cost) > 0.6) {
        print "- Feature development accounts for >60% of costs. Consider breaking down large features into smaller iterations."
    }

    if ((fix_cost/total_cost) > 0.3) {
        print "- Bug fixes represent >30% of costs. Investing in better testing could reduce overall costs."
    }

    if ((docs_cost/total_cost) < 0.05) {
        print "- Documentation costs are low (<5%). Ensure sufficient documentation to prevent future costly debugging."
    }

    if (total_count > 0 && (total_cost/total_count) > 0.10) {
        print "- Average cost per session is >$0.10. Consider optimizing prompts and reducing token usage."
    }

    print "\n---"
    print "*Report generated from: " FILENAME "*"
    print "*Analysis period: All time*"
}
' "$USAGE_FILE" > "$BREAKDOWN_FILE"

# Display the report
cat "$BREAKDOWN_FILE"

echo ""
echo -e "${GREEN}✓ Feature breakdown report generated: $BREAKDOWN_FILE${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

exit 0
