#!/bin/bash

# Per-Feature Cost Breakdown Script
# Version: 1.1.0
# Purpose: Analyze usage by feature type and generate cost breakdown
# Note: Uses basic bash/grep/sed for better portability

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

# Check if usage file exists
if [ ! -f "$USAGE_FILE" ]; then
    echo -e "${YELLOW}Warning: $USAGE_FILE not found${NC}"
    exit 1
fi

# Initialize counters
feat_count=0 feat_tokens=0 feat_cost=0
fix_count=0 fix_tokens=0 fix_cost=0
chore_count=0 chore_tokens=0 chore_cost=0
docs_count=0 docs_tokens=0 docs_cost=0
refactor_count=0 refactor_tokens=0 refactor_cost=0
test_count=0 test_tokens=0 test_cost=0
other_count=0 other_tokens=0 other_cost=0

# Parse usage data line by line
while IFS='|' read -r col1 col2 col3 col4 col5; do
    # Skip header and separator lines
    if [[ "$col1" =~ ^[[:space:]]*Date || "$col1" =~ ^[[:space:]]*-+ || -z "$col1" ]]; then
        continue
    fi

    # Extract and trim values
    date=$(echo "$col1" | tr -d '[:space:]')
    feature=$(echo "$col2" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    tokens=$(echo "$col3" | tr -d '[:space:]')
    cost=$(echo "$col4" | tr -d '[:space:]$' | tr -d '$')

    # Skip if not a data row
    if [[ ! "$date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        continue
    fi

    # Skip if invalid data
    if [[ -z "$tokens" || -z "$cost" ]]; then
        continue
    fi

    # Categorize by feature prefix
    if [[ "$feature" =~ ^feat: || "$feature" =~ ^feature: ]]; then
        ((feat_count++))
        ((feat_tokens += tokens))
        feat_cost=$(echo "$feat_cost + $cost" | bc)
    elif [[ "$feature" =~ ^fix: ]]; then
        ((fix_count++))
        ((fix_tokens += tokens))
        fix_cost=$(echo "$fix_cost + $cost" | bc)
    elif [[ "$feature" =~ ^chore: ]]; then
        ((chore_count++))
        ((chore_tokens += tokens))
        chore_cost=$(echo "$chore_cost + $cost" | bc)
    elif [[ "$feature" =~ ^docs: ]]; then
        ((docs_count++))
        ((docs_tokens += tokens))
        docs_cost=$(echo "$docs_cost + $cost" | bc)
    elif [[ "$feature" =~ ^refactor: ]]; then
        ((refactor_count++))
        ((refactor_tokens += tokens))
        refactor_cost=$(echo "$refactor_cost + $cost" | bc)
    elif [[ "$feature" =~ ^test: ]]; then
        ((test_count++))
        ((test_tokens += tokens))
        test_cost=$(echo "$test_cost + $cost" | bc)
    else
        ((other_count++))
        ((other_tokens += tokens))
        other_cost=$(echo "$other_cost + $cost" | bc)
    fi
done < <(grep "^|" "$USAGE_FILE")

# Calculate totals
total_count=$((feat_count + fix_count + chore_count + docs_count + refactor_count + test_count + other_count))
total_tokens=$((feat_tokens + fix_tokens + chore_tokens + docs_tokens + refactor_tokens + test_tokens + other_tokens))
total_cost=$(echo "$feat_cost + $fix_cost + $chore_cost + $docs_cost + $refactor_cost + $test_cost + $other_cost" | bc)

# Generate report
cat > "$BREAKDOWN_FILE" <<EOF
# Feature Cost Breakdown Report

*Generated: $(date '+%Y-%m-%d %H:%M:%S')*

## Summary by Feature Type

| Category | Sessions | Tokens | Cost | Avg/Session | % of Total |
|----------|----------|--------|------|-------------|------------|
EOF

# Add category rows
if [ $feat_count -gt 0 ]; then
    avg=$(echo "scale=4; $feat_cost / $feat_count" | bc)
    pct=$(echo "scale=1; ($feat_cost / $total_cost) * 100" | bc)
    echo "| Features | $feat_count | $feat_tokens | \$$feat_cost | \$$avg | $pct% |" >> "$BREAKDOWN_FILE"
fi

if [ $fix_count -gt 0 ]; then
    avg=$(echo "scale=4; $fix_cost / $fix_count" | bc)
    pct=$(echo "scale=1; ($fix_cost / $total_cost) * 100" | bc)
    echo "| Bug Fixes | $fix_count | $fix_tokens | \$$fix_cost | \$$avg | $pct% |" >> "$BREAKDOWN_FILE"
fi

if [ $chore_count -gt 0 ]; then
    avg=$(echo "scale=4; $chore_cost / $chore_count" | bc)
    pct=$(echo "scale=1; ($chore_cost / $total_cost) * 100" | bc)
    echo "| Chores | $chore_count | $chore_tokens | \$$chore_cost | \$$avg | $pct% |" >> "$BREAKDOWN_FILE"
fi

if [ $docs_count -gt 0 ]; then
    avg=$(echo "scale=4; $docs_cost / $docs_count" | bc)
    pct=$(echo "scale=1; ($docs_cost / $total_cost) * 100" | bc)
    echo "| Documentation | $docs_count | $docs_tokens | \$$docs_cost | \$$avg | $pct% |" >> "$BREAKDOWN_FILE"
fi

if [ $refactor_count -gt 0 ]; then
    avg=$(echo "scale=4; $refactor_cost / $refactor_count" | bc)
    pct=$(echo "scale=1; ($refactor_cost / $total_cost) * 100" | bc)
    echo "| Refactoring | $refactor_count | $refactor_tokens | \$$refactor_cost | \$$avg | $pct% |" >> "$BREAKDOWN_FILE"
fi

if [ $test_count -gt 0 ]; then
    avg=$(echo "scale=4; $test_cost / $test_count" | bc)
    pct=$(echo "scale=1; ($test_cost / $total_cost) * 100" | bc)
    echo "| Tests | $test_count | $test_tokens | \$$test_cost | \$$avg | $pct% |" >> "$BREAKDOWN_FILE"
fi

if [ $other_count -gt 0 ]; then
    avg=$(echo "scale=4; $other_cost / $other_count" | bc)
    pct=$(echo "scale=1; ($other_cost / $total_cost) * 100" | bc)
    echo "| Other | $other_count | $other_tokens | \$$other_cost | \$$avg | $pct% |" >> "$BREAKDOWN_FILE"
fi

# Add total row
if [ $total_count -gt 0 ]; then
    avg_total=$(echo "scale=4; $total_cost / $total_count" | bc)
    cat >> "$BREAKDOWN_FILE" <<EOF
|----------|----------|--------|------|-------------|------------|
| **TOTAL** | **$total_count** | **$total_tokens** | **\$$total_cost** | **\$$avg_total** | **100.0%** |

## Key Insights

- **Total Sessions Analyzed:** $total_count
- **Total Cost:** \$$total_cost
- **Average Cost per Session:** \$$avg_total

## Recommendations

EOF

    # Add specific recommendations based on data
    if [ $(echo "$feat_cost / $total_cost > 0.6" | bc) -eq 1 ]; then
        echo "- Feature development accounts for >60% of costs. Consider breaking down large features into smaller iterations." >> "$BREAKDOWN_FILE"
    fi

    if [ $(echo "$fix_cost / $total_cost > 0.3" | bc) -eq 1 ]; then
        echo "- Bug fixes represent >30% of costs. Investing in better testing could reduce overall costs." >> "$BREAKDOWN_FILE"
    fi

    if [ $(echo "$avg_total > 0.10" | bc) -eq 1 ]; then
        echo "- Average cost per session is >\$0.10. Consider optimizing prompts and reducing token usage." >> "$BREAKDOWN_FILE"
    fi
fi

cat >> "$BREAKDOWN_FILE" <<EOF

---
*Report generated from: $USAGE_FILE*
*Analysis period: All time*
EOF

# Display the report
cat "$BREAKDOWN_FILE"

echo ""
echo -e "${GREEN}✓ Feature breakdown report generated: $BREAKDOWN_FILE${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

exit 0
