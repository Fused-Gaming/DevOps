#!/bin/bash

# Cost Optimization Suggestions Script
# Version: 1.0.0
# Purpose: Analyze usage patterns and provide AI-driven cost optimization recommendations

set -e

USAGE_FILE="CLAUDE_USAGE.md"
CONFIG_FILE="scripts/config-tracking.json"
OPTIMIZATION_REPORT="reports/optimization-suggestions.md"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Ensure reports directory exists
mkdir -p reports

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Cost Optimization Analyzer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if optimization is enabled
if [ -f "$CONFIG_FILE" ]; then
    OPTIMIZATION_ENABLED=$(jq -r '.optimization.enabled // true' "$CONFIG_FILE")
    if [ "$OPTIMIZATION_ENABLED" != "true" ]; then
        echo -e "${YELLOW}Cost optimization is disabled in config${NC}"
        exit 0
    fi
fi

# Analyze usage patterns and generate optimization report
awk '
BEGIN {
    print "# Cost Optimization Report"
    print ""
    print "*Generated: " strftime("%Y-%m-%d %H:%M:%S") "*"
    print "*Analysis: Automated cost optimization suggestions*"
    print ""
    print "---"
    print ""

    # Initialize tracking variables
    total_sessions = 0
    total_tokens = 0
    total_cost = 0
    high_cost_count = 0
    low_efficiency_count = 0

    # Category tracking
    feat_count = 0; feat_cost = 0; feat_tokens = 0
    fix_count = 0; fix_cost = 0; fix_tokens = 0
    chore_count = 0; chore_cost = 0; chore_tokens = 0

    # Cost thresholds
    high_cost_threshold = 0.10
    efficiency_threshold = 15  # tokens per dollar
}

/^\| [0-9]{4}-[0-9]{2}-[0-9]{2} \|/ && !/Date/ {
    match($0, /\| ([0-9-]+) \| ([^|]+) \| ([0-9]+) \| \$([0-9.]+)/, arr)

    date = arr[1]
    feature = arr[2]
    tokens = arr[3]
    cost = arr[4]

    total_sessions++
    total_tokens += tokens
    total_cost += cost

    # Track high-cost sessions
    if (cost > high_cost_threshold) {
        high_cost_count++
        high_cost_sessions[high_cost_count] = sprintf("%s: %s ($%.4f, %d tokens)", date, substr(feature, 1, 40), cost, tokens)
    }

    # Track efficiency (tokens per dollar)
    if (cost > 0) {
        efficiency = tokens / cost
        if (efficiency < efficiency_threshold * 1000) {
            low_efficiency_count++
            low_efficiency_sessions[low_efficiency_count] = sprintf("%s: %s (%.0f tokens/$)", date, substr(feature, 1, 40), efficiency)
        }
    }

    # Categorize by type
    if (feature ~ /^feat:/) {
        feat_count++; feat_cost += cost; feat_tokens += tokens
    } else if (feature ~ /^fix:/) {
        fix_count++; fix_cost += cost; fix_tokens += tokens
    } else if (feature ~ /^chore:/) {
        chore_count++; chore_cost += cost; chore_tokens += tokens
    }

    # Store session data for temporal analysis
    sessions[total_sessions] = sprintf("%s|%s|%d|%.4f", date, feature, tokens, cost)
}

END {
    if (total_sessions == 0) {
        print "## ⚠️  No Usage Data"
        print ""
        print "No usage data available for analysis. Start using Claude Code to generate optimization insights."
        exit
    }

    avg_cost = total_cost / total_sessions
    avg_tokens = total_tokens / total_sessions

    # Calculate overall efficiency
    overall_efficiency = total_tokens / total_cost

    print "## 📊 Usage Summary"
    print ""
    print "| Metric | Value |"
    print "|--------|-------|"
    printf "| Total Sessions | %d |\n", total_sessions
    printf "| Total Cost | $%.4f |\n", total_cost
    printf "| Average Cost/Session | $%.4f |\n", avg_cost
    printf "| Average Tokens/Session | %d |\n", avg_tokens
    printf "| Overall Efficiency | %.0f tokens/$ |\n", overall_efficiency
    printf "| High-Cost Sessions (>$%.2f) | %d (%.1f%%) |\n", high_cost_threshold, high_cost_count, (high_cost_count/total_sessions)*100
    print ""

    # Optimization score (0-100)
    score = 100
    if (avg_cost > 0.15) score -= 30
    else if (avg_cost > 0.10) score -= 15
    else if (avg_cost > 0.05) score -= 5

    if ((fix_cost/total_cost) > 0.30) score -= 20
    else if ((fix_cost/total_cost) > 0.20) score -= 10

    if (high_cost_count > total_sessions * 0.2) score -= 15
    if (low_efficiency_count > total_sessions * 0.3) score -= 10

    print "## 🎯 Optimization Score"
    print ""
    printf "**Current Score: %d/100**\n", score
    print ""

    if (score >= 90) {
        print "✅ **Excellent** - Your usage is highly optimized"
    } else if (score >= 75) {
        print "🟢 **Good** - Minor optimization opportunities available"
    } else if (score >= 60) {
        print "🟡 **Fair** - Several optimization opportunities identified"
    } else if (score >= 40) {
        print "🟠 **Needs Improvement** - Significant cost savings possible"
    } else {
        print "🔴 **Critical** - Immediate optimization required"
    }
    print ""

    # Primary recommendations
    print "## 💡 Key Recommendations"
    print ""
    recommendation_count = 0

    # Recommendation 1: Average cost optimization
    if (avg_cost > 0.12) {
        recommendation_count++
        print "### " recommendation_count ". Reduce Average Session Cost"
        print ""
        printf "**Current:** $%.4f per session | **Target:** <$0.10 per session\n", avg_cost
        print ""
        print "**Actions:**"
        print "- Break large tasks into smaller, focused sessions"
        print "- Use more concise prompts and avoid repetitive context"
        print "- Pre-process data before sending to Claude"
        print "- Cache common responses for frequently asked questions"
        print ""
        printf "**Potential Savings:** $%.4f per session (%.1f%% reduction)\n", avg_cost - 0.10, ((avg_cost - 0.10)/avg_cost)*100
        print ""
    }

    # Recommendation 2: Bug fix cost reduction
    if ((fix_cost/total_cost) > 0.25 && fix_count > 0) {
        recommendation_count++
        print "### " recommendation_count ". Reduce Bug Fix Costs"
        print ""
        printf "**Current:** Bug fixes account for %.1f%% of total costs\n", (fix_cost/total_cost)*100
        print ""
        print "**Root Cause:** High bug fix costs suggest quality issues in initial development"
        print ""
        print "**Actions:**"
        print "- Implement automated testing before deployment"
        print "- Use Claude for code review before merging"
        print "- Add linting and type checking to catch errors early"
        print "- Document complex code to prevent misunderstanding"
        print "- Use test-driven development (TDD) approach"
        print ""
        printf "**Potential Savings:** $%.4f (by reducing bug fixes by 50%%)\n", fix_cost * 0.5
        print ""
    }

    # Recommendation 3: High-cost session optimization
    if (high_cost_count > 0) {
        recommendation_count++
        print "### " recommendation_count ". Optimize High-Cost Sessions"
        print ""
        printf "**Current:** %d sessions (%.1f%%) exceed $%.2f cost threshold\n", high_cost_count, (high_cost_count/total_sessions)*100, high_cost_threshold
        print ""
        print "**High-Cost Sessions:**"

        for (i = 1; i <= high_cost_count && i <= 5; i++) {
            print "- " high_cost_sessions[i]
        }
        if (high_cost_count > 5) {
            print "- ... and " (high_cost_count - 5) " more"
        }
        print ""

        print "**Actions:**"
        print "- Review high-cost sessions for optimization patterns"
        print "- Split complex features into multiple smaller sessions"
        print "- Use incremental development approach"
        print "- Consider using cheaper models for exploratory work"
        print "- Implement session cost limits and alerts"
        print ""
    }

    # Recommendation 4: Feature development efficiency
    if (feat_count > 0 && (feat_cost/feat_count) > 0.10) {
        recommendation_count++
        print "### " recommendation_count ". Improve Feature Development Efficiency"
        print ""
        printf "**Current:** Average feature cost: $%.4f\n", feat_cost/feat_count
        print ""
        print "**Actions:**"
        print "- Create detailed specifications before coding"
        print "- Reuse existing components and patterns"
        print "- Build a library of common code snippets"
        print "- Use templates for repetitive tasks"
        print "- Implement modular architecture for easier updates"
        print ""
        printf "**Potential Savings:** $%.4f per feature\n", (feat_cost/feat_count) * 0.3
        print ""
    }

    # Recommendation 5: Token efficiency
    if (overall_efficiency < 12000) {
        recommendation_count++
        print "### " recommendation_count ". Improve Token Efficiency"
        print ""
        printf "**Current:** %.0f tokens per dollar | **Target:** >15,000 tokens/$\n", overall_efficiency
        print ""
        print "**Actions:**"
        print "- Minimize output verbosity in prompts"
        print "- Request summaries instead of full explanations"
        print "- Use bullet points over prose where appropriate"
        print "- Avoid requesting redundant information"
        print "- Leverage context efficiently - dont repeat information"
        print ""
    }

    # Advanced optimization strategies
    print "## 🚀 Advanced Optimization Strategies"
    print ""

    print "### 1. Prompt Engineering"
    print "- Use specific, targeted prompts"
    print "- Provide clear context upfront"
    print "- Request structured output (JSON, tables)"
    print "- Avoid open-ended exploratory questions"
    print ""

    print "### 2. Session Management"
    print "- Set cost budgets for sessions"
    print "- Monitor real-time token usage"
    print "- End sessions before exceeding limits"
    print "- Use manual mode for expensive operations"
    print ""

    print "### 3. Workflow Optimization"
    print "- Batch similar tasks together"
    print "- Create reusable templates and snippets"
    print "- Document common patterns"
    print "- Automate repetitive tasks with scripts"
    print ""

    print "### 4. Quality Prevention"
    print "- Invest in upfront planning (saves bug fix costs)"
    print "- Implement continuous testing"
    print "- Use static analysis tools"
    print "- Conduct code reviews"
    print ""

    # Cost projection
    print "## 📈 Cost Projections"
    print ""

    # Calculate trends (if enough data)
    if (total_sessions >= 5) {
        # Simple projection: assume current rate continues
        daily_rate = total_cost / total_sessions
        monthly_projection = daily_rate * 30
        quarterly_projection = monthly_projection * 3
        annual_projection = quarterly_projection * 4

        print "**If current usage patterns continue:**"
        print ""
        print "| Period | Projected Cost |"
        print "|--------|---------------|"
        printf "| Daily Average | $%.2f |\n", daily_rate
        printf "| Monthly | $%.2f |\n", monthly_projection
        printf "| Quarterly | $%.2f |\n", quarterly_projection
        printf "| Annual | $%.2f |\n", annual_projection
        print ""

        # With optimization
        if (recommendation_count > 0) {
            potential_savings = 0.30  # Assume 30% savings from recommendations
            print "**With recommended optimizations (30% reduction):**"
            print ""
            print "| Period | Optimized Cost | Savings |"
            print "|--------|---------------|---------|"
            printf "| Monthly | $%.2f | $%.2f |\n", monthly_projection * (1-potential_savings), monthly_projection * potential_savings
            printf "| Quarterly | $%.2f | $%.2f |\n", quarterly_projection * (1-potential_savings), quarterly_projection * potential_savings
            printf "| Annual | $%.2f | $%.2f |\n", annual_projection * (1-potential_savings), annual_projection * potential_savings
            print ""
        }
    }

    # Action plan
    print "## ✅ Action Plan"
    print ""
    print "1. **Immediate Actions (This Week)**"
    if (high_cost_count > 0) {
        print "   - Review and optimize high-cost sessions"
    }
    if (avg_cost > 0.12) {
        print "   - Implement session cost limits"
    }
    print "   - Set up budget alerts"
    print "   - Document optimization guidelines"
    print ""

    print "2. **Short-term Actions (This Month)**"
    if ((fix_cost/total_cost) > 0.25) {
        print "   - Implement automated testing"
        print "   - Add code quality checks"
    }
    print "   - Create prompt templates"
    print "   - Build reusable code snippets library"
    print "   - Train team on efficient Claude usage"
    print ""

    print "3. **Long-term Actions (This Quarter)**"
    print "   - Develop comprehensive style guide"
    print "   - Implement cost tracking dashboards"
    print "   - Conduct monthly optimization reviews"
    print "   - Build automated cost optimization tools"
    print ""

    # Best practices
    print "## 📚 Best Practices"
    print ""
    print "### Efficient Prompting"
    print "- ✅ Be specific and concise"
    print "- ✅ Provide necessary context only"
    print "- ✅ Use structured formats"
    print "- ❌ Avoid open-ended requests"
    print "- ❌ Dont repeat information"
    print ""

    print "### Cost-Effective Development"
    print "- ✅ Plan before coding"
    print "- ✅ Use incremental approach"
    print "- ✅ Test early and often"
    print "- ❌ Avoid large monolithic sessions"
    print "- ❌ Dont skip documentation"
    print ""

    print "### Monitoring & Control"
    print "- ✅ Track costs in real-time"
    print "- ✅ Set budget alerts"
    print "- ✅ Review high-cost sessions"
    print "- ✅ Generate regular reports"
    print "- ❌ Dont ignore budget warnings"
    print ""

    print "---"
    print ""
    print "*Analysis based on " total_sessions " sessions*"
    print "*Recommendations updated automatically*"
    print "*Next review: " get_next_week() "*"
}

function get_next_week() {
    return strftime("%Y-%m-%d", systime() + 604800)
}
' "$USAGE_FILE" > "$OPTIMIZATION_REPORT"

# Display the report
echo -e "${CYAN}Generating optimization report...${NC}"
echo ""

cat "$OPTIMIZATION_REPORT"

echo ""
echo -e "${GREEN}✓ Optimization report generated: $OPTIMIZATION_REPORT${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Generate quick summary
echo -e "${MAGENTA}Quick Summary:${NC}"
SCORE=$(grep "Current Score:" "$OPTIMIZATION_REPORT" | grep -oP '\d+' | head -1)
RECOMMENDATIONS=$(grep "^### [0-9]" "$OPTIMIZATION_REPORT" | wc -l)

echo -e "  Optimization Score: ${YELLOW}$SCORE/100${NC}"
echo -e "  Recommendations: ${YELLOW}$RECOMMENDATIONS${NC}"
echo ""

exit 0
