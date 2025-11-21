#!/bin/bash

# Master Claude Usage Tracking Script
# Version: 2.0.0
# Purpose: Orchestrate all tracking features (usage, budgets, reports, optimization)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config-tracking.json"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

# Parse arguments
OPERATION="${1:-all}"  # Options: usage, budget, breakdown, reports, optimization, all
COMMIT_MSG="${2:-Manual tracking}"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}     Claude Code Usage Tracking System v2.0${BLUE}               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Operation: ${YELLOW}$OPERATION${NC}"
echo -e "${CYAN}Timestamp: ${YELLOW}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo ""

# Function to run a tracking script
run_script() {
    local script_name=$1
    local script_path="$SCRIPT_DIR/$script_name"
    local display_name=$2

    if [ -f "$script_path" ]; then
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}Running: $display_name${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""

        if bash "$script_path" "$COMMIT_MSG"; then
            echo -e "${GREEN}✓ $display_name completed successfully${NC}"
        else
            echo -e "${RED}✗ $display_name failed${NC}"
            return 1
        fi
        echo ""
    else
        echo -e "${YELLOW}⚠️  $script_name not found, skipping...${NC}"
        echo ""
    fi
}

# Function to check configuration
check_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${YELLOW}⚠️  Configuration file not found at $CONFIG_FILE${NC}"
        echo -e "${CYAN}Creating default configuration...${NC}"

        cat > "$CONFIG_FILE" <<'EOF'
{
  "budget": {
    "daily": 5.00,
    "weekly": 25.00,
    "monthly": 100.00,
    "quarterly": 300.00,
    "annual": 1200.00
  },
  "alerts": {
    "thresholds": [50, 75, 90, 95, 100],
    "channels": ["github_issue", "workflow_warning"],
    "enabled": true
  },
  "reporting": {
    "monthly_reports": true,
    "quarterly_reports": true,
    "annual_reports": true,
    "auto_generate": true
  },
  "optimization": {
    "enabled": true,
    "analyze_patterns": true,
    "suggest_improvements": true,
    "track_efficiency": true
  }
}
EOF
        echo -e "${GREEN}✓ Default configuration created${NC}"
        echo ""
    fi
}

# Check configuration first
check_config

# Execute based on operation
case $OPERATION in
    "usage")
        run_script "track-claude-usage.sh" "Usage Tracking"
        ;;

    "budget")
        run_script "budget-alerts.sh" "Budget Monitoring"
        ;;

    "breakdown")
        run_script "feature-breakdown.sh" "Feature Cost Breakdown"
        ;;

    "reports")
        # Generate all report types
        echo -e "${CYAN}Generating monthly report...${NC}"
        run_script "generate-reports.sh" "Monthly Report" "monthly" "current"

        echo -e "${CYAN}Generating quarterly report...${NC}"
        run_script "generate-reports.sh" "Quarterly Report" "quarterly" "current"
        ;;

    "optimization")
        run_script "cost-optimization.sh" "Cost Optimization Analysis"
        ;;

    "all")
        echo -e "${MAGENTA}Running complete tracking suite...${NC}"
        echo ""

        # 1. Track usage
        run_script "track-claude-usage.sh" "Usage Tracking"

        # 2. Check budgets
        run_script "budget-alerts.sh" "Budget Monitoring"

        # 3. Generate feature breakdown
        run_script "feature-breakdown.sh" "Feature Cost Breakdown"

        # 4. Run optimization analysis
        run_script "cost-optimization.sh" "Cost Optimization Analysis"

        # 5. Generate reports (monthly only in full run to avoid spam)
        echo -e "${CYAN}Generating monthly report...${NC}"
        if [ -f "$SCRIPT_DIR/generate-reports.sh" ]; then
            bash "$SCRIPT_DIR/generate-reports.sh" "monthly" "current" || true
        fi

        echo ""
        echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}✓ All tracking operations completed successfully${NC}"
        echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
        ;;

    *)
        echo -e "${RED}✗ Unknown operation: $OPERATION${NC}"
        echo ""
        echo "Usage: $0 [operation] [commit_message]"
        echo ""
        echo "Operations:"
        echo "  usage        - Track usage only"
        echo "  budget       - Check budget alerts"
        echo "  breakdown    - Generate feature breakdown"
        echo "  reports      - Generate monthly/quarterly reports"
        echo "  optimization - Run optimization analysis"
        echo "  all          - Run complete tracking suite (default)"
        echo ""
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}              Tracking Session Complete${BLUE}                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Display quick summary if available
if [ -f "reports/optimization-suggestions.md" ]; then
    SCORE=$(grep "Current Score:" "reports/optimization-suggestions.md" | grep -oP '\d+' | head -1 || echo "N/A")
    echo -e "${CYAN}Optimization Score: ${YELLOW}$SCORE/100${NC}"
fi

if [ -f "CLAUDE_USAGE.md" ]; then
    TOTAL_COST=$(grep "Total Estimated Cost" CLAUDE_USAGE.md | grep -oP '\d+\.\d+' || echo "0.00")
    TOTAL_SESSIONS=$(grep "Sessions:" CLAUDE_USAGE.md | grep -oP '\d+' || echo "0")
    echo -e "${CYAN}Total Cost: ${YELLOW}\$$TOTAL_COST${NC} (${YELLOW}$TOTAL_SESSIONS${NC} sessions)"
fi

echo ""

exit 0
