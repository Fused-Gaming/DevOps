#!/bin/bash
# Script to create all milestone issues using GitHub CLI
# Generated: 2025-11-17

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  GitHub Milestone Issues Creator${NC}"
echo -e "${BLUE}  DevOps Repository - MVP Tracking${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    echo ""
    echo "Install it with:"
    echo "  macOS:   brew install gh"
    echo "  Linux:   See https://github.com/cli/cli#installation"
    echo "  Windows: winget install GitHub.cli"
    echo ""
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}You need to authenticate with GitHub CLI${NC}"
    echo "Run: gh auth login"
    exit 1
fi

REPO="Fused-Gaming/DevOps"

echo -e "${GREEN}✓ GitHub CLI installed and authenticated${NC}"
echo ""

# Ask for confirmation
echo -e "${YELLOW}This script will create 37 issues in ${REPO}${NC}"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo -e "${BLUE}Creating issues...${NC}"
echo ""

# Counter
CREATED=0
SKIPPED=0

# Helper function to create issue
create_issue() {
    local title="$1"
    local body="$2"
    local milestone="$3"
    local labels="$4"
    local state="${5:-open}"  # Default to open

    echo -ne "Creating: ${title:0:60}... "

    if [ "$state" = "closed" ]; then
        # Create and immediately close
        ISSUE_NUM=$(gh issue create \
            --repo "$REPO" \
            --title "$title" \
            --body "$body" \
            --milestone "$milestone" \
            --label "$labels" \
            2>&1 | grep -oP '(?<=/issues/)\d+' || echo "")

        if [ -n "$ISSUE_NUM" ]; then
            gh issue close "$ISSUE_NUM" --repo "$REPO" &> /dev/null
            echo -e "${GREEN}✓ #${ISSUE_NUM} (closed)${NC}"
            ((CREATED++))
        else
            echo -e "${RED}✗ Failed${NC}"
            ((SKIPPED++))
        fi
    else
        if gh issue create \
            --repo "$REPO" \
            --title "$title" \
            --body "$body" \
            --milestone "$milestone" \
            --label "$labels" &> /dev/null; then
            echo -e "${GREEN}✓${NC}"
            ((CREATED++))
        else
            echo -e "${RED}✗ Failed${NC}"
            ((SKIPPED++))
        fi
    fi
}

# =============================================================================
# MILESTONE 1: Installable Developer Toolkit
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Milestone 1: Installable Developer Toolkit${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Issue #1 - DONE
create_issue \
    "Basic installer implementation" \
    "Create setup-devops-quick-access.sh that:
- Creates ~/.devops-prompts/ directory
- Generates prompt files
- Adds aliases to shell config
- Creates Makefile

**Status:** ✅ Completed - installer exists and works

**Files:**
- setup-devops-quick-access.sh
- README.md" \
    "Installable Developer Toolkit" \
    "enhancement,milestone-1" \
    "closed"

# Issue #2
create_issue \
    "Add --dry-run mode to installer" \
    "Add \`--dry-run\` flag to setup-devops-quick-access.sh

**Requirements (from MVP.md):**
- Show all changes that would be made without executing
- Display files that would be created
- Show aliases that would be added
- Preview shell config modifications

**Acceptance Criteria:**
- \`bash setup-devops-quick-access.sh --dry-run\` runs without modifying files
- Outputs clear preview of all changes
- User can review before committing to install

**Files to modify:**
- setup-devops-quick-access.sh

**Estimated effort:** 2-3 hours" \
    "Installable Developer Toolkit" \
    "enhancement,milestone-1,priority:high"

# Issue #3
create_issue \
    "Add backup/rollback mechanism to installer" \
    "**Requirements (from MVP.md):**
- Back up existing aliases before modification
- Create timestamped backups (e.g., .bashrc.backup.20251117)
- Provide rollback command/instructions
- Detect and warn about conflicts

**Acceptance Criteria:**
- Installer creates backup of .bashrc/.zshrc before modification
- Backup includes timestamp
- README includes rollback instructions
- Installer outputs backup location

**Files to modify:**
- setup-devops-quick-access.sh
- README.md (add rollback section)

**Estimated effort:** 2-3 hours" \
    "Installable Developer Toolkit" \
    "enhancement,milestone-1,priority:high"

# Issue #4
create_issue \
    "Add post-install verification and sanity checks" \
    "**Requirements (from MVP.md):**
- Automated sanity checks after install
- Print verified list of added commands
- Verify devops-quick runs successfully

**Acceptance Criteria:**
- Installer prints verification summary at end
- Lists all installed commands
- Verifies each command is accessible
- Returns clear success/failure status

**Example output:**
\`\`\`
✓ Installation Complete

Installed Commands:
✓ devops - Full pipeline check
✓ devops-quick - Quick health check
✓ devops-merge - Pre-merge prep
✓ devops-security - Security scan
✓ devops-deploy - Deployment workflow

Verification: 5/5 commands accessible
Try it: devops-quick
\`\`\`

**Files to modify:**
- setup-devops-quick-access.sh

**Estimated effort:** 2 hours" \
    "Installable Developer Toolkit" \
    "enhancement,milestone-1,testing"

# Issue #5
create_issue \
    "Create installer idempotency tests" \
    "**Requirements (from MVP.md):**
- Test script exit codes
- Test idempotency (install twice -> no duplicate aliases)
- Verify no errors on re-run

**Acceptance Criteria:**
- Create tests/test-installer.sh
- Test 1: Fresh install succeeds (exit code 0)
- Test 2: Second install doesn't create duplicates
- Test 3: Verify shell config has exactly one copy of each alias
- Add to CI/CD workflow

**Files to create:**
- tests/test-installer.sh
- .github/workflows/test-installer.yml (optional)

**Estimated effort:** 3-4 hours" \
    "Installable Developer Toolkit" \
    "testing,milestone-1"

# Issue #6
create_issue \
    "Test installer on multiple shells (bash, zsh, fish)" \
    "Verify installer works correctly on:
- bash (most common)
- zsh (macOS default)
- fish (alternative shell)

**Acceptance Criteria:**
- Installer detects shell type correctly
- Works on bash 4.x, 5.x
- Works on zsh 5.x
- Documents fish shell limitations (if any)
- README lists supported shells

**Files to modify:**
- setup-devops-quick-access.sh (improve shell detection)
- README.md (list supported shells)

**Estimated effort:** 2-3 hours" \
    "Installable Developer Toolkit" \
    "testing,milestone-1"

# Issue #7 - DONE
create_issue \
    "Create CLI aliases for devops commands" \
    "Create aliases for:
- devops (full pipeline)
- devops-quick (quick check)
- devops-merge (pre-merge)
- devops-security (security scan)
- devops-deploy (deployment)

**Status:** ✅ Completed - all aliases exist and functional

**Files:**
- setup-devops-quick-access.sh
- Makefile" \
    "Installable Developer Toolkit" \
    "enhancement,milestone-1" \
    "closed"

# Issue #8
create_issue \
    "Document installer rollback procedure" \
    "Add clear rollback instructions to README

**Requirements:**
- How to restore backed-up shell config
- How to remove installed aliases
- How to remove ~/.devops-prompts directory
- Troubleshooting common issues

**Acceptance Criteria:**
- README has \"Rollback/Uninstall\" section
- Step-by-step removal instructions
- Example restore command from backup

**Files to modify:**
- README.md

**Estimated effort:** 1 hour" \
    "Installable Developer Toolkit" \
    "documentation,milestone-1"

echo ""

# =============================================================================
# MILESTONE 2: CI/CD Templates
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Milestone 2: CI/CD Templates${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Issue #9 - DONE
create_issue \
    "Create ci-cd-enhanced.yml GitHub Actions workflow" \
    "Comprehensive CI/CD workflow with:
- Security audit job
- Build verification
- Test execution
- Deployment

**Status:** ✅ Completed - workflow exists at .github/workflows/ci-cd-enhanced.yml

**Files:**
- .github/workflows/ci-cd-enhanced.yml" \
    "CI/CD Templates" \
    "enhancement,milestone-2,ci-cd" \
    "closed"

# Issue #10 - DONE
create_issue \
    "Create feature-docs-check.yml workflow" \
    "Feature documentation enforcement workflow

**Status:** ✅ Completed - workflow exists

**Files:**
- .github/workflows/feature-docs-check.yml" \
    "CI/CD Templates" \
    "enhancement,milestone-2,ci-cd" \
    "closed"

# Issue #11
create_issue \
    "Document how to copy CI/CD workflows to new project" \
    "**Requirements (from MVP.md):**
- README includes instructions to copy workflows into a real repo
- Step-by-step guide
- Configuration requirements (secrets, variables)

**Acceptance Criteria:**
- README has \"Using Workflows in Your Project\" section
- Copy/paste instructions
- List of required secrets/variables
- Example: \"Copy .github/workflows/ci-cd-enhanced.yml to your repo...\"

**Files to modify:**
- README.md
- github-actions-workflows.md (update to reference actual files)

**Estimated effort:** 2 hours" \
    "CI/CD Templates" \
    "documentation,milestone-2,priority:high"

# Issue #12
create_issue \
    "Create example project demonstrating workflows" \
    "**Requirements (from MVP.md):**
- Sample Node.js or static web project
- Uses ci-cd-enhanced.yml workflow
- Demonstrates successful workflow run
- Can be separate repo or example/ directory

**Acceptance Criteria:**
- Example project exists
- Workflows run successfully
- README links to example
- Shows green check marks in GitHub Actions

**Files to create:**
- example/ directory OR separate repository
- example/README.md

**Estimated effort:** 3-4 hours" \
    "CI/CD Templates" \
    "enhancement,milestone-2,example"

# Issue #13
create_issue \
    "Add workflow configuration guide (secrets, variables)" \
    "Document how to configure workflows for different environments

**Should Include:**
- Required GitHub secrets
- Environment variables to set
- How to customize for your stack
- Troubleshooting workflow failures

**Acceptance Criteria:**
- Clear guide in README or separate WORKFLOWS.md
- Lists all configurable variables
- Examples for common scenarios

**Estimated effort:** 2 hours" \
    "CI/CD Templates" \
    "documentation,milestone-2"

# Issue #14
create_issue \
    "Update github-actions-workflows.md with actual examples" \
    "Update github-actions-workflows.md to reference actual workflow files

**Requirements:**
- Link to actual workflows in .github/workflows/
- Show real examples from our workflows
- Explain each job and step
- Update any outdated content

**Estimated effort:** 2 hours" \
    "CI/CD Templates" \
    "documentation,milestone-2"

# Issue #15
create_issue \
    "Create test PR to verify workflows" \
    "Create a sample PR to verify workflows run correctly

**Acceptance Criteria:**
- Create feature branch
- Make sample change
- Open PR
- Verify ci-cd-enhanced.yml runs
- Verify feature-docs-check.yml runs
- All checks pass
- Document results

**Estimated effort:** 1 hour" \
    "CI/CD Templates" \
    "testing,milestone-2"

echo ""

# =============================================================================
# MILESTONE 3: Security Baseline
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Milestone 3: Security Baseline${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Issue #16 - DONE
create_issue \
    "Create security prompt template" \
    "Create comprehensive security checklist prompt

**Status:** ✅ Completed - devops-security prompt exists

**Files:**
- .devops/prompts/security.md" \
    "Security Baseline" \
    "enhancement,milestone-3,security" \
    "closed"

# Issue #17 - DONE
create_issue \
    "Add security audit job to CI workflow" \
    "Add security scanning to GitHub Actions

**Status:** ✅ Completed - ci-cd-enhanced.yml has security-audit job

**Files:**
- .github/workflows/ci-cd-enhanced.yml" \
    "Security Baseline" \
    "enhancement,milestone-3,security,ci-cd" \
    "closed"

# Issue #18
create_issue \
    "🔴 CRITICAL: Implement executable devops-security script" \
    "**CRITICAL:** devops-security currently just calls Claude Code with a prompt. MVP requires actual executable tool.

**Requirements (from MVP.md):**
- Wire devops-security to run actual tools
- Should execute trufflehog OR git-secrets
- Should run npm audit (or yarn audit)
- Should run .env file linter

**Acceptance Criteria:**
- Create scripts/devops-security.sh
- Detects which tools are installed (trufflehog vs git-secrets)
- Runs npm audit --production
- Validates .env.example exists
- Validates .env is in .gitignore
- Outputs scan results with severity levels
- Update alias to call script instead of prompt

**Files to create:**
- scripts/devops-security.sh

**Files to modify:**
- setup-devops-quick-access.sh (update alias)
- Makefile (update devops-security target)

**Estimated effort:** 4-6 hours
**Priority:** CRITICAL - Biggest MVP gap" \
    "Security Baseline" \
    "bug,milestone-3,priority:critical,security"

# Issue #19
create_issue \
    "Add trufflehog/git-secrets detection and integration" \
    "Integrate secret scanning tools into devops-security

**Requirements:**
- Detect if trufflehog is installed
- Detect if git-secrets is installed
- Use whichever is available
- Provide installation instructions if neither found

**Acceptance Criteria:**
- scripts/devops-security.sh checks for tools
- Runs trufflehog if available: \`trufflehog filesystem .\`
- Runs git-secrets if available: \`git secrets --scan\`
- Outputs clear results
- Provides install instructions if missing

**Documentation to add:**
\`\`\`bash
# Install trufflehog (recommended)
brew install trufflehog

# OR install git-secrets
brew install git-secrets
\`\`\`

**Estimated effort:** 2-3 hours" \
    "Security Baseline" \
    "enhancement,milestone-3,security"

# Issue #20
create_issue \
    "Add npm audit integration to devops-security" \
    "Integrate npm audit into security script

**Requirements:**
- Run npm audit --production
- Parse output for HIGH/CRITICAL vulnerabilities
- Provide clear summary

**Acceptance Criteria:**
- scripts/devops-security.sh runs npm audit
- Shows vulnerability count by severity
- Exits with error code if CRITICAL found
- Works even if no package.json (skips gracefully)

**Estimated effort:** 2 hours" \
    "Security Baseline" \
    "enhancement,milestone-3,security"

# Issue #21
create_issue \
    "Create security remediation guide" \
    "**Requirements (from MVP.md):**
- Example remediation section for common vulnerability types

**Should Include:**
- How to fix exposed secrets
- How to fix npm audit vulnerabilities
- How to properly handle .env files
- Common security pitfalls and fixes

**Acceptance Criteria:**
- Create docs/security-remediation.md
- Link from security-implementation-guide.md
- Includes examples for top 5 common issues

**Estimated effort:** 3 hours" \
    "Security Baseline" \
    "documentation,milestone-3,security"

# Issue #22
create_issue \
    "Add security scan results to PR comments" \
    "Post security scan results as PR comments

**Requirements:**
- GitHub Action posts results to PR
- Shows summary (X vulnerabilities found)
- Links to remediation guide
- Uses actions/github-script or similar

**Acceptance Criteria:**
- PR gets comment after security scan
- Comment includes scan summary
- Links to docs/security-remediation.md
- Clear pass/fail status

**Estimated effort:** 2-3 hours" \
    "Security Baseline" \
    "enhancement,milestone-3,security,ci-cd"

# Issue #23
create_issue \
    "Document security tool installation" \
    "Add clear installation instructions for security tools

**Should Include:**
- How to install trufflehog (macOS, Linux, Windows)
- How to install git-secrets
- How to verify tools are working
- Troubleshooting common issues

**Acceptance Criteria:**
- README has \"Security Tools Setup\" section
- Step-by-step install for each OS
- Verification command examples

**Estimated effort:** 1-2 hours" \
    "Security Baseline" \
    "documentation,milestone-3,security"

echo ""

# =============================================================================
# MILESTONE 4: Feature Documentation Enforcement
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Milestone 4: Feature Documentation Enforcement${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Issue #24 - DONE
create_issue \
    "Create feature documentation templates" \
    "Create feature-start.md and feature-validate.md templates

**Status:** ✅ Completed - templates exist in .devops/prompts/features/

**Files:**
- .devops/prompts/features/feature-start.md
- .devops/prompts/features/feature-validate.md" \
    "Feature Documentation Enforcement" \
    "enhancement,milestone-4,documentation" \
    "closed"

# Issue #25 - DONE
create_issue \
    "Create feature documentation check workflow" \
    "GitHub Action to enforce feature documentation on medium+ PRs

**Status:** ✅ Completed - workflow exists with 3-tier validation

**Files:**
- .github/workflows/feature-docs-check.yml" \
    "Feature Documentation Enforcement" \
    "enhancement,milestone-4,ci-cd" \
    "closed"

# Issue #26 - DONE
create_issue \
    "Implement 3-tier validation system (small/medium/large)" \
    "Tier 1 (Small <200 lines): Lenient
Tier 2 (Medium 200-1000 lines): Required sections
Tier 3 (Large >1000 lines): Comprehensive docs

**Status:** ✅ Completed - implemented in feature-docs-check.yml" \
    "Feature Documentation Enforcement" \
    "enhancement,milestone-4" \
    "closed"

# Issue #27
create_issue \
    "Create devops-feature-validate CLI helper" \
    "**Requirements (from MVP.md):**
- Simple CLI helper that checks feature PR description
- Flags missing required sections
- Can run locally before pushing

**Acceptance Criteria:**
- Create scripts/devops-feature-validate.sh
- Takes PR description file or git branch as input
- Checks for required sections (same logic as GH Action)
- Outputs validation results
- Returns exit code 0 (pass) or 1 (fail)
- Add alias to installer

**Example usage:**
\`\`\`bash
# Validate current branch PR description
devops-feature-validate

# Validate specific file
devops-feature-validate PR_DESCRIPTION.md
\`\`\`

**Files to create:**
- scripts/devops-feature-validate.sh

**Files to modify:**
- setup-devops-quick-access.sh (add alias)

**Estimated effort:** 3-4 hours" \
    "Feature Documentation Enforcement" \
    "enhancement,milestone-4"

# Issue #28
create_issue \
    "Create GitHub pull request template" \
    "Create .github/PULL_REQUEST_TEMPLATE.md with feature doc structure

**Should Include:**
- Summary section
- Motivation section
- Implementation Details section
- Testing section
- Breaking Changes section
- Links to feature templates

**Acceptance Criteria:**
- Template created at .github/PULL_REQUEST_TEMPLATE.md
- Auto-populates when creating PR
- Includes all required sections
- Helpful placeholder text

**Estimated effort:** 1 hour" \
    "Feature Documentation Enforcement" \
    "enhancement,milestone-4,documentation"

# Issue #29
create_issue \
    "Create demo PR showing compliant feature documentation" \
    "Create a sample feature PR that passes all validation checks

**Purpose:**
- Demonstrate what good feature docs look like
- Test the validation workflow
- Provide reference for contributors

**Acceptance Criteria:**
- Create feature/demo-feature-docs branch
- Make sample changes
- Write compliant PR description
- Open PR
- Verify feature-docs-check.yml passes
- Keep PR open as example (or document in README)

**Estimated effort:** 1-2 hours" \
    "Feature Documentation Enforcement" \
    "example,milestone-4,documentation"

echo ""

# =============================================================================
# MILESTONE 5: Developer UX (Publish & Onboard)
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Milestone 5: Developer UX (Publish & Onboard)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Issue #30 - DONE
create_issue \
    "Create comprehensive README with quickstart" \
    "README with quick start, troubleshooting, and command reference

**Status:** ✅ Completed - README.md exists with comprehensive content" \
    "Developer UX" \
    "documentation,milestone-5" \
    "closed"

# Issue #31 - DONE
create_issue \
    "Create DEVOPS-CHEATSHEET.txt for quick reference" \
    "Quick reference cheatsheet

**Status:** ✅ Completed - DEVOPS-CHEATSHEET.txt exists" \
    "Developer UX" \
    "documentation,milestone-5" \
    "closed"

# Issue #32 - DONE
create_issue \
    "Add troubleshooting section to README" \
    "Comprehensive troubleshooting guide

**Status:** ✅ Completed - README includes troubleshooting" \
    "Developer UX" \
    "documentation,milestone-5" \
    "closed"

# Issue #33
create_issue \
    "Create CHANGELOG.md for v0.1.0 release" \
    "**Requirements (from MVP.md):**
- v0.1.0 release notes listing included commands and workflows

**Should Include:**
- All features in v0.1.0
- Commands available (devops, devops-quick, etc.)
- GitHub Actions workflows included
- Installation improvements
- Known limitations

**Example format:** See docs/MILESTONE-FIX-GUIDE.md Issue #33

**Estimated effort:** 1-2 hours" \
    "Developer UX" \
    "documentation,milestone-5,priority:high"

# Issue #34
create_issue \
    "🔴 CRITICAL: Tag v0.1.0 release with release notes" \
    "**Requirements (from MVP.md):**
- Tag v0.1.0 release
- Release notes listing included commands and workflows

**Prerequisites:**
- CHANGELOG.md created (#33)
- All critical MVP issues completed
- Installation tested by external contributor (#36)

**Steps:**
1. Create CHANGELOG.md
2. Update version in relevant files
3. Create annotated git tag: \`git tag -a v0.1.0 -m \"Release v0.1.0: MVP Complete\"\`
4. Push tag: \`git push origin v0.1.0\`
5. Create GitHub release from tag
6. Add release notes (from CHANGELOG)

**Acceptance Criteria:**
- Git tag v0.1.0 exists
- GitHub release published at https://github.com/Fused-Gaming/DevOps/releases/tag/v0.1.0
- Release notes include all MVP features
- README badges show v0.1.0

**Estimated effort:** 1 hour (after dependencies complete)
**Priority:** CRITICAL - Required for MVP" \
    "Developer UX" \
    "release,milestone-5,priority:critical"

# Issue #35
create_issue \
    "Create installation demonstration (GIF or video)" \
    "**Requirements (from MVP.md):**
- Short video or GIF demonstrating install + run

**Should Show:**
- Running setup-devops-quick-access.sh
- Installation progress
- Running devops-quick command
- Output and results

**Tools:**
- Use asciinema for terminal recording
- Or create GIF with LICEcap/Kap
- Upload to GitHub assets or docs/assets/

**Acceptance Criteria:**
- Demo created (GIF or video)
- Added to README
- Shows successful installation
- Under 2 minutes

**Estimated effort:** 2-3 hours
**Priority:** Nice-to-have (can defer post-MVP)" \
    "Developer UX" \
    "documentation,milestone-5,nice-to-have"

# Issue #36
create_issue \
    "Test installation with external/fresh contributor" \
    "**Requirements (from MVP.md):**
- Contributor who follows README reports all core commands functional

**Test Plan:**
1. Find fresh contributor (or create clean environment)
2. Have them follow README installation steps
3. Verify all commands work
4. Collect feedback on unclear instructions
5. Fix any issues discovered
6. Update README based on feedback

**Acceptance Criteria:**
- At least 1 external person successfully installs
- All 5 commands work for them
- Installation completes without manual edits
- Feedback incorporated into README

**Estimated effort:** 2-3 hours
**Priority:** HIGH - Critical for MVP validation" \
    "Developer UX" \
    "testing,milestone-5,priority:high"

# Issue #37
create_issue \
    "Publish v0.1.0 GitHub release" \
    "Create official GitHub release for v0.1.0

**Prerequisites:**
- Tag v0.1.0 created (#34)
- CHANGELOG.md complete (#33)

**Release Notes Should Include:**
- Summary of MVP features
- Installation instructions
- List of included commands
- List of GitHub Actions workflows
- Known limitations
- Link to full CHANGELOG

**Acceptance Criteria:**
- Release published at GitHub
- Includes all MVP deliverables
- Assets attached (if any)
- Announcement ready

**Estimated effort:** 30 minutes" \
    "Developer UX" \
    "release,milestone-5"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Issue Creation Complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}Created: ${CREATED} issues${NC}"
if [ $SKIPPED -gt 0 ]; then
    echo -e "${YELLOW}Skipped: ${SKIPPED} issues (possibly already exist)${NC}"
fi
echo ""
echo "View all issues: https://github.com/${REPO}/issues"
echo "View milestones: https://github.com/${REPO}/milestones"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Review created issues at GitHub"
echo "2. Close any old placeholder issues (the ones showing 0%)"
echo "3. Start working on priority:critical issues"
echo "4. Watch milestones update with accurate progress!"
echo ""
