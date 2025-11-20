#!/bin/bash

# Automated GitHub Actions Permissions Setup
# This script helps configure PAT-based permissions for auto-PR creation

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 GitHub Actions Auto-PR Permissions Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed"
    echo ""
    echo "Please install it first:"
    echo "  - macOS: brew install gh"
    echo "  - Ubuntu: sudo apt install gh"
    echo "  - Windows: winget install GitHub.cli"
    echo ""
    echo "Or visit: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI"
    echo ""
    echo "Please run: gh auth login"
    echo ""
    exit 1
fi

echo "✅ GitHub CLI is installed and authenticated"
echo ""

# Get repository info
REPO_OWNER="Fused-Gaming"
REPO_NAME="DevOps"
REPO_FULL="$REPO_OWNER/$REPO_NAME"

echo "Repository: $REPO_FULL"
echo ""

# Check current permissions setting
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Step 1: Checking Current Workflow Permissions"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Try to get current workflow permission settings
echo "Current workflow permissions:"
gh api "repos/$REPO_FULL/actions/permissions/workflow" --jq '.default_workflow_permissions, .can_approve_pull_request_reviews' || true
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔑 Step 2: Personal Access Token (PAT) Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Since the workflow permissions checkbox isn't available, we'll use a PAT."
echo ""
echo "Option A: Create PAT via GitHub CLI (Recommended)"
echo "=================================================="
echo ""
echo "Run this command to create a PAT with correct scopes:"
echo ""
echo "  gh auth token"
echo ""
echo "This will output your current token. If you need a new one:"
echo ""
echo "  gh auth login --scopes repo,workflow"
echo ""
echo ""
echo "Option B: Create PAT via Web UI"
echo "================================"
echo ""
echo "1. Go to: https://github.com/settings/tokens/new"
echo "2. Token name: AUTO_PR_TOKEN"
echo "3. Expiration: 90 days (or your preference)"
echo "4. Select scopes:"
echo "   ☑ repo (Full control of private repositories)"
echo "   ☑ workflow (Update GitHub Action workflows)"
echo "5. Click 'Generate token'"
echo "6. Copy the token (starts with 'ghp_')"
echo ""
echo ""
read -p "Have you created/copied your PAT? (y/n): " PAT_READY

if [[ "$PAT_READY" != "y" ]]; then
    echo ""
    echo "⏸  Please create a PAT first, then run this script again"
    exit 0
fi

echo ""
read -sp "Paste your Personal Access Token: " PAT_TOKEN
echo ""
echo ""

if [[ -z "$PAT_TOKEN" ]]; then
    echo "❌ No token provided"
    exit 1
fi

# Validate token format
if [[ ! "$PAT_TOKEN" =~ ^(ghp_|github_pat_) ]]; then
    echo "⚠️  Warning: Token doesn't match expected format (should start with 'ghp_' or 'github_pat_')"
    read -p "Continue anyway? (y/n): " CONTINUE
    if [[ "$CONTINUE" != "y" ]]; then
        exit 1
    fi
fi

echo "✅ Token received"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💾 Step 3: Adding Secret to Repository"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Add secret to repository
echo "Adding AUTO_PR_TOKEN secret to $REPO_FULL..."
echo "$PAT_TOKEN" | gh secret set AUTO_PR_TOKEN --repo "$REPO_FULL"

if [ $? -eq 0 ]; then
    echo "✅ Secret added successfully!"
else
    echo "❌ Failed to add secret"
    echo ""
    echo "Manual steps:"
    echo "1. Go to: https://github.com/$REPO_FULL/settings/secrets/actions"
    echo "2. Click 'New repository secret'"
    echo "3. Name: AUTO_PR_TOKEN"
    echo "4. Value: [paste your token]"
    echo "5. Click 'Add secret'"
    exit 1
fi

echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Step 4: Updating Workflow Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check which workflows need updating
WORKFLOWS_TO_UPDATE=(
    ".github/workflows/auto-pr-merge.yml"
    ".github/workflows/auto-pr-description.yml"
)

echo "Workflows that will use AUTO_PR_TOKEN:"
for workflow in "${WORKFLOWS_TO_UPDATE[@]}"; do
    if [ -f "$workflow" ]; then
        echo "  - $workflow"
    fi
done
echo ""

cat << 'EOF' > /tmp/workflow-env-addition.txt

# Add this to your workflow files that create PRs:

env:
  GH_TOKEN: ${{ secrets.AUTO_PR_TOKEN }}

# Or update existing gh commands to use the token:

- name: Create PR
  env:
    GH_TOKEN: ${{ secrets.AUTO_PR_TOKEN }}
  run: |
    gh pr create --title "..." --body "..."
EOF

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ AUTO_PR_TOKEN secret has been added to your repository"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. The workflows in the restored branch already use GITHUB_TOKEN"
echo "2. If you continue having permission issues, update them to use AUTO_PR_TOKEN"
echo "3. Test by pushing to a feature branch"
echo ""
echo "📖 Full guide: .github/workflows/AUTO-PR-SETUP.md"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verify secret was added
echo "🔍 Verifying secret..."
if gh secret list --repo "$REPO_FULL" | grep -q "AUTO_PR_TOKEN"; then
    echo "✅ Verified: AUTO_PR_TOKEN is present in repository secrets"
else
    echo "⚠️  Could not verify secret (but it may still be added)"
fi

echo ""
echo "🎉 You're all set! Push to a feature branch to test auto-PR creation."
echo ""
