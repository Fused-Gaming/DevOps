#!/bin/bash

# Check for DevOps Repository Updates
# Author: User (via git config)
# Version: 1.0.0

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get git author info
GIT_AUTHOR=$(git config user.name || echo "Unknown")

# Display header
clear
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${CYAN}  DevOps Repository Update Checker${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Checking for new features and fixes...${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${BLUE}→ Current branch:${NC} ${YELLOW}$CURRENT_BRANCH${NC}"

# Check if there's a remote
if ! git remote get-url origin &> /dev/null; then
    echo -e "${YELLOW}⚠️  No remote repository configured${NC}"
    echo ""
    echo "This appears to be a local-only repository."
    echo "No updates available to check."
    exit 0
fi

REMOTE_URL=$(git remote get-url origin)
echo -e "${BLUE}→ Remote:${NC} ${YELLOW}$REMOTE_URL${NC}"
echo ""

# Fetch latest changes
echo -e "${BLUE}→ Fetching latest changes...${NC}"
if git fetch origin 2>&1 | grep -q "fatal\|error"; then
    echo -e "${RED}✗ Failed to fetch from remote${NC}"
    echo ""
    echo "Check your network connection and try again."
    exit 1
fi
echo -e "${GREEN}✓ Fetch complete${NC}"
echo ""

# Check if remote branch exists
if ! git rev-parse origin/$CURRENT_BRANCH &> /dev/null; then
    echo -e "${YELLOW}⚠️  No remote tracking branch for $CURRENT_BRANCH${NC}"
    echo ""
    echo "This is a local-only branch."
    echo "No updates available to check."
    exit 0
fi

# Compare commits
COMMITS_BEHIND=$(git rev-list HEAD..origin/$CURRENT_BRANCH --count)
COMMITS_AHEAD=$(git rev-list origin/$CURRENT_BRANCH..HEAD --count)

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${CYAN}  Update Status${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$COMMITS_BEHIND" -eq 0 ] && [ "$COMMITS_AHEAD" -eq 0 ]; then
    echo -e "${GREEN}✓ You are up to date!${NC}"
    echo ""
    echo "No new features or fixes available."

elif [ "$COMMITS_BEHIND" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Updates available!${NC}"
    echo ""
    echo -e "  ${MAGENTA}$COMMITS_BEHIND${NC} new commit(s) available"

    if [ "$COMMITS_AHEAD" -gt 0 ]; then
        echo -e "  ${CYAN}$COMMITS_AHEAD${NC} local commit(s) not pushed"
        echo ""
        echo -e "${YELLOW}Note:${NC} You have unpushed local changes."
        echo "You may need to merge or rebase after updating."
    fi

    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${CYAN}  What's New${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Show new commits
    git log HEAD..origin/$CURRENT_BRANCH --pretty=format:"${GREEN}%h${NC} - %s ${YELLOW}(%cr)${NC} ${CYAN}<%an>${NC}" --abbrev-commit | head -10
    echo ""
    echo ""

    # Count changes by type
    FEATURES=$(git log HEAD..origin/$CURRENT_BRANCH --oneline | grep -c "^[^ ]* feat" || echo 0)
    FIXES=$(git log HEAD..origin/$CURRENT_BRANCH --oneline | grep -c "^[^ ]* fix" || echo 0)
    CHORES=$(git log HEAD..origin/$CURRENT_BRANCH --oneline | grep -c "^[^ ]* chore" || echo 0)
    DOCS=$(git log HEAD..origin/$CURRENT_BRANCH --oneline | grep -c "^[^ ]* docs" || echo 0)

    echo -e "${BOLD}Summary of Changes:${NC}"
    echo ""
    [ "$FEATURES" -gt 0 ] && echo -e "  ${GREEN}✨ $FEATURES new feature(s)${NC}"
    [ "$FIXES" -gt 0 ] && echo -e "  ${GREEN}🐛 $FIXES bug fix(es)${NC}"
    [ "$DOCS" -gt 0 ] && echo -e "  ${BLUE}📝 $DOCS documentation update(s)${NC}"
    [ "$CHORES" -gt 0 ] && echo -e "  ${CYAN}🔧 $CHORES maintenance update(s)${NC}"
    echo ""

    # Show files that will be changed
    echo -e "${BOLD}Files Affected:${NC}"
    echo ""
    git diff --stat HEAD..origin/$CURRENT_BRANCH | head -15
    echo ""

    # Prompt to update
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    if [ "$COMMITS_AHEAD" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Warning:${NC} You have ${COMMITS_AHEAD} unpushed local commit(s)"
        echo ""
        echo "Update options:"
        echo ""
        echo "  1. Merge remote changes:"
        echo "     ${CYAN}git pull origin $CURRENT_BRANCH${NC}"
        echo ""
        echo "  2. Rebase your changes on top:"
        echo "     ${CYAN}git pull --rebase origin $CURRENT_BRANCH${NC}"
        echo ""
        echo "  3. Stash and pull:"
        echo "     ${CYAN}git stash && git pull origin $CURRENT_BRANCH && git stash pop${NC}"
        echo ""
    else
        read -p "$(echo -e ${GREEN}Would you like to update now? [y/N]:${NC} )" -n 1 -r
        echo ""
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}→ Updating repository...${NC}"

            # Check for uncommitted changes
            if [ -n "$(git status --porcelain)" ]; then
                echo -e "${YELLOW}⚠️  You have uncommitted changes${NC}"
                echo ""
                read -p "$(echo -e ${YELLOW}Stash changes before updating? [y/N]:${NC} )" -n 1 -r
                echo ""

                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    git stash
                    echo -e "${GREEN}✓ Changes stashed${NC}"
                    STASHED=true
                fi
            fi

            # Pull changes
            if git pull origin $CURRENT_BRANCH; then
                echo ""
                echo -e "${GREEN}✓ Update successful!${NC}"
                echo ""

                # Restore stashed changes if any
                if [ "$STASHED" = true ]; then
                    echo -e "${BLUE}→ Restoring stashed changes...${NC}"
                    if git stash pop; then
                        echo -e "${GREEN}✓ Changes restored${NC}"
                    else
                        echo -e "${YELLOW}⚠️  Merge conflicts detected${NC}"
                        echo "Please resolve conflicts and run: ${CYAN}git stash drop${NC}"
                    fi
                fi

                echo ""
                echo -e "${BOLD}Updated to latest version!${NC}"
                echo ""
                echo "New scripts may need to be made executable:"
                echo "  ${CYAN}chmod +x scripts/*.sh${NC}"
                echo ""
                echo "Consider running setup to install any new git hooks:"
                echo "  ${CYAN}make setup${NC}"
                echo ""
            else
                echo ""
                echo -e "${RED}✗ Update failed${NC}"
                echo ""
                echo "You may need to resolve conflicts manually."
                exit 1
            fi
        else
            echo -e "${BLUE}Update cancelled${NC}"
            echo ""
            echo "To update later, run:"
            echo "  ${CYAN}git pull origin $CURRENT_BRANCH${NC}"
            echo "  or"
            echo "  ${CYAN}make update${NC}"
            echo ""
        fi
    fi

else
    # Local is ahead
    echo -e "${CYAN}ℹ️  Your repository is ahead of remote${NC}"
    echo ""
    echo -e "  ${CYAN}$COMMITS_AHEAD${NC} local commit(s) not pushed"
    echo ""
    echo "Consider pushing your changes:"
    echo "  ${CYAN}git push origin $CURRENT_BRANCH${NC}"
    echo ""
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}Version Information:${NC}"
echo ""
echo -e "  Current commit: ${YELLOW}$(git rev-parse --short HEAD)${NC}"
echo -e "  Latest commit:  ${YELLOW}$(git rev-parse --short origin/$CURRENT_BRANCH)${NC}"
echo ""
echo -e "  Run ${CYAN}make status${NC} for more information"
echo ""

exit 0
