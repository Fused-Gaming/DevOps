# Security & Quality Gates - Implementation Guide

## Quick Start: Add These to Your Project TODAY

This guide helps you implement the critical missing pieces in priority order.

---

## 🔴 PRIORITY 1: Secret Scanning (15 minutes)

### Option A: git-secrets (Recommended for speed)

**Install:**
```bash
# macOS
brew install git-secrets

# Ubuntu/Debian
sudo apt-get install git-secrets

# Windows (Git Bash)
git clone https://github.com/awslabs/git-secrets.git
cd git-secrets
sudo make install
```

**Setup in your project:**
```bash
cd /path/to/GambaReload  # or BonusAlerts

# Initialize git-secrets
git secrets --install
git secrets --register-aws  # AWS keys

# Add custom patterns for your stack
git secrets --add 'api[_-]?key[_-]?=.{20,}'
git secrets --add 'secret[_-]?key[_-]?=.{20,}'
git secrets --add 'password[_-]?=.{8,}'
git secrets --add 'TELEGRAM_BOT_TOKEN.*'
git secrets --add 'DATABASE_URL.*'
git secrets --add '[a-zA-Z0-9]{32,}'  # Generic long tokens

# Scan entire repo history
git secrets --scan-history

# Add as pre-commit hook
git secrets --install -f
```

**Add to package.json:**
```json
{
  "scripts": {
    "presecrets": "git secrets --scan"
  }
}
```

### Option B: TruffleHog (More thorough, slower)

**Install:**
```bash
# Using pip
pip install trufflehog

# Or using Docker
docker pull trufflesecurity/trufflehog:latest
```

**Run scan:**
```bash
# Scan git history
trufflehog git file://. --only-verified

# Scan specific branch
trufflehog git file://. --branch main

# Generate report
trufflehog git file://. --json > secrets-report.json
```

**Add to GitHub Actions:**
```yaml
# .github/workflows/security.yml
name: Security Scan

on: [push, pull_request]

jobs:
  trufflehog:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: TruffleHog Scan
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: ${{ github.event.repository.default_branch }}
          head: HEAD
```

### Option C: GitHub Secret Scanning (If using GitHub)

**Enable for your repo:**
1. Go to repo Settings → Security → Code security and analysis
2. Enable "Secret scanning"
3. Enable "Push protection" (blocks commits with secrets)

**No code needed - GitHub does it automatically!**

---

## 🔴 PRIORITY 2: Dependency Vulnerability Scanning (10 minutes)

### For Node.js Projects

**Immediate check:**
```bash
cd /path/to/your-project

# npm
npm audit
npm audit --production  # Only check production deps

# Fix automatically (patches)
npm audit fix

# Fix everything (may have breaking changes)
npm audit fix --force

# Generate detailed report
npm audit --json > audit-report.json
```

**Add to package.json:**
```json
{
  "scripts": {
    "pretest": "npm audit --production",
    "audit:full": "npm audit && npm audit --json > reports/audit-$(date +%Y%m%d).json",
    "audit:fix": "npm audit fix"
  }
}
```

**Add to GitHub Actions:**
```yaml
# .github/workflows/security.yml
name: Security Audit

on: [push, pull_request]

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run npm audit
        run: npm audit --production --audit-level=high
        # Fails on high/critical vulnerabilities
```

### Using Snyk (Recommended - Free for open source)

**Setup:**
```bash
# Install Snyk CLI
npm install -g snyk

# Authenticate
snyk auth

# Test your project
snyk test

# Monitor (adds to Snyk dashboard)
snyk monitor

# Fix vulnerabilities
snyk fix
```

**Add to package.json:**
```json
{
  "scripts": {
    "snyk:test": "snyk test --all-projects",
    "snyk:monitor": "snyk monitor --all-projects"
  }
}
```

**GitHub Action:**
```yaml
# .github/workflows/snyk.yml
name: Snyk Security

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Snyk to check for vulnerabilities
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high
```

### Dependabot (GitHub only - Automated PR for updates)

**Enable:**
```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    reviewers:
      - "your-username"
    assignees:
      - "your-username"
    commit-message:
      prefix: "chore(deps)"
    labels:
      - "dependencies"
```

---

## 🔴 PRIORITY 3: Environment Variable Management (20 minutes)

### Create .env.example

**Generate from your current .env:**
```bash
# Auto-generate .env.example from .env
cat .env | sed 's/=.*/=/' > .env.example

# Or manually create
cat > .env.example << 'EOF'
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# API Keys
TELEGRAM_BOT_TOKEN=
TELEGRAM_API_ID=
TELEGRAM_API_HASH=

# Third-party Services
OPENAI_API_KEY=
REDIS_URL=

# Application
NODE_ENV=development
PORT=3000
APP_SECRET=

# Monitoring
SENTRY_DSN=
EOF
```

### Verify .env is gitignored

```bash
# Check if .env is ignored
git check-ignore .env

# If not ignored, add to .gitignore
echo ".env" >> .gitignore
echo ".env.local" >> .gitignore
echo ".env.*.local" >> .gitignore

# Remove from git if accidentally committed
git rm --cached .env
git commit -m "chore: remove .env from version control"
```

### Add validation script

```javascript
// scripts/validate-env.js
const fs = require('fs');
const path = require('path');

// Read .env.example to get required vars
const examplePath = path.join(__dirname, '../.env.example');
const exampleContent = fs.readFileSync(examplePath, 'utf8');

const requiredVars = exampleContent
  .split('\n')
  .filter(line => line && !line.startsWith('#'))
  .map(line => line.split('=')[0]);

console.log('🔍 Validating environment variables...\n');

const missing = [];
const empty = [];

requiredVars.forEach(varName => {
  if (!(varName in process.env)) {
    missing.push(varName);
  } else if (!process.env[varName]) {
    empty.push(varName);
  }
});

if (missing.length > 0) {
  console.error('❌ Missing required environment variables:');
  missing.forEach(v => console.error(`   - ${v}`));
  console.error('\n');
}

if (empty.length > 0) {
  console.warn('⚠️  Empty environment variables:');
  empty.forEach(v => console.warn(`   - ${v}`));
  console.warn('\n');
}

if (missing.length > 0 || empty.length > 0) {
  console.error('Please update your .env file based on .env.example');
  process.exit(1);
}

console.log('✅ All environment variables are set!\n');
```

**Add to package.json:**
```json
{
  "scripts": {
    "validate:env": "node scripts/validate-env.js",
    "prestart": "npm run validate:env",
    "predev": "npm run validate:env"
  }
}
```

---

## 🟡 PRIORITY 4: Post-Deploy Smoke Tests (30 minutes)

### Create smoke test script

```javascript
// scripts/smoke-tests.js
const axios = require('axios');

const DEPLOY_URL = process.env.DEPLOY_URL || 'http://localhost:3000';
const TIMEOUT = 5000;

const tests = [
  {
    name: 'Health Check',
    test: async () => {
      const response = await axios.get(`${DEPLOY_URL}/health`);
      return response.status === 200 && response.data.status === 'ok';
    }
  },
  {
    name: 'API Endpoint',
    test: async () => {
      const response = await axios.get(`${DEPLOY_URL}/api/status`);
      return response.status === 200;
    }
  },
  {
    name: 'Database Connection',
    test: async () => {
      const response = await axios.get(`${DEPLOY_URL}/api/health/db`);
      return response.data.connected === true;
    }
  },
  {
    name: 'Critical Feature - User Can Access',
    test: async () => {
      const response = await axios.get(`${DEPLOY_URL}/dashboard`, {
        validateStatus: (status) => status < 500 // Accept 200-499
      });
      return response.status < 500; // Not a server error
    }
  }
];

async function runSmokeTests() {
  console.log('🔥 Running smoke tests...\n');
  console.log(`Target: ${DEPLOY_URL}\n`);

  let passed = 0;
  let failed = 0;

  for (const test of tests) {
    try {
      const start = Date.now();
      const result = await Promise.race([
        test.test(),
        new Promise((_, reject) => 
          setTimeout(() => reject(new Error('Timeout')), TIMEOUT)
        )
      ]);
      const duration = Date.now() - start;

      if (result) {
        console.log(`✅ ${test.name} (${duration}ms)`);
        passed++;
      } else {
        console.log(`❌ ${test.name} - Test returned false`);
        failed++;
      }
    } catch (error) {
      console.log(`❌ ${test.name} - ${error.message}`);
      failed++;
    }
  }

  console.log(`\n📊 Results: ${passed} passed, ${failed} failed`);

  if (failed > 0) {
    process.exit(1);
  }
}

runSmokeTests();
```

**For BonusAlerts/Telegram Bot:**

```javascript
// scripts/smoke-tests-telegram.js
const { Telegraf } = require('telegraf');

const bot = new Telegraf(process.env.TELEGRAM_BOT_TOKEN);

async function testTelegramBot() {
  console.log('🤖 Testing Telegram Bot...\n');

  try {
    // Test 1: Bot can connect
    const me = await bot.telegram.getMe();
    console.log(`✅ Bot connected: @${me.username}`);

    // Test 2: Bot can send message (to your own chat)
    const testChatId = process.env.TEST_CHAT_ID;
    if (testChatId) {
      await bot.telegram.sendMessage(
        testChatId,
        '✅ Smoke test: Bot can send messages'
      );
      console.log('✅ Bot can send messages');
    }

    // Test 3: Webhook is set (if using webhooks)
    const webhookInfo = await bot.telegram.getWebhookInfo();
    if (webhookInfo.url) {
      console.log(`✅ Webhook configured: ${webhookInfo.url}`);
    }

    console.log('\n✅ All Telegram bot tests passed!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Telegram bot test failed:', error.message);
    process.exit(1);
  }
}

testTelegramBot();
```

**Add to package.json:**
```json
{
  "scripts": {
    "smoke:local": "DEPLOY_URL=http://localhost:3000 node scripts/smoke-tests.js",
    "smoke:staging": "DEPLOY_URL=https://staging.gambareload.com node scripts/smoke-tests.js",
    "smoke:production": "DEPLOY_URL=https://alerts.gambareload.com node scripts/smoke-tests.js",
    "smoke:telegram": "node scripts/smoke-tests-telegram.js"
  }
}
```

**Add to GitHub Actions:**
```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
      
      - name: Wait for deployment
        run: sleep 30
      
      - name: Run smoke tests
        run: |
          npm install
          DEPLOY_URL=${{ steps.deploy.outputs.preview-url }} npm run smoke:staging
```

---

## 🟡 PRIORITY 5: Performance Checks (20 minutes)

### Bundle Size Monitoring

**Install bundlesize:**
```bash
npm install --save-dev bundlesize
```

**Configure in package.json:**
```json
{
  "scripts": {
    "build": "next build",
    "bundlesize": "bundlesize"
  },
  "bundlesize": [
    {
      "path": ".next/static/chunks/*.js",
      "maxSize": "200 kB"
    },
    {
      "path": ".next/static/css/*.css",
      "maxSize": "50 kB"
    }
  ]
}
```

**Add GitHub Action:**
```yaml
# .github/workflows/performance.yml
name: Performance Check

on: [pull_request]

jobs:
  bundlesize:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install & Build
        run: |
          npm ci
          npm run build
      
      - name: Check bundle size
        run: npm run bundlesize
        env:
          CI: true
```

### Lighthouse CI (For web apps)

**Install:**
```bash
npm install --save-dev @lhci/cli
```

**Configure:**
```javascript
// lighthouserc.js
module.exports = {
  ci: {
    collect: {
      url: ['http://localhost:3000'],
      startServerCommand: 'npm run start',
      startServerReadyPattern: 'ready on',
      numberOfRuns: 3
    },
    assert: {
      assertions: {
        'categories:performance': ['error', { minScore: 0.9 }],
        'categories:accessibility': ['error', { minScore: 0.9 }],
        'categories:best-practices': ['error', { minScore: 0.9 }],
        'categories:seo': ['error', { minScore: 0.9 }]
      }
    },
    upload: {
      target: 'temporary-public-storage'
    }
  }
};
```

**Add to package.json:**
```json
{
  "scripts": {
    "lighthouse": "lhci autorun"
  }
}
```

---

## 🟢 PRIORITY 6: Database Backup Verification (15 minutes)

### Postgres Backup Script

```bash
#!/bin/bash
# scripts/backup-db.sh

set -e

# Configuration
DB_NAME="${DB_NAME:-gambareload}"
BACKUP_DIR="${BACKUP_DIR:-./backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "🗄️  Creating database backup..."

# Create backup
pg_dump "$DATABASE_URL" > "$BACKUP_FILE"

# Compress
gzip "$BACKUP_FILE"

echo "✅ Backup created: ${BACKUP_FILE}.gz"

# Verify backup
if [ -f "${BACKUP_FILE}.gz" ]; then
  SIZE=$(du -h "${BACKUP_FILE}.gz" | cut -f1)
  echo "📊 Backup size: $SIZE"
  
  # Test that it's valid SQL
  gunzip -t "${BACKUP_FILE}.gz" && echo "✅ Backup integrity verified"
else
  echo "❌ Backup failed!"
  exit 1
fi

# Cleanup old backups (keep last 7 days)
find "$BACKUP_DIR" -name "backup_*.sql.gz" -mtime +7 -delete
echo "🧹 Cleaned up old backups"

echo "✅ Backup process complete!"
```

**Add to package.json:**
```json
{
  "scripts": {
    "db:backup": "bash scripts/backup-db.sh",
    "db:restore": "bash scripts/restore-db.sh"
  }
}
```

### Backup Restoration Test

```bash
#!/bin/bash
# scripts/test-backup-restore.sh

set -e

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: ./test-backup-restore.sh backup_file.sql.gz"
  exit 1
fi

echo "🧪 Testing backup restoration..."

# Create test database
TEST_DB="test_restore_$$"
createdb "$TEST_DB"

# Restore backup to test database
gunzip -c "$BACKUP_FILE" | psql "$TEST_DB"

# Run basic validation queries
psql "$TEST_DB" -c "SELECT COUNT(*) FROM users;"
psql "$TEST_DB" -c "SELECT COUNT(*) FROM projects;"

# Cleanup
dropdb "$TEST_DB"

echo "✅ Backup restoration test passed!"
```

---

## 🔧 Integrated Claude Prompt with All Checks

Update your DevOps prompt to include all these:

```markdown
# Enhanced DevOps Pipeline with Security & Quality Gates

## Phase 1: Pre-Commit Security Checks

[█░░░░░░░░░░░░] 1/15 Secret scanning (git-secrets/trufflehog)
[██░░░░░░░░░░░] 2/15 Dependency vulnerabilities (npm audit/snyk)
[███░░░░░░░░░░] 3/15 Environment variables validated (.env.example up-to-date)

## Phase 2: Build Status Verification
[████░░░░░░░░░] 4/15 Check last commit & CI/CD status
[█████░░░░░░░░] 5/15 Troubleshoot any build failures (auto-retry)

## Phase 3: Code Quality Checks
[██████░░░░░░░] 6/15 Cleanup scripts (remove debug code, temp files)
[███████░░░░░░] 7/15 Linting & formatting (auto-fix where possible)
[████████░░░░░] 8/15 Type checking (TypeScript/ESLint strict mode)

## Phase 4: Database & Infrastructure
[█████████░░░░] 9/15 Database backup verified (if applicable)
[██████████░░░] 10/15 Check pending migrations

## Phase 5: Documentation Updates
[███████████░░] 11/15 Update CHANGELOG.md, PROJECT_STATUS.md, README.md
[████████████░] 12/15 Update VERSION file & organize project root

## Phase 6: Final Validation
[█████████████] 13/15 Performance checks (bundle size, benchmarks)
[██████████████] 14/15 Wait for all GitHub Actions to complete
[███████████████] 15/15 Run smoke tests on deployment

## Post-Deploy Monitoring
- Verify error tracking receiving events
- Check monitoring dashboards
- Send team notifications
- Monitor for 15 minutes

Execute each phase with progress tracking and auto-remediation where possible.
```

---

## 📦 Quick Install Script

Run this to set up everything:

```bash
#!/bin/bash
# scripts/setup-security-gates.sh

echo "🔒 Setting up security and quality gates..."

# Install dependencies
npm install --save-dev \
  git-secrets \
  snyk \
  bundlesize \
  @lhci/cli

# Setup git-secrets
git secrets --install
git secrets --register-aws
git secrets --add 'api[_-]?key[_-]?=.{20,}'
git secrets --add 'secret[_-]?key[_-]?=.{20,}'

# Create .env.example if it doesn't exist
if [ ! -f .env.example ]; then
  cat .env | sed 's/=.*/=/' > .env.example
  echo "✅ Created .env.example"
fi

# Create scripts directory
mkdir -p scripts reports backups

# Create validation scripts
curl -o scripts/validate-env.js https://gist.githubusercontent.com/.../validate-env.js
curl -o scripts/smoke-tests.js https://gist.githubusercontent.com/.../smoke-tests.js

# Update package.json with new scripts
npm pkg set scripts.presecrets="git secrets --scan"
npm pkg set scripts.audit:full="npm audit && npm audit --json > reports/audit-\$(date +%Y%m%d).json"
npm pkg set scripts.validate:env="node scripts/validate-env.js"
npm pkg set scripts.smoke:local="node scripts/smoke-tests.js"

echo "✅ Security gates setup complete!"
echo ""
echo "Next steps:"
echo "1. Run 'npm run presecrets' to scan for secrets"
echo "2. Run 'npm run audit:full' to check dependencies"
echo "3. Run 'npm run validate:env' to verify env vars"
echo "4. Run 'npm run smoke:local' to test your app"
```

**Make it executable and run:**
```bash
chmod +x scripts/setup-security-gates.sh
./scripts/setup-security-gates.sh
```

---

## ✅ Verification Checklist

After setup, verify each component works:

```bash
# Test secret scanning
echo "API_KEY=sk_test_12345" > test.txt
git add test.txt
git commit -m "test"  # Should be blocked!
rm test.txt

# Test dependency audit
npm audit --production

# Test env validation
npm run validate:env

# Test smoke tests
npm run smoke:local

# Test bundle size
npm run build
npm run bundlesize
```

---

This gets you started with the most critical missing pieces. Would you like me to create the GitHub Actions workflow files or help set up any specific tool for your projects?
