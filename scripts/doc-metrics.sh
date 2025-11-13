#!/bin/bash
# Feature Documentation Metrics Script
# Tracks documentation coverage and quality metrics

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Navigate to repo root
cd "$(git rev-parse --show-toplevel)" || exit 1

print_header "FEATURE DOCUMENTATION METRICS"
echo ""
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Count feature branches
print_header "Feature Branch Coverage"
echo ""

# Get all feature branches (local and remote)
FEATURE_BRANCHES=$(git branch -a | grep -E 'feature/|feat/' | sed 's/^[* ]*//;s/remotes\/origin\///' | sort -u | wc -l || echo 0)

# Count documented features
if [ -d "docs/features" ]; then
    DOCUMENTED_FEATURES=$(find docs/features -name "*.md" ! -name "README.md" | wc -l || echo 0)
else
    DOCUMENTED_FEATURES=0
fi

# Calculate coverage percentage
if [ "$FEATURE_BRANCHES" -gt 0 ]; then
    COVERAGE=$(( DOCUMENTED_FEATURES * 100 / FEATURE_BRANCHES ))
else
    COVERAGE=0
fi

echo "Feature branches (total): $FEATURE_BRANCHES"
echo "Documented features:      $DOCUMENTED_FEATURES"
echo "Coverage:                 $COVERAGE%"
echo ""

if [ "$COVERAGE" -ge 90 ]; then
    print_success "Excellent coverage (≥90%)"
elif [ "$COVERAGE" -ge 70 ]; then
    print_warning "Good coverage (70-89%)"
else
    print_error "Low coverage (<70%)"
fi

echo ""

# Analyze documentation by tier (based on recent PRs)
print_header "Coverage by Tier (Last 30 Days)"
echo ""

# Get recent feature branch PRs and calculate tiers
TIER1_TOTAL=0
TIER1_DOCUMENTED=0
TIER2_TOTAL=0
TIER2_DOCUMENTED=0
TIER3_TOTAL=0
TIER3_DOCUMENTED=0

# Get list of recent merged feature branches
RECENT_BRANCHES=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads refs/remotes/origin | grep -E 'feature/|feat/' | head -20 || echo "")

for branch in $RECENT_BRANCHES; do
    # Extract feature name
    FEATURE_NAME=$(echo "$branch" | sed 's|.*/||')

    # Calculate lines changed (compare with main/master)
    BASE_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

    # Check if branch exists
    if git rev-parse "$branch" >/dev/null 2>&1; then
        LINES_CHANGED=$(git diff --shortstat "$BASE_BRANCH"..."$branch" 2>/dev/null | awk '{print $4+$6}' || echo 0)

        # Determine tier
        if [ "$LINES_CHANGED" -lt 200 ]; then
            TIER=1
            TIER1_TOTAL=$((TIER1_TOTAL + 1))
        elif [ "$LINES_CHANGED" -lt 1000 ]; then
            TIER=2
            TIER2_TOTAL=$((TIER2_TOTAL + 1))
        else
            TIER=3
            TIER3_TOTAL=$((TIER3_TOTAL + 1))
        fi

        # Check if documented
        if [ -f "docs/features/$FEATURE_NAME.md" ] || [ -f "docs/features/$FEATURE_NAME/README.md" ]; then
            if [ "$TIER" -eq 1 ]; then
                TIER1_DOCUMENTED=$((TIER1_DOCUMENTED + 1))
            elif [ "$TIER" -eq 2 ]; then
                TIER2_DOCUMENTED=$((TIER2_DOCUMENTED + 1))
            else
                TIER3_DOCUMENTED=$((TIER3_DOCUMENTED + 1))
            fi
        fi
    fi
done

# Calculate tier coverage
if [ "$TIER1_TOTAL" -gt 0 ]; then
    TIER1_COVERAGE=$(( TIER1_DOCUMENTED * 100 / TIER1_TOTAL ))
else
    TIER1_COVERAGE=0
fi

if [ "$TIER2_TOTAL" -gt 0 ]; then
    TIER2_COVERAGE=$(( TIER2_DOCUMENTED * 100 / TIER2_TOTAL ))
else
    TIER2_COVERAGE=0
fi

if [ "$TIER3_TOTAL" -gt 0 ]; then
    TIER3_COVERAGE=$(( TIER3_DOCUMENTED * 100 / TIER3_TOTAL ))
else
    TIER3_COVERAGE=0
fi

echo "Tier 1 (Small, <200 lines):   $TIER1_DOCUMENTED/$TIER1_TOTAL ($TIER1_COVERAGE%) [Recommended]"
echo "Tier 2 (Medium, 200-1000):     $TIER2_DOCUMENTED/$TIER2_TOTAL ($TIER2_COVERAGE%) [Required]"
echo "Tier 3 (Large, >1000 lines):   $TIER3_DOCUMENTED/$TIER3_TOTAL ($TIER3_COVERAGE%) [Required]"
echo ""

# Quality checks
print_header "Documentation Quality"
echo ""

if [ ! -d "docs/features" ]; then
    print_warning "No docs/features directory found"
    exit 0
fi

TOTAL_DOCS=$(find docs/features -name "*.md" ! -name "README.md" | wc -l || echo 0)

if [ "$TOTAL_DOCS" -eq 0 ]; then
    print_warning "No documentation files found"
    exit 0
fi

# Check each documentation file
ALL_SECTIONS_COUNT=0
MIN_WORDS_COUNT=0
HAS_PROJECT_REF_COUNT=0
HAS_DESIGN_DECISION_COUNT=0

for doc in docs/features/*.md; do
    [ -f "$doc" ] || continue

    FILENAME=$(basename "$doc")

    # Check for all 4 required sections
    HAS_OVERVIEW=$(grep -c "^## Overview" "$doc" || echo 0)
    HAS_GOALS=$(grep -c "^## Goals" "$doc" || echo 0)
    HAS_IMPLEMENTATION=$(grep -c "^## Implementation" "$doc" || echo 0)
    HAS_TESTING=$(grep -c "^## Testing" "$doc" || echo 0)

    if [ "$HAS_OVERVIEW" -gt 0 ] && [ "$HAS_GOALS" -gt 0 ] && [ "$HAS_IMPLEMENTATION" -gt 0 ] && [ "$HAS_TESTING" -gt 0 ]; then
        ALL_SECTIONS_COUNT=$((ALL_SECTIONS_COUNT + 1))
    fi

    # Check word count (minimum 100 words)
    WORD_COUNT=$(wc -w < "$doc")
    if [ "$WORD_COUNT" -ge 100 ]; then
        MIN_WORDS_COUNT=$((MIN_WORDS_COUNT + 1))
    fi

    # Check for project goal references
    if grep -qi -E "project goal|roadmap|requirement|objective|user story" "$doc"; then
        HAS_PROJECT_REF_COUNT=$((HAS_PROJECT_REF_COUNT + 1))
    fi

    # Check for design decisions
    if grep -qi -E "decision:|alternative:|why:" "$doc"; then
        HAS_DESIGN_DECISION_COUNT=$((HAS_DESIGN_DECISION_COUNT + 1))
    fi
done

# Calculate percentages
ALL_SECTIONS_PCT=$(( ALL_SECTIONS_COUNT * 100 / TOTAL_DOCS ))
MIN_WORDS_PCT=$(( MIN_WORDS_COUNT * 100 / TOTAL_DOCS ))
PROJECT_REF_PCT=$(( HAS_PROJECT_REF_COUNT * 100 / TOTAL_DOCS ))
DESIGN_DECISION_PCT=$(( HAS_DESIGN_DECISION_COUNT * 100 / TOTAL_DOCS ))

echo "All 4 sections present:     $ALL_SECTIONS_COUNT/$TOTAL_DOCS ($ALL_SECTIONS_PCT%)"
echo "Minimum 100 words:           $MIN_WORDS_COUNT/$TOTAL_DOCS ($MIN_WORDS_PCT%)"
echo "References project goals:    $HAS_PROJECT_REF_COUNT/$TOTAL_DOCS ($PROJECT_REF_PCT%)"
echo "Has design decisions:        $HAS_DESIGN_DECISION_COUNT/$TOTAL_DOCS ($DESIGN_DECISION_PCT%)"
echo ""

# Overall quality score (average of the four metrics)
QUALITY_SCORE=$(( (ALL_SECTIONS_PCT + MIN_WORDS_PCT + PROJECT_REF_PCT + DESIGN_DECISION_PCT) / 4 ))

echo "Overall Quality Score: $QUALITY_SCORE%"
echo ""

if [ "$QUALITY_SCORE" -ge 85 ]; then
    print_success "Excellent quality (≥85%)"
elif [ "$QUALITY_SCORE" -ge 70 ]; then
    print_warning "Good quality (70-84%)"
else
    print_error "Needs improvement (<70%)"
fi

echo ""

# Detailed breakdown
print_header "Top 5 Most Recent Documentation"
echo ""

# shellcheck disable=SC2012
ls -lt docs/features/*.md 2>/dev/null | grep -v "README.md" | head -5 | while read -r line; do
    FILE=$(echo "$line" | awk '{print $NF}')
    WORDS=$(wc -w < "$FILE")
    SECTIONS=$(grep -c "^## " "$FILE" || echo 0)
    NAME=$(basename "$FILE" .md)
    echo "$NAME: $WORDS words, $SECTIONS sections"
done

echo ""

# Files needing improvement
print_header "Documentation Needing Improvement"
echo ""

NEEDS_IMPROVEMENT=0
for doc in docs/features/*.md; do
    [ -f "$doc" ] || continue

    FILENAME=$(basename "$doc")
    WORD_COUNT=$(wc -w < "$doc")
    SECTIONS=$(grep -c "^## " "$doc" || echo 0)

    # Check if needs improvement (< 100 words or < 4 sections)
    if [ "$WORD_COUNT" -lt 100 ] || [ "$SECTIONS" -lt 4 ]; then
        echo "- $FILENAME: $WORD_COUNT words, $SECTIONS sections"
        NEEDS_IMPROVEMENT=$((NEEDS_IMPROVEMENT + 1))
    fi
done

if [ "$NEEDS_IMPROVEMENT" -eq 0 ]; then
    print_success "All documentation meets minimum standards!"
else
    print_warning "$NEEDS_IMPROVEMENT file(s) need improvement"
fi

echo ""

# Summary
print_header "Summary & Recommendations"
echo ""

if [ "$TIER2_COVERAGE" -lt 100 ] || [ "$TIER3_COVERAGE" -lt 100 ]; then
    print_warning "Tier 2/3 coverage below 100% - these are required!"
    echo "   Action: Document all medium and large features"
fi

if [ "$QUALITY_SCORE" -lt 80 ]; then
    print_warning "Quality score below 80%"
    echo "   Action: Review and improve existing documentation"
fi

if [ "$PROJECT_REF_PCT" -lt 70 ]; then
    print_warning "Few docs reference project goals ($PROJECT_REF_PCT%)"
    echo "   Action: Add project alignment context to documentation"
fi

if [ "$DESIGN_DECISION_PCT" -lt 60 ]; then
    print_warning "Few docs include design decisions ($DESIGN_DECISION_PCT%)"
    echo "   Action: Document why decisions were made, not just what was built"
fi

if [ "$COVERAGE" -ge 90 ] && [ "$QUALITY_SCORE" -ge 85 ]; then
    echo ""
    print_success "Great job! Documentation coverage and quality are excellent! 🎉"
fi

echo ""
print_header "Metrics Collection Complete"
echo ""

# Exit with appropriate code
if [ "$TIER2_COVERAGE" -lt 100 ] || [ "$TIER3_COVERAGE" -lt 100 ]; then
    exit 1  # Fail if Tier 2/3 not fully documented
else
    exit 0
fi
