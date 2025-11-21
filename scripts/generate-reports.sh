#!/bin/bash

# Monthly/Quarterly Reports Generation Script
# Version: 1.0.0
# Purpose: Generate comprehensive usage reports for specified periods

set -e

USAGE_FILE="CLAUDE_USAGE.md"
REPORTS_DIR="reports"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Ensure reports directory exists
mkdir -p "$REPORTS_DIR"

# Parse command line arguments
REPORT_TYPE="${1:-monthly}"  # monthly, quarterly, annual
PERIOD="${2:-current}"        # current, YYYY-MM, YYYY-QN

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Usage Reports Generator${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Report Type: ${CYAN}$REPORT_TYPE${NC}"
echo -e "Period: ${CYAN}$PERIOD${NC}"
echo ""

# Function to calculate date range
get_date_range() {
    local type=$1
    local period=$2
    local start_date=""
    local end_date=$(date '+%Y-%m-%d')
    local period_name=""

    case $type in
        "monthly")
            if [ "$period" == "current" ]; then
                start_date=$(date '+%Y-%m-01')
                period_name=$(date '+%B %Y')
            else
                start_date="$period-01"
                period_name=$(date -d "$start_date" '+%B %Y')
                # Calculate last day of month
                end_date=$(date -d "$start_date + 1 month - 1 day" '+%Y-%m-%d')
            fi
            ;;
        "quarterly")
            if [ "$period" == "current" ]; then
                local month=$(date '+%m')
                local year=$(date '+%Y')
                local quarter=$(( (month - 1) / 3 + 1 ))
                local start_month=$(( (quarter - 1) * 3 + 1 ))
                start_date=$(printf "%04d-%02d-01" $year $start_month)
                period_name="Q$quarter $year"
            else
                # Format: YYYY-QN
                local year=${period:0:4}
                local quarter=${period:6:1}
                local start_month=$(( (quarter - 1) * 3 + 1 ))
                start_date=$(printf "%04d-%02d-01" $year $start_month)
                period_name="Q$quarter $year"
                # Calculate last day of quarter
                local end_month=$(( quarter * 3 ))
                end_date=$(date -d "$year-$end_month-01 + 1 month - 1 day" '+%Y-%m-%d')
            fi
            ;;
        "annual")
            if [ "$period" == "current" ]; then
                start_date=$(date '+%Y-01-01')
                period_name=$(date '+%Y')
            else
                start_date="$period-01-01"
                end_date="$period-12-31"
                period_name="$period"
            fi
            ;;
    esac

    echo "$start_date|$end_date|$period_name"
}

# Function to generate report
generate_report() {
    local report_type=$1
    local start_date=$2
    local end_date=$3
    local period_name=$4

    local report_file="$REPORTS_DIR/${report_type}-report-$(echo $period_name | tr ' ' '-' | tr '[:upper:]' '[:lower:]').md"

    echo -e "${CYAN}Generating report for: $period_name${NC}"
    echo -e "${CYAN}Date range: $start_date to $end_date${NC}"
    echo ""

    # Parse usage data for the period
    awk -v start="$start_date" -v end="$end_date" -v period="$period_name" -v type="$report_type" '
    BEGIN {
        total_tokens = 0
        total_cost = 0
        session_count = 0
        max_cost = 0
        max_session = ""
        min_cost = 999999
        min_session = ""

        # Category counters
        feat_tokens = 0; feat_cost = 0; feat_count = 0
        fix_tokens = 0; fix_cost = 0; fix_count = 0
        chore_tokens = 0; chore_cost = 0; chore_count = 0
        docs_tokens = 0; docs_cost = 0; docs_count = 0
        refactor_tokens = 0; refactor_cost = 0; refactor_count = 0
        test_tokens = 0; test_cost = 0; test_count = 0
        other_tokens = 0; other_cost = 0; other_count = 0
    }

    /^\| [0-9]{4}-[0-9]{2}-[0-9]{2} \|/ && !/Date/ {
        match($0, /\| ([0-9-]+) \| ([^|]+) \| ([0-9]+) \| \$([0-9.]+) \| ([a-f0-9]+)/, arr)

        entry_date = arr[1]
        feature = arr[2]
        tokens = arr[3]
        cost = arr[4]
        session_id = arr[5]

        if (entry_date >= start && entry_date <= end) {
            total_tokens += tokens
            total_cost += cost
            session_count++

            # Track min/max
            if (cost > max_cost) {
                max_cost = cost
                max_session = feature
            }
            if (cost < min_cost && cost > 0) {
                min_cost = cost
                min_session = feature
            }

            # Categorize
            if (feature ~ /^feat:/ || feature ~ /^feature:/) {
                feat_tokens += tokens; feat_cost += cost; feat_count++
            } else if (feature ~ /^fix:/) {
                fix_tokens += tokens; fix_cost += cost; fix_count++
            } else if (feature ~ /^chore:/) {
                chore_tokens += tokens; chore_cost += cost; chore_count++
            } else if (feature ~ /^docs:/) {
                docs_tokens += tokens; docs_cost += cost; docs_count++
            } else if (feature ~ /^refactor:/) {
                refactor_tokens += tokens; refactor_cost += cost; refactor_count++
            } else if (feature ~ /^test:/) {
                test_tokens += tokens; test_cost += cost; test_count++
            } else {
                other_tokens += tokens; other_cost += cost; other_count++
            }

            # Store for details table
            sessions[session_count] = sprintf("| %s | %s | %d | $%.4f |", entry_date, substr(feature, 1, 50), tokens, cost)
        }
    }

    END {
        # Generate report header
        print "# " toupper(type) " Usage Report"
        print ""
        print "**Period:** " period
        print "**Date Range:** " start " to " end
        print "**Generated:** " strftime("%Y-%m-%d %H:%M:%S")
        print ""
        print "---"
        print ""

        # Executive Summary
        print "## 📊 Executive Summary"
        print ""
        print "| Metric | Value |"
        print "|--------|-------|"
        printf "| **Total Sessions** | %d |\n", session_count
        printf "| **Total Tokens** | %s |\n", format_number(total_tokens)
        printf "| **Total Cost** | $%.4f |\n", total_cost

        if (session_count > 0) {
            avg_tokens = total_tokens / session_count
            avg_cost = total_cost / session_count
            printf "| **Avg Tokens/Session** | %s |\n", format_number(avg_tokens)
            printf "| **Avg Cost/Session** | $%.4f |\n", avg_cost
        }

        printf "| **Highest Cost Session** | $%.4f |\n", max_cost
        printf "| **Lowest Cost Session** | $%.4f |\n", min_cost
        print ""

        # Cost breakdown by category
        print "## 💰 Cost Breakdown by Category"
        print ""
        print "| Category | Sessions | Tokens | Cost | % of Total |"
        print "|----------|----------|--------|------|------------|"

        if (feat_count > 0) {
            pct = (feat_cost / total_cost) * 100
            printf "| 🎯 Features | %d | %s | $%.4f | %.1f%% |\n", feat_count, format_number(feat_tokens), feat_cost, pct
        }
        if (fix_count > 0) {
            pct = (fix_cost / total_cost) * 100
            printf "| 🐛 Bug Fixes | %d | %s | $%.4f | %.1f%% |\n", fix_count, format_number(fix_tokens), fix_cost, pct
        }
        if (chore_count > 0) {
            pct = (chore_cost / total_cost) * 100
            printf "| 🔧 Chores | %d | %s | $%.4f | %.1f%% |\n", chore_count, format_number(chore_tokens), chore_cost, pct
        }
        if (docs_count > 0) {
            pct = (docs_cost / total_cost) * 100
            printf "| 📚 Documentation | %d | %s | $%.4f | %.1f%% |\n", docs_count, format_number(docs_tokens), docs_cost, pct
        }
        if (refactor_count > 0) {
            pct = (refactor_cost / total_cost) * 100
            printf "| ♻️  Refactoring | %d | %s | $%.4f | %.1f%% |\n", refactor_count, format_number(refactor_tokens), refactor_cost, pct
        }
        if (test_count > 0) {
            pct = (test_cost / total_cost) * 100
            printf "| 🧪 Tests | %d | %s | $%.4f | %.1f%% |\n", test_count, format_number(test_tokens), test_cost, pct
        }
        if (other_count > 0) {
            pct = (other_cost / total_cost) * 100
            printf "| 📦 Other | %d | %s | $%.4f | %.1f%% |\n", other_count, format_number(other_tokens), other_cost, pct
        }
        print ""

        # Trends and insights
        print "## 📈 Trends & Insights"
        print ""

        if (session_count == 0) {
            print "- No usage recorded for this period"
        } else {
            # Calculate efficiency
            if (avg_cost > 0.15) {
                print "- ⚠️  **High average cost per session** ($" sprintf("%.4f", avg_cost) ") - consider optimization"
            } else if (avg_cost > 0.10) {
                print "- ℹ️  **Moderate average cost per session** ($" sprintf("%.4f", avg_cost) ")"
            } else {
                print "- ✅ **Good average cost per session** ($" sprintf("%.4f", avg_cost) ")"
            }

            # Category insights
            max_category_cost = 0
            max_category_name = ""
            if (feat_cost > max_category_cost) { max_category_cost = feat_cost; max_category_name = "Features" }
            if (fix_cost > max_category_cost) { max_category_cost = fix_cost; max_category_name = "Bug Fixes" }
            if (chore_cost > max_category_cost) { max_category_cost = chore_cost; max_category_name = "Chores" }

            if (max_category_name != "") {
                print "- **Primary activity:** " max_category_name " (accounts for " sprintf("%.1f%%", (max_category_cost/total_cost)*100) " of costs)"
            }

            # Cost distribution
            if ((feat_cost / total_cost) > 0.6) {
                print "- Feature development is the primary cost driver (>60%)"
            }
            if ((fix_cost / total_cost) > 0.3) {
                print "- Bug fixes account for significant costs (>30%) - consider improving test coverage"
            }
        }
        print ""

        # Detailed session log
        print "## 📝 Detailed Session Log"
        print ""
        print "| Date | Feature/Task | Tokens | Cost |"
        print "|------|--------------|--------|------|"

        for (i = 1; i <= session_count; i++) {
            print sessions[i]
        }

        if (session_count == 0) {
            print "| - | No sessions recorded | - | - |"
        }

        print ""

        # Recommendations
        print "## 💡 Recommendations"
        print ""

        if (session_count == 0) {
            print "- No usage data available for analysis"
        } else {
            if (avg_cost > 0.12) {
                print "1. **Optimize token usage** - Average cost per session is above target"
                print "   - Review prompts for efficiency"
                print "   - Break large tasks into smaller chunks"
                print "   - Use more concise language in requests"
            }

            if ((fix_cost / total_cost) > 0.25) {
                print "2. **Improve code quality** - Bug fixes represent significant costs"
                print "   - Increase test coverage"
                print "   - Implement code reviews"
                print "   - Add automated testing"
            }

            if ((docs_cost / total_cost) < 0.05 && session_count > 5) {
                print "3. **Invest in documentation** - Low documentation activity may lead to future costs"
                print "   - Document complex features"
                print "   - Maintain up-to-date README files"
                print "   - Add inline code comments"
            }

            print "4. **Monitor budget regularly** - Use budget alerts to track spending"
            print "5. **Review high-cost sessions** - Analyze expensive sessions for optimization opportunities"
        }

        print ""
        print "---"
        print ""
        print "*Report generated from: " FILENAME "*"
        print "*Next report: " get_next_period(type, period) "*"
    }

    function format_number(n) {
        if (n >= 1000000) {
            return sprintf("%.2fM", n/1000000)
        } else if (n >= 1000) {
            return sprintf("%.2fK", n/1000)
        } else {
            return sprintf("%d", n)
        }
    }

    function get_next_period(type, period) {
        if (type == "monthly") {
            return "Next month"
        } else if (type == "quarterly") {
            return "Next quarter"
        } else {
            return "Next year"
        }
    }
    ' "$USAGE_FILE" > "$report_file"

    echo -e "${GREEN}✓ Report generated: $report_file${NC}"
    echo ""

    # Display summary
    cat "$report_file" | head -35
    echo ""
    echo -e "${YELLOW}... (full report saved to $report_file) ...${NC}"
    echo ""
}

# Main execution
if [ ! -f "$USAGE_FILE" ]; then
    echo -e "${YELLOW}Error: $USAGE_FILE not found${NC}"
    exit 1
fi

# Parse date range
IFS='|' read -r START_DATE END_DATE PERIOD_NAME <<< $(get_date_range "$REPORT_TYPE" "$PERIOD")

# Generate the report
generate_report "$REPORT_TYPE" "$START_DATE" "$END_DATE" "$PERIOD_NAME"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Report generation complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

exit 0
