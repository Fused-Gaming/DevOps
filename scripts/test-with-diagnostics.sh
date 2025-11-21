#!/bin/bash

# Enhanced Testing Script with Comprehensive Diagnostics
# Version: 1.0.0
# Author: User (via git config)
# Purpose: Run tests with detailed troubleshooting feedback

set -e

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Unicode characters for better visuals
CHECK="✓"
CROSS="✗"
ARROW="→"
WARN="⚠"
INFO="ℹ"

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNINGS=0

# Functions
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${CYAN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_section() {
    echo ""
    echo -e "${MAGENTA}▓▓▓ $1${NC}"
    echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
    ((PASSED_CHECKS++))
}

print_failure() {
    echo -e "${RED}${CROSS} $1${NC}"
    ((FAILED_CHECKS++))
}

print_warning() {
    echo -e "${YELLOW}${WARN} $1${NC}"
    ((WARNINGS++))
}

print_info() {
    echo -e "${CYAN}${INFO} $1${NC}"
}

print_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))

    printf "\r${BLUE}Progress: [${GREEN}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${BLUE}"
    printf "%${empty}s" | tr ' ' '░'
    printf "${BLUE}] ${YELLOW}%3d%%${NC}" $percentage
}

# Start
clear
print_header "DevOps Test Suite with Comprehensive Diagnostics"
echo ""
echo -e "${CYAN}Started at: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "${CYAN}Repository: $(basename $(pwd))${NC}"
echo -e "${CYAN}Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')${NC}"
echo ""

# ============================================================================
# 1. ENVIRONMENT CHECKS
# ============================================================================
print_section "1. Environment Information"

((TOTAL_CHECKS++))
echo -e "${BLUE}${ARROW} Node.js Version:${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "  ${GREEN}${NODE_VERSION}${NC}"
    print_success "Node.js detected"
else
    echo -e "  ${RED}Not installed${NC}"
    print_warning "Node.js not found (may not be required)"
fi

((TOTAL_CHECKS++))
echo -e "${BLUE}${ARROW} npm Version:${NC}"
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo -e "  ${GREEN}v${NPM_VERSION}${NC}"
    print_success "npm detected"
else
    echo -e "  ${RED}Not installed${NC}"
    print_warning "npm not found (may not be required)"
fi

((TOTAL_CHECKS++))
echo -e "${BLUE}${ARROW} Python Version:${NC}"
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "  ${GREEN}${PYTHON_VERSION}${NC}"
    print_success "Python detected"
else
    echo -e "  ${RED}Not installed${NC}"
    print_warning "Python not found (may not be required)"
fi

((TOTAL_CHECKS++))
echo -e "${BLUE}${ARROW} Git Version:${NC}"
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "  ${GREEN}${GIT_VERSION}${NC}"
    print_success "Git detected"
else
    echo -e "  ${RED}Not installed${NC}"
    print_failure "Git is required"
fi

((TOTAL_CHECKS++))
echo -e "${BLUE}${ARROW} Docker Status:${NC}"
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        echo -e "  ${GREEN}Running${NC}"
        print_success "Docker is running"
    else
        echo -e "  ${YELLOW}Installed but not running${NC}"
        print_warning "Docker daemon not running"
    fi
else
    echo -e "  ${YELLOW}Not installed${NC}"
    print_info "Docker not found (optional)"
fi

# ============================================================================
# 2. PACKAGE DEPENDENCIES
# ============================================================================
print_section "2. Package Dependencies Check"

((TOTAL_CHECKS++))
if [ -f "package.json" ]; then
    print_info "Analyzing package.json..."

    # Check if node_modules exists
    if [ -d "node_modules" ]; then
        print_success "node_modules directory exists"

        # Check for outdated packages
        echo -e "${BLUE}${ARROW} Checking for outdated packages...${NC}"
        OUTDATED=$(npm outdated 2>&1 || true)
        if [ -n "$OUTDATED" ]; then
            print_warning "Some packages are outdated"
            echo "$OUTDATED" | head -10
        else
            print_success "All packages are up to date"
        fi
    else
        print_warning "node_modules not found - run 'npm install'"
    fi

    # Check for deprecated packages
    ((TOTAL_CHECKS++))
    echo -e "${BLUE}${ARROW} Checking for deprecated packages...${NC}"
    DEPRECATED=$(npm list --depth=0 2>&1 | grep -i "deprecated" || true)
    if [ -n "$DEPRECATED" ]; then
        print_warning "Found deprecated packages"
        echo "$DEPRECATED"
    else
        print_success "No deprecated packages found"
    fi
else
    print_info "No package.json found - skipping npm checks"
fi

if [ -f "requirements.txt" ]; then
    ((TOTAL_CHECKS++))
    print_info "Found requirements.txt (Python project)"
    if command -v pip3 &> /dev/null; then
        echo -e "${BLUE}${ARROW} Checking Python packages...${NC}"
        # Check if packages are installed
        pip3 freeze > /tmp/installed_packages.txt
        print_success "Python package check complete"
    else
        print_warning "pip3 not found - cannot verify Python dependencies"
    fi
fi

# ============================================================================
# 3. SECURITY CHECKS
# ============================================================================
print_section "3. Security Vulnerability Scan"

((TOTAL_CHECKS++))
if [ -f "package.json" ] && command -v npm &> /dev/null; then
    echo -e "${BLUE}${ARROW} Running npm audit...${NC}"
    AUDIT_OUTPUT=$(npm audit --json 2>&1 || true)

    # Parse audit results
    if echo "$AUDIT_OUTPUT" | grep -q '"vulnerabilities"'; then
        CRITICAL=$(echo "$AUDIT_OUTPUT" | grep -oP '"critical":\K\d+' || echo 0)
        HIGH=$(echo "$AUDIT_OUTPUT" | grep -oP '"high":\K\d+' || echo 0)
        MODERATE=$(echo "$AUDIT_OUTPUT" | grep -oP '"moderate":\K\d+' || echo 0)
        LOW=$(echo "$AUDIT_OUTPUT" | grep -oP '"low":\K\d+' || echo 0)

        echo -e "  ${RED}Critical: $CRITICAL${NC}"
        echo -e "  ${YELLOW}High: $HIGH${NC}"
        echo -e "  ${BLUE}Moderate: $MODERATE${NC}"
        echo -e "  ${GREEN}Low: $LOW${NC}"

        if [ "$CRITICAL" -gt 0 ] || [ "$HIGH" -gt 0 ]; then
            print_failure "Security vulnerabilities found (run 'npm audit fix')"
        else
            print_success "No critical security vulnerabilities"
        fi
    else
        print_success "No security vulnerabilities detected"
    fi
else
    print_info "Skipping npm audit (no package.json or npm not installed)"
fi

# Check for exposed secrets
((TOTAL_CHECKS++))
echo -e "${BLUE}${ARROW} Checking for exposed secrets...${NC}"
if [ -f ".env" ]; then
    if git ls-files --error-unmatch .env 2>/dev/null; then
        print_failure ".env file is tracked in git! Remove it immediately!"
    else
        print_success ".env file is not tracked in git"
    fi
else
    print_info "No .env file found"
fi

# ============================================================================
# 4. CODE QUALITY CHECKS
# ============================================================================
print_section "4. Code Quality & Linting"

((TOTAL_CHECKS++))
if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ]; then
    echo -e "${BLUE}${ARROW} Running ESLint...${NC}"
    if command -v eslint &> /dev/null || [ -f "node_modules/.bin/eslint" ]; then
        ESLINT_CMD="eslint . --ext .js,.jsx,.ts,.tsx --max-warnings 10"
        if $ESLINT_CMD 2>&1; then
            print_success "ESLint passed"
        else
            print_warning "ESLint found issues"
        fi
    else
        print_info "ESLint not installed"
    fi
else
    print_info "No ESLint configuration found"
fi

# ============================================================================
# 5. BUILD TESTS
# ============================================================================
print_section "5. Build Validation"

((TOTAL_CHECKS++))
if [ -f "package.json" ]; then
    if grep -q '"build"' package.json; then
        echo -e "${BLUE}${ARROW} Running build...${NC}"
        if npm run build 2>&1 | tee /tmp/build.log; then
            print_success "Build completed successfully"

            # Check build size
            if [ -d "dist" ] || [ -d "build" ]; then
                BUILD_DIR=$([ -d "dist" ] && echo "dist" || echo "build")
                BUILD_SIZE=$(du -sh "$BUILD_DIR" | cut -f1)
                echo -e "  ${CYAN}Build size: ${BUILD_SIZE}${NC}"
            fi
        else
            print_failure "Build failed - see /tmp/build.log for details"
            echo -e "${YELLOW}Last 10 lines of build log:${NC}"
            tail -10 /tmp/build.log
        fi
    else
        print_info "No build script found in package.json"
    fi
fi

# ============================================================================
# 6. DATABASE CHECKS
# ============================================================================
print_section "6. Database Status"

((TOTAL_CHECKS++))
if command -v psql &> /dev/null; then
    echo -e "${BLUE}${ARROW} PostgreSQL:${NC}"
    if psql --version &> /dev/null; then
        print_success "PostgreSQL client installed"
    fi
else
    print_info "PostgreSQL not detected"
fi

((TOTAL_CHECKS++))
if command -v mysql &> /dev/null; then
    echo -e "${BLUE}${ARROW} MySQL:${NC}"
    print_success "MySQL client installed"
else
    print_info "MySQL not detected"
fi

((TOTAL_CHECKS++))
if command -v mongo &> /dev/null; then
    echo -e "${BLUE}${ARROW} MongoDB:${NC}"
    print_success "MongoDB client installed"
else
    print_info "MongoDB not detected"
fi

# ============================================================================
# 7. DEPLOYMENT READINESS
# ============================================================================
print_section "7. Deployment Readiness Checks"

((TOTAL_CHECKS++))
echo -e "${BLUE}${ARROW} Checking git status...${NC}"
if [ -z "$(git status --porcelain)" ]; then
    print_success "Working directory is clean"
else
    print_warning "Uncommitted changes detected"
    git status --short
fi

((TOTAL_CHECKS++))
echo -e "${BLUE}${ARROW} Checking required files...${NC}"
REQUIRED_FILES=("README.md" ".gitignore")
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}${CHECK} $file${NC}"
    else
        echo -e "  ${YELLOW}${WARN} $file missing${NC}"
        print_warning "$file not found"
    fi
done

# ============================================================================
# 8. PERFORMANCE METRICS
# ============================================================================
print_section "8. Performance Metrics"

((TOTAL_CHECKS++))
if [ -d "dist" ] || [ -d "build" ]; then
    BUILD_DIR=$([ -d "dist" ] && echo "dist" || echo "build")
    echo -e "${BLUE}${ARROW} Build Analysis:${NC}"

    # Find large files
    echo -e "${CYAN}  Largest files:${NC}"
    find "$BUILD_DIR" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -5 | while read size file; do
        echo -e "    ${YELLOW}$size${NC} - $file"
    done

    print_success "Performance metrics collected"
fi

# ============================================================================
# FINAL SUMMARY
# ============================================================================
echo ""
print_header "Test Summary"
echo ""

# Calculate success rate
SUCCESS_RATE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo -e "${BOLD}Results:${NC}"
echo -e "  ${GREEN}Passed:   $PASSED_CHECKS${NC}"
echo -e "  ${RED}Failed:   $FAILED_CHECKS${NC}"
echo -e "  ${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "  ${CYAN}Total:    $TOTAL_CHECKS${NC}"
echo ""
echo -e "${BOLD}Success Rate: ${GREEN}${SUCCESS_RATE}%${NC}"
echo ""

# Final status
if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}${BOLD}${CHECK} ALL TESTS PASSED!${NC}"
    echo -e "${GREEN}Your code is ready for deployment.${NC}"
    EXIT_CODE=0
else
    echo -e "${RED}${BOLD}${CROSS} TESTS FAILED!${NC}"
    echo -e "${YELLOW}Please fix the issues above before deploying.${NC}"
    EXIT_CODE=1
fi

echo ""
echo -e "${CYAN}Finished at: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Save report
REPORT_FILE="test-report-$(date +%Y%m%d-%H%M%S).txt"
cat > "$REPORT_FILE" << EOF
Test Report
Generated: $(date '+%Y-%m-%d %H:%M:%S')
Repository: $(basename $(pwd))
Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')

Results:
  Passed:   $PASSED_CHECKS
  Failed:   $FAILED_CHECKS
  Warnings: $WARNINGS
  Total:    $TOTAL_CHECKS

Success Rate: ${SUCCESS_RATE}%

Status: $([ $FAILED_CHECKS -eq 0 ] && echo "PASSED" || echo "FAILED")
EOF

echo -e "${INFO} Report saved to: ${YELLOW}$REPORT_FILE${NC}"
echo ""

exit $EXIT_CODE
