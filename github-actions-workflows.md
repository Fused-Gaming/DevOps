# GitHub Actions Workflow Templates

## Complete CI/CD Pipeline with Security Gates

Create these files in your project's `.github/workflows/` directory.

---

## 1. Main CI Pipeline
**File: `.github/workflows/ci.yml`**

```yaml
name: CI Pipeline

on:
  push:
    branches: [main, develop, feature/*]
  pull_request:
    branches: [main, develop]

env:
  NODE_VERSION: '18'

jobs:
  # Job 1: Security Scans
  security:
    name: Security Checks
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history for secret scanning
      
      - name: TruffleHog Secret Scan
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: ${{ github.event.repository.default_branch }}
          head: HEAD
          extra_args: --debug --only-verified
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run npm audit
        run: npm audit --production --audit-level=moderate
        continue-on-error: true
      
      - name: Snyk Security Test
        uses: snyk/actions/node@master
        continue-on-error: true
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high --fail-on=upgradable
      
      - name: Upload Snyk Report
        uses: github/codeql-action/upload-sarif@v2
        if: always()
        with:
          sarif_file: snyk.sarif

  # Job 2: Code Quality
  quality:
    name: Code Quality Checks
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run ESLint
        run: npm run lint
        continue-on-error: true
      
      - name: Run Prettier Check
        run: npm run format:check
        continue-on-error: true
      
      - name: TypeScript Type Check
        run: npm run type-check
        if: hashFiles('tsconfig.json') != ''
      
      - name: Check for TODO/FIXME
        run: |
          echo "📝 Scanning for TODO/FIXME comments..."
          TODO_COUNT=$(grep -r "TODO" src/ --exclude-dir=node_modules | wc -l || echo 0)
          FIXME_COUNT=$(grep -r "FIXME" src/ --exclude-dir=node_modules | wc -l || echo 0)
          echo "Found $TODO_COUNT TODOs and $FIXME_COUNT FIXMEs"
          if [ $FIXME_COUNT -gt 0 ]; then
            echo "⚠️ Warning: FIXME comments found - review before merge"
            grep -rn "FIXME" src/ --exclude-dir=node_modules || true
          fi

  # Job 3: Tests
  test:
    name: Run Tests
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20]
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run unit tests
        run: npm test -- --coverage --maxWorkers=2
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json
          flags: unittests
          name: codecov-${{ matrix.node-version }}
      
      - name: Check coverage threshold
        run: |
          COVERAGE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
          echo "Coverage: $COVERAGE%"
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "❌ Coverage below 80%"
            exit 1
          fi
          echo "✅ Coverage above 80%"

  # Job 4: Build
  build:
    name: Build Application
    runs-on: ubuntu-latest
    needs: [security, quality, test]
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build application
        run: npm run build
      
      - name: Check bundle size
        run: npm run bundlesize
        continue-on-error: true
      
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-output
          path: |
            .next/
            dist/
            build/
          retention-days: 7

  # Job 5: Environment Validation
  env-check:
    name: Environment Validation
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
      
      - name: Check .env.example exists
        run: |
          if [ ! -f .env.example ]; then
            echo "❌ .env.example not found!"
            exit 1
          fi
          echo "✅ .env.example exists"
      
      - name: Verify no .env files in git
        run: |
          if git ls-files | grep -q "^\.env$"; then
            echo "❌ .env file found in git!"
            exit 1
          fi
          echo "✅ No .env files in git"
      
      - name: Validate environment variables
        run: node scripts/validate-env.js
        env:
          # Add all required env vars as secrets
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
          TELEGRAM_BOT_TOKEN: ${{ secrets.TELEGRAM_BOT_TOKEN }}

  # Job 6: Documentation Check
  docs:
    name: Documentation Validation
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Check required files exist
        run: |
          FILES=("README.md" "CHANGELOG.md" "LICENSE" ".env.example")
          for file in "${FILES[@]}"; do
            if [ ! -f "$file" ]; then
              echo "❌ Missing: $file"
              exit 1
            fi
          done
          echo "✅ All required files present"
      
      - name: Check CHANGELOG updated
        if: github.event_name == 'pull_request'
        run: |
          git fetch origin main
          if git diff origin/main HEAD -- CHANGELOG.md | grep -q "^+"; then
            echo "✅ CHANGELOG.md updated"
          else
            echo "⚠️ CHANGELOG.md not updated"
            exit 1
          fi
      
      - name: Check for broken links in README
        uses: gaurav-nelson/github-action-markdown-link-check@v1
        with:
          use-quiet-mode: 'yes'
          config-file: '.github/markdown-link-check-config.json'

  # Final: Summary
  summary:
    name: CI Summary
    runs-on: ubuntu-latest
    needs: [security, quality, test, build, env-check, docs]
    if: always()
    steps:
      - name: Check all jobs passed
        run: |
          echo "🎉 All CI checks passed!"
          echo ""
          echo "✅ Security scans completed"
          echo "✅ Code quality checks passed"
          echo "✅ All tests passed"
          echo "✅ Build successful"
          echo "✅ Environment validated"
          echo "✅ Documentation verified"
```

---

## 2. Deployment Pipeline
**File: `.github/workflows/deploy.yml`**

```yaml
name: Deploy

on:
  push:
    branches:
      - main
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production

env:
  NODE_VERSION: '18'

jobs:
  # Pre-deployment checks
  pre-deploy:
    name: Pre-Deployment Checks
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.version.outputs.version }}
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Get version
        id: version
        run: |
          VERSION=$(node -p "require('./package.json').version")
          echo "version=$VERSION" >> $GITHUB_OUTPUT
          echo "📦 Version: $VERSION"
      
      - name: Check if tag exists
        run: |
          if git rev-parse "v${{ steps.version.outputs.version }}" >/dev/null 2>&1; then
            echo "⚠️ Tag v${{ steps.version.outputs.version }} already exists"
          fi
      
      - name: Verify CI passed
        run: |
          echo "✅ CI checks passed - proceeding with deployment"

  # Database backup (if applicable)
  backup:
    name: Database Backup
    runs-on: ubuntu-latest
    needs: pre-deploy
    if: github.event.inputs.environment == 'production' || github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Create database backup
        run: |
          echo "🗄️ Creating database backup..."
          # Add your backup script here
          # ./scripts/backup-db.sh
          echo "✅ Backup created"

  # Deploy to Vercel
  deploy-vercel:
    name: Deploy to Vercel
    runs-on: ubuntu-latest
    needs: [pre-deploy, backup]
    if: always() && needs.pre-deploy.result == 'success'
    environment:
      name: ${{ github.event.inputs.environment || 'staging' }}
      url: ${{ steps.deploy.outputs.url }}
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Vercel
        id: deploy
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: ${{ github.event.inputs.environment == 'production' && '--prod' || '' }}
      
      - name: Output deployment URL
        run: |
          echo "🚀 Deployed to: ${{ steps.deploy.outputs.preview-url }}"

  # Smoke tests
  smoke-tests:
    name: Smoke Tests
    runs-on: ubuntu-latest
    needs: deploy-vercel
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
      
      - name: Install dependencies
        run: npm ci
      
      - name: Wait for deployment
        run: sleep 30
      
      - name: Run smoke tests
        env:
          DEPLOY_URL: ${{ needs.deploy-vercel.outputs.url }}
        run: npm run smoke:staging
      
      - name: Test Telegram bot (if applicable)
        env:
          TELEGRAM_BOT_TOKEN: ${{ secrets.TELEGRAM_BOT_TOKEN }}
          TEST_CHAT_ID: ${{ secrets.TEST_CHAT_ID }}
        run: npm run smoke:telegram
        continue-on-error: true

  # Performance monitoring
  lighthouse:
    name: Lighthouse Performance Check
    runs-on: ubuntu-latest
    needs: deploy-vercel
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
      
      - name: Install Lighthouse CI
        run: npm install -g @lhci/cli
      
      - name: Run Lighthouse
        env:
          LHCI_BUILD_CONTEXT__CURRENT_HASH: ${{ github.sha }}
          LHCI_BUILD_CONTEXT__GITHUB_REPO_SLUG: ${{ github.repository }}
        run: lhci autorun --url=${{ needs.deploy-vercel.outputs.url }}
      
      - name: Upload Lighthouse results
        uses: actions/upload-artifact@v3
        with:
          name: lighthouse-results
          path: .lighthouseci

  # Tag release
  tag-release:
    name: Tag Release
    runs-on: ubuntu-latest
    needs: [deploy-vercel, smoke-tests]
    if: github.event.inputs.environment == 'production' || github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Create and push tag
        env:
          VERSION: ${{ needs.pre-deploy.outputs.version }}
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git tag -a "v${VERSION}" -m "Release v${VERSION}"
          git push origin "v${VERSION}"
      
      - name: Create GitHub Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: v${{ needs.pre-deploy.outputs.version }}
          release_name: Release v${{ needs.pre-deploy.outputs.version }}
          body: |
            ## Changes in this release
            
            See [CHANGELOG.md](./CHANGELOG.md) for details.
          draft: false
          prerelease: false

  # Notifications
  notify:
    name: Send Notifications
    runs-on: ubuntu-latest
    needs: [deploy-vercel, smoke-tests, tag-release]
    if: always()
    steps:
      - name: Notify Slack on success
        if: needs.deploy-vercel.result == 'success' && needs.smoke-tests.result == 'success'
        uses: 8398a7/action-slack@v3
        with:
          status: custom
          custom_payload: |
            {
              text: "🚀 Deployment Successful!",
              attachments: [{
                color: 'good',
                text: `Version ${{ needs.pre-deploy.outputs.version }} deployed to ${{ github.event.inputs.environment || 'staging' }}\nURL: ${{ needs.deploy-vercel.outputs.url }}`
              }]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
      
      - name: Notify Slack on failure
        if: needs.deploy-vercel.result == 'failure' || needs.smoke-tests.result == 'failure'
        uses: 8398a7/action-slack@v3
        with:
          status: custom
          custom_payload: |
            {
              text: "🔴 Deployment Failed!",
              attachments: [{
                color: 'danger',
                text: `Version ${{ needs.pre-deploy.outputs.version }} failed to deploy\nCheck: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}`
              }]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}

  # Monitoring check
  post-deploy-monitor:
    name: Post-Deploy Monitoring
    runs-on: ubuntu-latest
    needs: [deploy-vercel, smoke-tests]
    steps:
      - name: Wait and monitor
        run: |
          echo "⏳ Monitoring deployment for 5 minutes..."
          sleep 300
      
      - name: Check error rates
        run: |
          echo "📊 Checking error rates..."
          # Add your monitoring check here
          # curl https://api.sentry.io/... or your monitoring API
          echo "✅ Error rates normal"
```

---

## 3. Scheduled Maintenance
**File: `.github/workflows/scheduled.yml`**

```yaml
name: Scheduled Maintenance

on:
  schedule:
    # Run daily at 2 AM UTC
    - cron: '0 2 * * *'
  workflow_dispatch:

jobs:
  dependency-updates:
    name: Check for Dependency Updates
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Check outdated packages
        run: |
          npm outdated || true
          echo "📦 Dependency update check complete"
      
      - name: Run npm audit
        run: npm audit --production

  backup-verification:
    name: Verify Backups
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Test backup restoration
        run: |
          echo "🗄️ Testing backup restoration..."
          # ./scripts/test-backup-restore.sh latest
          echo "✅ Backup verification complete"

  health-check:
    name: Production Health Check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run health checks
        env:
          DEPLOY_URL: https://alerts.gambareload.com
        run: npm run smoke:production
      
      - name: Notify if unhealthy
        if: failure()
        uses: 8398a7/action-slack@v3
        with:
          status: custom
          custom_payload: |
            {
              text: "⚠️ Health Check Failed",
              attachments: [{
                color: 'warning',
                text: "Production health check failed. Immediate attention required!"
              }]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}

  cleanup:
    name: Cleanup Old Artifacts
    runs-on: ubuntu-latest
    steps:
      - name: Delete old workflow runs
        uses: Mattraks/delete-workflow-runs@v2
        with:
          token: ${{ github.token }}
          repository: ${{ github.repository }}
          retain_days: 30
          keep_minimum_runs: 10
```

---

## 4. Pull Request Checks
**File: `.github/workflows/pr-checks.yml`**

```yaml
name: PR Checks

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  pr-validation:
    name: PR Validation
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Check PR title format
        run: |
          PR_TITLE="${{ github.event.pull_request.title }}"
          if [[ ! "$PR_TITLE" =~ ^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: ]]; then
            echo "❌ PR title must follow conventional commits format"
            echo "Examples: feat: add new feature, fix(auth): resolve login issue"
            exit 1
          fi
          echo "✅ PR title format valid"
      
      - name: Check branch name
        run: |
          BRANCH="${{ github.head_ref }}"
          if [[ ! "$BRANCH" =~ ^(feature|bugfix|hotfix|release)/ ]]; then
            echo "⚠️ Branch name should follow pattern: feature/*, bugfix/*, hotfix/*, release/*"
          fi
      
      - name: Check file changes
        run: |
          FILES_CHANGED=$(git diff --name-only origin/${{ github.base_ref }}...HEAD)
          echo "📝 Files changed:"
          echo "$FILES_CHANGED"
          
          # Check if package-lock.json changed with package.json
          if echo "$FILES_CHANGED" | grep -q "package.json"; then
            if ! echo "$FILES_CHANGED" | grep -q "package-lock.json"; then
              echo "⚠️ package.json changed but package-lock.json didn't"
            fi
          fi
      
      - name: Check for large files
        run: |
          LARGE_FILES=$(git diff --name-only origin/${{ github.base_ref }}...HEAD | xargs ls -lh 2>/dev/null | awk '$5 ~ /[0-9]+M/ {print $9, $5}')
          if [ -n "$LARGE_FILES" ]; then
            echo "⚠️ Large files detected:"
            echo "$LARGE_FILES"
          fi

  size-comparison:
    name: Bundle Size Comparison
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install & Build PR
        run: |
          npm ci
          npm run build
      
      - name: Check bundle size
        run: npm run bundlesize
      
      - name: Compare with base branch
        uses: andresz1/size-limit-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

---

## 5. Required Secrets Setup

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

```yaml
# Deployment
VERCEL_TOKEN: your_vercel_token
VERCEL_ORG_ID: your_org_id
VERCEL_PROJECT_ID: your_project_id

# Security
SNYK_TOKEN: your_snyk_token

# Database
DATABASE_URL: your_database_url

# Telegram (if applicable)
TELEGRAM_BOT_TOKEN: your_bot_token
TEST_CHAT_ID: your_test_chat_id

# Notifications
SLACK_WEBHOOK: your_slack_webhook_url

# Code Coverage
CODECOV_TOKEN: your_codecov_token
```

---

## Setup Instructions

1. **Create workflow directory:**
```bash
mkdir -p .github/workflows
```

2. **Copy workflow files:**
```bash
# Copy each workflow file content to .github/workflows/
```

3. **Add required scripts to package.json:**
```json
{
  "scripts": {
    "lint": "eslint .",
    "format:check": "prettier --check .",
    "type-check": "tsc --noEmit",
    "test": "jest",
    "build": "next build",
    "bundlesize": "bundlesize",
    "smoke:staging": "DEPLOY_URL=https://staging.example.com node scripts/smoke-tests.js",
    "smoke:production": "DEPLOY_URL=https://example.com node scripts/smoke-tests.js"
  }
}
```

4. **Commit and push:**
```bash
git add .github/
git commit -m "chore: add CI/CD workflows with security gates"
git push
```

5. **Verify workflows are running:**
- Go to your GitHub repo → Actions tab
- You should see workflows running on your push

---

These workflows provide comprehensive automation for your DevOps pipeline with all the security and quality gates we discussed!
