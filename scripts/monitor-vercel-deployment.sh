#!/bin/bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Vercel Deployment Monitor for design.vln.gg
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# This script monitors Vercel deployments and creates GitHub issues on failure
#
# Usage: ./monitor-vercel-deployment.sh [project-name]
#
# Environment Variables Required:
#   - VERCEL_TOKEN: Vercel API token
#   - GITHUB_TOKEN: GitHub token for creating issues
#   - GITHUB_REPOSITORY: Repository in format owner/repo
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PROJECT_NAME="${1:-design-standards}"
DOMAIN="design.vln.gg"
VERCEL_API="https://api.vercel.com"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

log_info() {
    echo -e "${BLUE}ℹ ${NC}$1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Validate Environment
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [ -z "${VERCEL_TOKEN:-}" ]; then
    log_error "VERCEL_TOKEN environment variable is not set"
    exit 1
fi

if [ -z "${GITHUB_TOKEN:-}" ]; then
    log_error "GITHUB_TOKEN environment variable is not set"
    exit 1
fi

if [ -z "${GITHUB_REPOSITORY:-}" ]; then
    log_error "GITHUB_REPOSITORY environment variable is not set"
    exit 1
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Get Latest Deployment
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

log_info "Fetching latest deployment for ${PROJECT_NAME}..."

DEPLOYMENT_DATA=$(curl -s \
    -H "Authorization: Bearer ${VERCEL_TOKEN}" \
    "${VERCEL_API}/v6/deployments?projectId=${PROJECT_NAME}&limit=1" || echo "{}")

if [ -z "$DEPLOYMENT_DATA" ] || [ "$DEPLOYMENT_DATA" = "{}" ]; then
    log_error "Failed to fetch deployment data from Vercel API"
    exit 1
fi

# Parse deployment info using grep and sed (more portable than jq)
DEPLOYMENT_ID=$(echo "$DEPLOYMENT_DATA" | grep -o '"uid":"[^"]*"' | head -1 | sed 's/"uid":"\([^"]*\)"/\1/')
DEPLOYMENT_STATE=$(echo "$DEPLOYMENT_DATA" | grep -o '"state":"[^"]*"' | head -1 | sed 's/"state":"\([^"]*\)"/\1/')
DEPLOYMENT_URL=$(echo "$DEPLOYMENT_DATA" | grep -o '"url":"[^"]*"' | head -1 | sed 's/"url":"\([^"]*\)"/\1/')

if [ -z "$DEPLOYMENT_ID" ]; then
    log_warning "No deployments found for project ${PROJECT_NAME}"
    log_info "This might be expected if no deployments have been made yet."
    exit 0
fi

log_info "Deployment ID: ${DEPLOYMENT_ID}"
log_info "Deployment State: ${DEPLOYMENT_STATE}"
log_info "Deployment URL: ${DEPLOYMENT_URL}"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Check Deployment Status
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [ "$DEPLOYMENT_STATE" = "READY" ]; then
    log_success "Deployment is successful! ✨"
    log_info "Live at: https://${DEPLOYMENT_URL}"
    exit 0
fi

if [ "$DEPLOYMENT_STATE" = "BUILDING" ] || [ "$DEPLOYMENT_STATE" = "QUEUED" ]; then
    log_info "Deployment is in progress (${DEPLOYMENT_STATE})"
    exit 0
fi

# Deployment has failed
log_error "Deployment has FAILED! State: ${DEPLOYMENT_STATE}"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Fetch Build Logs
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

log_info "Fetching build logs..."

BUILD_LOGS=$(curl -s \
    -H "Authorization: Bearer ${VERCEL_TOKEN}" \
    "${VERCEL_API}/v1/deployments/${DEPLOYMENT_ID}/events" || echo "Failed to fetch logs")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Analyze Error and Generate Solutions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ERROR_SUMMARY=""
POSSIBLE_SOLUTIONS=""
ERROR_DETAILS=""

# Extract error messages from logs
if echo "$BUILD_LOGS" | grep -q "framework"; then
    ERROR_SUMMARY="Invalid framework configuration in vercel.json"
    ERROR_DETAILS=$(echo "$BUILD_LOGS" | grep -A 5 "framework" || echo "Framework validation error")
    POSSIBLE_SOLUTIONS="## Possible Solutions

1. **Check vercel.json framework value**
   - Open \`vercel.json\` in your project
   - Verify the \`framework\` field matches one of the allowed values
   - For Docusaurus v2, use: \`\"framework\": \"docusaurus-2\"\`
   - For Docusaurus v3, use: \`\"framework\": \"docusaurus-2\"\` or \`\"docusaurus\"\`

2. **Valid framework values:**
   - \`blitzjs\`, \`nextjs\`, \`gatsby\`, \`remix\`, \`react-router\`
   - \`astro\`, \`hexo\`, \`eleventy\`
   - \`docusaurus-2\`, \`docusaurus\`
   - \`preact\`, \`solidstart-1\`, \`solidstart\`
   - See [Vercel Framework Documentation](https://vercel.com/docs/concepts/projects/project-configuration#framework)

3. **Remove framework field if auto-detection works**
   - Vercel can often auto-detect frameworks
   - Try removing the \`framework\` field entirely

4. **Validate JSON syntax**
   - Ensure \`vercel.json\` is valid JSON
   - Check for missing commas or quotes
   - Use a JSON validator: https://jsonlint.com/"

elif echo "$BUILD_LOGS" | grep -qi "npm.*error\|yarn.*error"; then
    ERROR_SUMMARY="Dependency installation failed"
    ERROR_DETAILS=$(echo "$BUILD_LOGS" | grep -i "error" | head -20)
    POSSIBLE_SOLUTIONS="## Possible Solutions

1. **Update package-lock.json or yarn.lock**
   - Run \`npm install\` or \`yarn install\` locally
   - Commit the updated lock file

2. **Check Node.js version**
   - Verify \`engines.node\` in package.json matches Vercel's Node version
   - Update \`vercel.json\` to specify Node version if needed

3. **Clear cache and retry**
   - In Vercel dashboard, trigger a rebuild
   - Or add \`FORCE_CLEAR=true\` environment variable

4. **Check for private packages**
   - Ensure all dependencies are accessible
   - Add NPM_TOKEN if using private packages"

elif echo "$BUILD_LOGS" | grep -qi "build.*failed\|build.*error"; then
    ERROR_SUMMARY="Build process failed"
    ERROR_DETAILS=$(echo "$BUILD_LOGS" | grep -i "error" | head -20)
    POSSIBLE_SOLUTIONS="## Possible Solutions

1. **Run build locally first**
   - Execute \`npm run build\` in your local environment
   - Fix any errors that appear
   - Ensure build completes successfully before deploying

2. **Check build command**
   - Verify \`buildCommand\` in vercel.json is correct
   - For Docusaurus: \`\"buildCommand\": \"npm run build\"\`

3. **Review output directory**
   - Verify \`outputDirectory\` in vercel.json
   - For Docusaurus: \`\"outputDirectory\": \"build\"\`

4. **Check environment variables**
   - Ensure all required env vars are set in Vercel dashboard
   - Add missing variables under Settings → Environment Variables

5. **Review recent changes**
   - Check git history for breaking changes
   - Revert recent commits if needed"

elif echo "$BUILD_LOGS" | grep -qi "timeout"; then
    ERROR_SUMMARY="Build timeout exceeded"
    ERROR_DETAILS=$(echo "$BUILD_LOGS" | grep -i "timeout" | head -10)
    POSSIBLE_SOLUTIONS="## Possible Solutions

1. **Optimize build process**
   - Remove unnecessary dependencies
   - Use \`npm ci\` instead of \`npm install\`
   - Enable caching in Vercel

2. **Upgrade Vercel plan**
   - Free tier has shorter timeout limits
   - Pro plans have extended build times

3. **Reduce bundle size**
   - Use code splitting
   - Remove unused imports
   - Optimize assets"

else
    ERROR_SUMMARY="Deployment failed with unknown error"
    ERROR_DETAILS=$(echo "$BUILD_LOGS" | grep -i "error" | head -20 || echo "No specific error found in logs")
    POSSIBLE_SOLUTIONS="## Possible Solutions

1. **Check Vercel dashboard**
   - Visit https://vercel.com/dashboard
   - Review deployment logs for detailed errors

2. **Run build locally**
   - Execute \`npm run build\` to identify issues
   - Test the production build: \`npm run serve\`

3. **Verify configuration files**
   - Check \`vercel.json\` for syntax errors
   - Validate \`package.json\` scripts
   - Review framework-specific config files

4. **Contact Vercel support**
   - If error persists, reach out to Vercel support
   - Provide deployment ID: ${DEPLOYMENT_ID}"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Create GitHub Issue
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

log_info "Creating GitHub issue..."

TIMESTAMP=$(date -u '+%Y-%m-%d %H:%M:%S UTC')
VERCEL_DASHBOARD_URL="https://vercel.com/${GITHUB_REPOSITORY}/deployments/${DEPLOYMENT_ID}"

# Escape quotes and format logs for JSON
ESCAPED_ERROR_DETAILS=$(echo "$ERROR_DETAILS" | head -50 | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
ESCAPED_BUILD_LOGS=$(echo "$BUILD_LOGS" | head -100 | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

ISSUE_TITLE="🚨 Vercel Deployment Failed: ${DOMAIN}"

ISSUE_BODY="# Vercel Deployment Failure Report

## Summary
**Domain:** ${DOMAIN}
**Project:** ${PROJECT_NAME}
**Deployment State:** ${DEPLOYMENT_STATE}
**Deployment ID:** \`${DEPLOYMENT_ID}\`
**Timestamp:** ${TIMESTAMP}

## Error
\`\`\`
${ERROR_SUMMARY}
\`\`\`

## Error Details
\`\`\`
${ERROR_DETAILS}
\`\`\`

${POSSIBLE_SOLUTIONS}

## Links
- 🔗 [View Deployment on Vercel](${VERCEL_DASHBOARD_URL})
- 📦 [Project Settings](https://vercel.com/${GITHUB_REPOSITORY})
- 📊 [All Deployments](https://vercel.com/${GITHUB_REPOSITORY}/deployments)

## Build Logs Sample
<details>
<summary>Click to expand build logs</summary>

\`\`\`
${BUILD_LOGS}
\`\`\`
</details>

---
*This issue was automatically created by the Vercel deployment monitor*
*Report generated at: ${TIMESTAMP}*"

# Create the issue using GitHub API
RESPONSE=$(curl -s -w "\n%{http_code}" \
    -X POST \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues" \
    -d "{
        \"title\": \"${ISSUE_TITLE}\",
        \"body\": $(echo "$ISSUE_BODY" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'),
        \"labels\": [\"deployment\", \"bug\", \"vercel\", \"automated\"]
    }")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_CODE" = "201" ]; then
    ISSUE_URL=$(echo "$RESPONSE_BODY" | grep -o '"html_url":"[^"]*"' | head -1 | sed 's/"html_url":"\([^"]*\)"/\1/')
    log_success "GitHub issue created successfully!"
    log_info "Issue URL: ${ISSUE_URL}"

    # Output for GitHub Actions
    if [ -n "${GITHUB_OUTPUT:-}" ]; then
        echo "issue_url=${ISSUE_URL}" >> "$GITHUB_OUTPUT"
        echo "deployment_failed=true" >> "$GITHUB_OUTPUT"
    fi
else
    log_error "Failed to create GitHub issue (HTTP ${HTTP_CODE})"
    log_error "Response: ${RESPONSE_BODY}"
    exit 1
fi

log_info "Deployment monitoring complete"
exit 1  # Exit with error since deployment failed
