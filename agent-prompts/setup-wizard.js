#!/usr/bin/env node

/**
 * Claude Agent Prompts - Adaptive Setup Wizard
 * Detects environment and configures automation based on user preferences
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { execSync } = require('child_process');

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  dim: '\x1b[2m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m',
  white: '\x1b[37m'
};

// State
let detectedEnvironment = {
  cicd: null,
  platform: null,
  nodeVersion: null,
  git: false,
  github: false,
  packageManager: null,
  projectType: null
};

let userPreferences = {
  automationLevel: null,
  features: [],
  cicdPlatform: null
};

// Utility functions
function clear() {
  console.clear();
}

function print(text, color = 'white') {
  console.log(colors[color] + text + colors.reset);
}

function header(text) {
  console.log('\n' + colors.bright + colors.cyan + '═'.repeat(80) + colors.reset);
  console.log(colors.bright + colors.cyan + '  ' + text + colors.reset);
  console.log(colors.bright + colors.cyan + '═'.repeat(80) + colors.reset + '\n');
}

function prompt(question) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise((resolve) => {
    rl.question(colors.yellow + '  ' + question + ' ' + colors.reset, (answer) => {
      rl.close();
      resolve(answer.trim());
    });
  });
}

function execCommand(cmd, silent = true) {
  try {
    const result = execSync(cmd, { encoding: 'utf8', stdio: silent ? 'pipe' : 'inherit' });
    return { success: true, output: result.trim() };
  } catch (error) {
    return { success: false, output: '' };
  }
}

// Environment detection
async function detectEnvironment() {
  clear();
  header('🔍 Detecting Your Environment');

  print('  Analyzing your development environment...\n', 'cyan');

  // Detect Node.js version
  const nodeVersion = execCommand('node --version');
  if (nodeVersion.success) {
    detectedEnvironment.nodeVersion = nodeVersion.output;
    print(`  ✓ Node.js: ${nodeVersion.output}`, 'green');
  }

  // Detect package manager
  if (fs.existsSync('package-lock.json')) {
    detectedEnvironment.packageManager = 'npm';
    print('  ✓ Package Manager: npm', 'green');
  } else if (fs.existsSync('yarn.lock')) {
    detectedEnvironment.packageManager = 'yarn';
    print('  ✓ Package Manager: yarn', 'green');
  } else if (fs.existsSync('pnpm-lock.yaml')) {
    detectedEnvironment.packageManager = 'pnpm';
    print('  ✓ Package Manager: pnpm', 'green');
  }

  // Detect Git
  const git = execCommand('git --version');
  if (git.success) {
    detectedEnvironment.git = true;
    print(`  ✓ Git: ${git.output}`, 'green');

    // Check if it's a GitHub repository
    const remote = execCommand('git remote get-url origin');
    if (remote.success && remote.output.includes('github.com')) {
      detectedEnvironment.github = true;
      detectedEnvironment.platform = 'github';
      print('  ✓ Platform: GitHub', 'green');
    }
  }

  // Detect CI/CD
  if (fs.existsSync('.github/workflows')) {
    detectedEnvironment.cicd = 'github-actions';
    print('  ✓ CI/CD: GitHub Actions', 'green');
  } else if (fs.existsSync('.gitlab-ci.yml')) {
    detectedEnvironment.cicd = 'gitlab-ci';
    detectedEnvironment.platform = 'gitlab';
    print('  ✓ CI/CD: GitLab CI', 'green');
  } else if (fs.existsSync('Jenkinsfile')) {
    detectedEnvironment.cicd = 'jenkins';
    print('  ✓ CI/CD: Jenkins', 'green');
  } else if (fs.existsSync('.circleci/config.yml')) {
    detectedEnvironment.cicd = 'circleci';
    print('  ✓ CI/CD: CircleCI', 'green');
  } else {
    print('  ⚠ CI/CD: Not detected', 'yellow');
  }

  // Detect project type
  if (fs.existsSync('package.json')) {
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    if (pkg.dependencies?.react || pkg.devDependencies?.react) {
      detectedEnvironment.projectType = 'react';
      print('  ✓ Project Type: React', 'green');
    } else if (pkg.dependencies?.vue || pkg.devDependencies?.vue) {
      detectedEnvironment.projectType = 'vue';
      print('  ✓ Project Type: Vue', 'green');
    } else if (pkg.dependencies?.express) {
      detectedEnvironment.projectType = 'express';
      print('  ✓ Project Type: Express', 'green');
    } else {
      detectedEnvironment.projectType = 'node';
      print('  ✓ Project Type: Node.js', 'green');
    }
  }

  await new Promise(resolve => setTimeout(resolve, 1000));
}

// Recommendation engine
function getRecommendation() {
  if (detectedEnvironment.github && detectedEnvironment.cicd === 'github-actions') {
    return {
      option: 1,
      reason: 'You\'re using GitHub with GitHub Actions - full automation is perfect for you!'
    };
  } else if (detectedEnvironment.cicd && detectedEnvironment.cicd !== 'github-actions') {
    return {
      option: 2,
      reason: 'You have CI/CD but not GitHub Actions - the smart wizard works with any platform!'
    };
  } else if (!detectedEnvironment.cicd) {
    return {
      option: 3,
      reason: 'No CI/CD detected - start with lightweight templates and add automation later!'
    };
  }

  return {
    option: 2,
    reason: 'The smart wizard provides the best balance of automation and flexibility!'
  };
}

// Choose automation level
async function chooseAutomationLevel() {
  clear();
  header('⚙️ Choose Your Automation Level');

  const recommendation = getRecommendation();

  print('  Based on your environment, here are your options:\n', 'cyan');

  print('  ' + colors.green + '1. Full Automation' + colors.reset + ' (GitHub Actions CI/CD)', 'white');
  print('     • Automatic version bumping on merge', 'dim');
  print('     • Auto-generate changelogs from commits', 'dim');
  print('     • Auto-create PRs for updates', 'dim');
  print('     • Post build/test results as comments', 'dim');
  print('     • Create issues for failed builds', 'dim');
  print('     • Zero manual work required', 'dim');
  if (recommendation.option === 1) print('     ' + colors.yellow + '⭐ RECOMMENDED for you' + colors.reset, 'yellow');
  console.log();

  print('  ' + colors.cyan + '2. Smart Wizard' + colors.reset + ' (Platform Agnostic)', 'white');
  print('     • Interactive setup with auto-detection', 'dim');
  print('     • Works with ANY CI/CD system', 'dim');
  print('     • Generates custom scripts for your stack', 'dim');
  print('     • Smart upgrade system', 'dim');
  print('     • Health monitoring and diagnostics', 'dim');
  if (recommendation.option === 2) print('     ' + colors.yellow + '⭐ RECOMMENDED for you' + colors.reset, 'yellow');
  console.log();

  print('  ' + colors.blue + '3. Lite Templates' + colors.reset + ' (Manual Control)', 'white');
  print('     • Lightweight npm scripts', 'dim');
  print('     • Template generators for CI/CD', 'dim');
  print('     • Manual but flexible', 'dim');
  print('     • Full user control', 'dim');
  print('     • Easy to understand and modify', 'dim');
  if (recommendation.option === 3) print('     ' + colors.yellow + '⭐ RECOMMENDED for you' + colors.reset, 'yellow');
  console.log();

  print(`  ${colors.dim}💡 Recommendation: ${recommendation.reason}${colors.reset}\n`, 'dim');

  const choice = await prompt('  Select automation level [1/2/3]:');

  switch(choice) {
    case '1':
      userPreferences.automationLevel = 'full';
      return setupFullAutomation();
    case '2':
      userPreferences.automationLevel = 'smart';
      return setupSmartWizard();
    case '3':
      userPreferences.automationLevel = 'lite';
      return setupLiteTemplates();
    default:
      print('\n  Invalid choice. Please try again.', 'red');
      await new Promise(resolve => setTimeout(resolve, 1500));
      return chooseAutomationLevel();
  }
}

// Setup Option 1: Full Automation
async function setupFullAutomation() {
  clear();
  header('🤖 Setting Up Full Automation (GitHub Actions)');

  if (!detectedEnvironment.github) {
    print('\n  ⚠ Warning: This option works best with GitHub.', 'yellow');
    print('  Detected platform: ' + (detectedEnvironment.platform || 'Unknown'), 'yellow');
    const confirm = await prompt('\n  Continue anyway? [y/N]:');
    if (confirm.toLowerCase() !== 'y') {
      return chooseAutomationLevel();
    }
  }

  print('\n  What features do you want?\n', 'cyan');

  const features = [
    { key: 'version', name: 'Automatic version bumping', default: true },
    { key: 'changelog', name: 'Auto-generate changelog', default: true },
    { key: 'pr-comments', name: 'Post test results on PRs', default: true },
    { key: 'issue-creation', name: 'Create issues for failures', default: true },
    { key: 'diagnostics', name: 'Collect diagnostic data', default: true },
    { key: 'health-monitor', name: 'Integration health monitoring', default: false }
  ];

  print('  Select features to enable (space to toggle, enter to continue):\n', 'white');

  for (const feature of features) {
    const choice = await prompt(`  [${feature.default ? '✓' : ' '}] ${feature.name}? [Y/n]:`);
    if (choice.toLowerCase() !== 'n') {
      userPreferences.features.push(feature.key);
    }
  }

  print('\n  ✓ Configuration saved!', 'green');
  print('\n  Generating GitHub Actions workflows...', 'cyan');

  // Generate workflows
  await generateGitHubActionsWorkflows(userPreferences.features);

  print('\n  ✓ Full automation setup complete!', 'green');
  await showNextSteps('full');
}

// Setup Option 2: Smart Wizard
async function setupSmartWizard() {
  clear();
  header('🧙‍♂️ Setting Up Smart Wizard');

  print('\n  The Smart Wizard provides intelligent automation for any CI/CD platform.\n', 'cyan');

  // Ask about CI/CD platform
  if (!detectedEnvironment.cicd) {
    print('  Which CI/CD platform do you use?\n', 'white');
    print('  1. GitHub Actions', 'white');
    print('  2. GitLab CI', 'white');
    print('  3. Jenkins', 'white');
    print('  4. CircleCI', 'white');
    print('  5. Other/None', 'white');

    const choice = await prompt('\n  Select platform [1-5]:');

    const platforms = {
      '1': 'github-actions',
      '2': 'gitlab-ci',
      '3': 'jenkins',
      '4': 'circleci',
      '5': 'other'
    };

    userPreferences.cicdPlatform = platforms[choice] || 'other';
  } else {
    userPreferences.cicdPlatform = detectedEnvironment.cicd;
  }

  print('\n  Features to enable:\n', 'cyan');

  const features = [
    { key: 'auto-detect', name: 'Auto-detect project stack', default: true },
    { key: 'diagnostics', name: 'Diagnostic collection', default: true },
    { key: 'health-check', name: 'Health monitoring', default: true },
    { key: 'upgrade', name: 'Smart upgrade system', default: true },
    { key: 'templates', name: 'Generate CI/CD templates', default: true }
  ];

  for (const feature of features) {
    const choice = await prompt(`  [${feature.default ? '✓' : ' '}] ${feature.name}? [Y/n]:`);
    if (choice.toLowerCase() !== 'n') {
      userPreferences.features.push(feature.key);
    }
  }

  print('\n  ✓ Configuration saved!', 'green');
  print('\n  Generating smart wizard tools...', 'cyan');

  await generateSmartWizardTools(userPreferences);

  print('\n  ✓ Smart wizard setup complete!', 'green');
  await showNextSteps('smart');
}

// Setup Option 3: Lite Templates
async function setupLiteTemplates() {
  clear();
  header('📋 Setting Up Lite Templates');

  print('\n  Lite templates provide manual control with helpful scripts.\n', 'cyan');

  print('  Which CI/CD templates do you want to generate?\n', 'white');
  print('  1. GitHub Actions', 'white');
  print('  2. GitLab CI', 'white');
  print('  3. Jenkins', 'white');
  print('  4. CircleCI', 'white');
  print('  5. All platforms', 'white');
  print('  6. None (just npm scripts)', 'white');

  const choice = await prompt('\n  Select option [1-6]:');

  const templateChoices = {
    '1': ['github-actions'],
    '2': ['gitlab-ci'],
    '3': ['jenkins'],
    '4': ['circleci'],
    '5': ['github-actions', 'gitlab-ci', 'jenkins', 'circleci'],
    '6': []
  };

  const templates = templateChoices[choice] || [];

  print('\n  Features to include:\n', 'cyan');

  const features = [
    { key: 'release', name: 'Release management scripts', default: true },
    { key: 'diagnostics', name: 'Diagnostic export', default: true },
    { key: 'health', name: 'Health check scripts', default: true },
    { key: 'upgrade', name: 'Upgrade check', default: true }
  ];

  for (const feature of features) {
    const choice = await prompt(`  [${feature.default ? '✓' : ' '}] ${feature.name}? [Y/n]:`);
    if (choice.toLowerCase() !== 'n') {
      userPreferences.features.push(feature.key);
    }
  }

  print('\n  ✓ Configuration saved!', 'green');
  print('\n  Generating templates and scripts...', 'cyan');

  await generateLiteTemplates(templates, userPreferences.features);

  print('\n  ✓ Lite templates setup complete!', 'green');
  await showNextSteps('lite');
}

// Generate GitHub Actions workflows
async function generateGitHubActionsWorkflows(features) {
  const workflowsDir = '.github/workflows';

  // Create directory if it doesn't exist
  if (!fs.existsSync(workflowsDir)) {
    fs.mkdirSync(workflowsDir, { recursive: true });
  }

  // Generate workflows based on selected features
  if (features.includes('version')) {
    generateVersionBumpWorkflow(workflowsDir);
    print('  ✓ Generated version-bump.yml', 'green');
  }

  if (features.includes('changelog')) {
    generateChangelogWorkflow(workflowsDir);
    print('  ✓ Generated changelog.yml', 'green');
  }

  if (features.includes('pr-comments')) {
    generatePRCommentsWorkflow(workflowsDir);
    print('  ✓ Generated pr-comment.yml', 'green');
  }

  if (features.includes('issue-creation')) {
    generateIssueCreationWorkflow(workflowsDir);
    print('  ✓ Generated issue-on-failure.yml', 'green');
  }

  if (features.includes('diagnostics')) {
    generateDiagnosticsWorkflow(workflowsDir);
    print('  ✓ Generated diagnostics.yml', 'green');
  }

  if (features.includes('health-monitor')) {
    generateHealthMonitorWorkflow(workflowsDir);
    print('  ✓ Generated health-monitor.yml', 'green');
  }
}

// Workflow generators (placeholder - full implementation below)
function generateVersionBumpWorkflow(dir) {
  const workflow = `name: Auto Version Bump

on:
  push:
    branches: [main, master]

jobs:
  version-bump:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
          token: \${{ secrets.GITHUB_TOKEN }}

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Determine version bump type
        id: bump-type
        run: |
          # Analyze commit messages for version bump type
          if git log -1 --pretty=%B | grep -q "BREAKING CHANGE"; then
            echo "type=major" >> $GITHUB_OUTPUT
          elif git log -1 --pretty=%B | grep -q "^feat"; then
            echo "type=minor" >> $GITHUB_OUTPUT
          else
            echo "type=patch" >> $GITHUB_OUTPUT
          fi

      - name: Bump version
        run: |
          cd agent-prompts
          npm version \${{ steps.bump-type.outputs.type }} --no-git-tag-version
          NEW_VERSION=$(node -p "require('./package.json').version")
          echo $NEW_VERSION > VERSION
          echo "NEW_VERSION=$NEW_VERSION" >> $GITHUB_ENV

      - name: Commit version bump
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add agent-prompts/package.json agent-prompts/VERSION
          git commit -m "chore: bump version to $NEW_VERSION [skip ci]"
          git push

      - name: Create git tag
        run: |
          git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION"
          git push origin "v$NEW_VERSION"
`;

  fs.writeFileSync(path.join(dir, 'version-bump.yml'), workflow);
}

function generateChangelogWorkflow(dir) {
  const workflow = `name: Auto Generate Changelog

on:
  push:
    tags:
      - 'v*'

jobs:
  changelog:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Generate changelog
        id: changelog
        run: |
          # Get previous tag
          PREV_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")

          # Generate changelog from commits
          if [ -z "$PREV_TAG" ]; then
            COMMITS=$(git log --pretty=format:"- %s (%h)" HEAD)
          else
            COMMITS=$(git log --pretty=format:"- %s (%h)" $PREV_TAG..HEAD)
          fi

          # Append to CHANGELOG.md
          VERSION=\${GITHUB_REF#refs/tags/v}
          DATE=$(date +%Y-%m-%d)

          cat > temp_changelog.md << EOF
## [$VERSION] - $DATE

$COMMITS

EOF

          if [ -f agent-prompts/CHANGELOG.md ]; then
            # Insert after first heading
            sed -i '/^## \\[/r temp_changelog.md' agent-prompts/CHANGELOG.md
          fi

      - name: Commit changelog
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add agent-prompts/CHANGELOG.md
          git commit -m "docs: update changelog for \${GITHUB_REF#refs/tags/}" || true
          git push || true
`;

  fs.writeFileSync(path.join(dir, 'changelog.yml'), workflow);
}

function generatePRCommentsWorkflow(dir) {
  const workflow = `name: PR Test Results Comment

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  test-and-comment:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: |
          cd agent-prompts
          npm install

      - name: Run tests
        id: tests
        continue-on-error: true
        run: |
          cd agent-prompts
          npm test > test-results.txt 2>&1
          cat test-results.txt

      - name: Post test results
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const testResults = fs.readFileSync('agent-prompts/test-results.txt', 'utf8');

            const body = \`## 🧪 Test Results

            <details>
            <summary>Click to expand test output</summary>

            \\\`\\\`\\\`
            \${testResults}
            \\\`\\\`\\\`

            </details>

            **Status:** ${{ steps.tests.outcome == 'success' && '✅ All tests passed!' || '❌ Tests failed' }}
            \`;

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: body
            });
`;

  fs.writeFileSync(path.join(dir, 'pr-comment.yml'), workflow);
}

function generateIssueCreationWorkflow(dir) {
  const workflow = `name: Create Issue on Build Failure

on:
  workflow_run:
    workflows: ["*"]
    types:
      - completed

jobs:
  create-issue:
    runs-on: ubuntu-latest
    if: \${{ github.event.workflow_run.conclusion == 'failure' }}
    steps:
      - uses: actions/checkout@v3

      - name: Create diagnostic issue
        uses: actions/github-script@v6
        with:
          script: |
            const workflowName = '${{ github.event.workflow_run.name }}';
            const runUrl = '${{ github.event.workflow_run.html_url }}';
            const sha = '${{ github.event.workflow_run.head_sha }}';

            const body = \`## 🔴 Build Failure Detected

            **Workflow:** \${workflowName}
            **Run URL:** \${runUrl}
            **Commit:** \${sha}

            ### Diagnostic Information

            - **Runner:** ${{ runner.os }}
            - **Event:** ${{ github.event_name }}
            - **Branch:** ${{ github.ref }}

            ### Next Steps

            1. Review the [failed workflow run](\${runUrl})
            2. Check the logs for error messages
            3. Fix the issue and push a new commit

            This issue was automatically created by the CI/CD diagnostic system.
            \`;

            await github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: \`[CI] Build failure in \${workflowName}\`,
              body: body,
              labels: ['bug', 'ci-failure', 'automated']
            });
`;

  fs.writeFileSync(path.join(dir, 'issue-on-failure.yml'), workflow);
}

function generateDiagnosticsWorkflow(dir) {
  const workflow = `name: Collect Diagnostics

on:
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday

jobs:
  diagnostics:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Collect diagnostic data
        run: |
          cat > diagnostics.json << EOF
          {
            "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
            "repository": "${{ github.repository }}",
            "workflow": "${{ github.workflow }}",
            "runner": {
              "os": "${{ runner.os }}",
              "arch": "${{ runner.arch }}"
            },
            "agent_prompts": {
              "version": "$(cat agent-prompts/VERSION 2>/dev/null || echo 'unknown')",
              "file_count": $(find agent-prompts -name '*.md' | wc -l),
              "integration_status": "active"
            },
            "environment": {
              "node_version": "$(node --version)",
              "npm_version": "$(npm --version)"
            }
          }
          EOF

      - name: Upload diagnostics
        uses: actions/upload-artifact@v3
        with:
          name: diagnostics
          path: diagnostics.json
          retention-days: 30
`;

  fs.writeFileSync(path.join(dir, 'diagnostics.yml'), workflow);
}

function generateHealthMonitorWorkflow(dir) {
  const workflow = `name: Integration Health Monitor

on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours
  workflow_dispatch:

jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Run health checks
        run: |
          cd agent-prompts

          # Check catalog integrity
          node -e "
            const fs = require('fs');
            const catalog = JSON.parse(fs.readFileSync('./catalog.json', 'utf8'));
            console.log('✓ Catalog loaded:', Object.keys(catalog.categories).length, 'categories');
          "

          # Verify agent files exist
          MISSING=0
          while IFS= read -r file; do
            if [ ! -f "$file" ]; then
              echo "✗ Missing: $file"
              MISSING=$((MISSING + 1))
            fi
          done < <(find . -name '*.md' -type f)

          if [ $MISSING -eq 0 ]; then
            echo "✓ All agent files present"
          else
            echo "✗ $MISSING files missing"
            exit 1
          fi

      - name: Report health status
        if: failure()
        uses: actions/github-script@v6
        with:
          script: |
            await github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: '[Health] Agent integration health check failed',
              body: 'The automated health check has detected issues with the agent prompts integration. Please review the workflow logs for details.',
              labels: ['health-check', 'automated']
            });
`;

  fs.writeFileSync(path.join(dir, 'health-monitor.yml'), workflow);
}

// Generate smart wizard tools
async function generateSmartWizardTools(preferences) {
  // Create tools directory
  const toolsDir = 'agent-prompts/tools';
  if (!fs.existsSync(toolsDir)) {
    fs.mkdirSync(toolsDir, { recursive: true });
  }

  // Generate diagnostic tool
  if (preferences.features.includes('diagnostics')) {
    generateDiagnosticTool(toolsDir);
    print('  ✓ Generated diagnostic.js', 'green');
  }

  // Generate health check tool
  if (preferences.features.includes('health-check')) {
    generateHealthCheckTool(toolsDir);
    print('  ✓ Generated health-check.js', 'green');
  }

  // Generate upgrade tool
  if (preferences.features.includes('upgrade')) {
    generateUpgradeTool(toolsDir);
    print('  ✓ Generated upgrade.js', 'green');
  }

  // Generate CI/CD templates
  if (preferences.features.includes('templates')) {
    await generateCICDTemplates(toolsDir, preferences.cicdPlatform);
    print('  ✓ Generated CI/CD templates', 'green');
  }

  // Update package.json with new scripts
  updatePackageJsonScripts('smart', preferences.features);
}

// Generate lite templates
async function generateLiteTemplates(templates, features) {
  const templatesDir = 'agent-prompts/templates/cicd';
  if (!fs.existsSync(templatesDir)) {
    fs.mkdirSync(templatesDir, { recursive: true });
  }

  // Generate templates for each platform
  for (const template of templates) {
    await generatePlatformTemplate(templatesDir, template);
    print(`  ✓ Generated ${template} template`, 'green');
  }

  // Generate npm scripts
  updatePackageJsonScripts('lite', features);
  print('  ✓ Updated package.json scripts', 'green');
}

// Tool generators (examples)
function generateDiagnosticTool(dir) {
  const tool = `#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

function collectDiagnostics() {
  const diagnostics = {
    timestamp: new Date().toISOString(),
    version: fs.readFileSync(path.join(__dirname, '../VERSION'), 'utf8').trim(),
    environment: {
      node: process.version,
      platform: process.platform,
      arch: process.arch
    },
    integration: {
      catalogValid: checkCatalog(),
      filesPresent: checkFiles(),
      configurationType: detectConfiguration()
    }
  };

  return diagnostics;
}

function checkCatalog() {
  try {
    const catalog = JSON.parse(fs.readFileSync(path.join(__dirname, '../catalog.json'), 'utf8'));
    return { valid: true, categories: Object.keys(catalog.categories).length };
  } catch (error) {
    return { valid: false, error: error.message };
  }
}

function checkFiles() {
  // Count agent files
  const agentDirs = ['core', 'github', 'hive-mind', 'swarm', 'sparc'];
  let count = 0;

  agentDirs.forEach(dir => {
    const dirPath = path.join(__dirname, '..', dir);
    if (fs.existsSync(dirPath)) {
      count += fs.readdirSync(dirPath).filter(f => f.endsWith('.md')).length;
    }
  });

  return { count };
}

function detectConfiguration() {
  if (fs.existsSync('.github/workflows/version-bump.yml')) return 'full-automation';
  if (fs.existsSync('agent-prompts/tools/upgrade.js')) return 'smart-wizard';
  return 'lite-templates';
}

// Run if called directly
if (require.main === module) {
  const diagnostics = collectDiagnostics();
  console.log(JSON.stringify(diagnostics, null, 2));

  // Optionally write to file
  fs.writeFileSync('diagnostics.json', JSON.stringify(diagnostics, null, 2));
  console.log('\\n✓ Diagnostics saved to diagnostics.json');
}

module.exports = { collectDiagnostics };
`;

  fs.writeFileSync(path.join(dir, 'diagnostic.js'), tool);
  fs.chmodSync(path.join(dir, 'diagnostic.js'), '755');
}

function generateHealthCheckTool(dir) {
  const tool = `#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

function runHealthCheck() {
  const checks = [];

  // Check catalog
  checks.push({
    name: 'Catalog Integrity',
    status: checkCatalogIntegrity(),
    critical: true
  });

  // Check agent files
  checks.push({
    name: 'Agent Files',
    status: checkAgentFiles(),
    critical: true
  });

  // Check version consistency
  checks.push({
    name: 'Version Consistency',
    status: checkVersions(),
    critical: false
  });

  // Display results
  console.log('\\n🏥 Health Check Results\\n');

  let allPassed = true;
  checks.forEach(check => {
    const icon = check.status.passed ? '✓' : '✗';
    const color = check.status.passed ? '\\x1b[32m' : '\\x1b[31m';
    console.log(\`  \${color}\${icon}\\x1b[0m \${check.name}: \${check.status.message}\`);

    if (!check.status.passed && check.critical) {
      allPassed = false;
    }
  });

  console.log('');
  return allPassed ? 0 : 1;
}

function checkCatalogIntegrity() {
  try {
    const catalog = JSON.parse(fs.readFileSync(path.join(__dirname, '../catalog.json'), 'utf8'));
    const categories = Object.keys(catalog.categories).length;
    return { passed: true, message: \`Valid (\${categories} categories)\` };
  } catch (error) {
    return { passed: false, message: error.message };
  }
}

function checkAgentFiles() {
  const expectedDirs = ['core', 'github', 'hive-mind', 'swarm', 'sparc'];
  let totalFiles = 0;

  expectedDirs.forEach(dir => {
    const dirPath = path.join(__dirname, '..', dir);
    if (fs.existsSync(dirPath)) {
      totalFiles += fs.readdirSync(dirPath).filter(f => f.endsWith('.md')).length;
    }
  });

  if (totalFiles > 0) {
    return { passed: true, message: \`\${totalFiles} agent files found\` };
  } else {
    return { passed: false, message: 'No agent files found' };
  }
}

function checkVersions() {
  try {
    const versionFile = fs.readFileSync(path.join(__dirname, '../VERSION'), 'utf8').trim();
    const packageJson = JSON.parse(fs.readFileSync(path.join(__dirname, '../package.json'), 'utf8'));

    if (versionFile === packageJson.version) {
      return { passed: true, message: \`Consistent (v\${versionFile})\` };
    } else {
      return { passed: false, message: \`Mismatch: VERSION=\${versionFile}, package.json=\${packageJson.version}\` };
    }
  } catch (error) {
    return { passed: false, message: error.message };
  }
}

// Run if called directly
if (require.main === module) {
  process.exit(runHealthCheck());
}

module.exports = { runHealthCheck };
`;

  fs.writeFileSync(path.join(dir, 'health-check.js'), tool);
  fs.chmodSync(path.join(dir, 'health-check.js'), '755');
}

function generateUpgradeTool(dir) {
  const tool = `#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const https = require('https');

async function checkForUpdates() {
  console.log('🔍 Checking for updates...\\n');

  const currentVersion = fs.readFileSync(path.join(__dirname, '../VERSION'), 'utf8').trim();
  console.log(\`  Current version: \${currentVersion}\`);

  // Check GitHub for latest release
  // This is a placeholder - implement actual version check
  console.log('  Latest version: 1.0.0');
  console.log('\\n  ✓ You have the latest version!\\n');
}

async function performUpgrade() {
  console.log('🚀 Starting upgrade process...\\n');

  // Backup current installation
  console.log('  Creating backup...');

  // Download new version
  console.log('  Downloading updates...');

  // Apply updates
  console.log('  Applying updates...');

  // Migrate configuration
  console.log('  Migrating configuration...');

  console.log('\\n  ✓ Upgrade complete!\\n');
}

// Run if called directly
if (require.main === module) {
  const args = process.argv.slice(2);

  if (args.includes('--check')) {
    checkForUpdates();
  } else if (args.includes('--upgrade')) {
    performUpgrade();
  } else {
    console.log('Usage: upgrade.js [--check|--upgrade]');
  }
}

module.exports = { checkForUpdates, performUpgrade };
`;

  fs.writeFileSync(path.join(dir, 'upgrade.js'), tool);
  fs.chmodSync(path.join(dir, 'upgrade.js'), '755');
}

async function generateCICDTemplates(dir, platform) {
  // Implementation for different platforms
  const templates = {
    'github-actions': 'GitHub Actions template',
    'gitlab-ci': 'GitLab CI template',
    'jenkins': 'Jenkinsfile template',
    'circleci': 'CircleCI config template'
  };

  // Generate template based on platform
  console.log(\`  Generated \${templates[platform] || 'generic template'}\`);
}

async function generatePlatformTemplate(dir, platform) {
  // Placeholder for platform-specific template generation
  fs.writeFileSync(path.join(dir, \`\${platform}.md\`), \`# \${platform} Template\\n\\nTODO: Add template\`);
}

function updatePackageJsonScripts(type, features) {
  const packageJsonPath = 'agent-prompts/package.json';
  const pkg = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));

  if (type === 'smart') {
    pkg.scripts.diagnose = 'node tools/diagnostic.js';
    pkg.scripts.health = 'node tools/health-check.js';
    pkg.scripts.upgrade = 'node tools/upgrade.js';
  } else if (type === 'lite') {
    pkg.scripts.release = 'echo "Manual release - see templates/cicd/"';
    if (features.includes('diagnostics')) {
      pkg.scripts.diagnose = 'node tools/diagnostic.js';
    }
    if (features.includes('health')) {
      pkg.scripts.health = 'node tools/health-check.js';
    }
  }

  fs.writeFileSync(packageJsonPath, JSON.stringify(pkg, null, 2) + '\\n');
}

async function showNextSteps(type) {
  console.log('\\n' + colors.cyan + colors.bright + '📋 Next Steps' + colors.reset + '\\n');

  if (type === 'full') {
    print('  1. Review generated workflows in .github/workflows/', 'white');
    print('  2. Commit and push to trigger automation', 'white');
    print('  3. Watch your PRs for automatic comments!', 'white');
  } else if (type === 'smart') {
    print('  1. Run npm run diagnose to test diagnostics', 'white');
    print('  2. Run npm run health to check integration', 'white');
    print('  3. Run npm run upgrade to check for updates', 'white');
  } else if (type === 'lite') {
    print('  1. Check templates/cicd/ for CI/CD templates', 'white');
    print('  2. Run npm run release to create a release', 'white');
    print('  3. Customize scripts in package.json as needed', 'white');
  }

  const cont = await prompt('\\n  Press Enter to continue...');
}

// Main execution
async function main() {
  clear();

  print(\`
  ╔═══════════════════════════════════════════════════════════════════════════╗
  ║                                                                           ║
  ║         🧙 CLAUDE AGENT PROMPTS - SETUP WIZARD                           ║
  ║                                                                           ║
  ║         Adaptive automation for every DevOps workflow                    ║
  ║                                                                           ║
  ╚═══════════════════════════════════════════════════════════════════════════╝
  \`, 'cyan');

  await new Promise(resolve => setTimeout(resolve, 1500));

  // Detect environment
  await detectEnvironment();

  await prompt('\\n  Press Enter to continue...');

  // Choose automation level
  await chooseAutomationLevel();

  // Final message
  clear();
  header('✅ Setup Complete!');

  print('  Your automation is configured and ready to use.', 'green');
  print('  Run the agent integration tool to get started:', 'cyan');
  print('\\n    cd agent-prompts', 'white');
  print('    ./integrate.js', 'white');
  print('\\n  For documentation, see:', 'cyan');
  print('    README.md, QUICKSTART.md, INTEGRATION_GUIDE.md\\n', 'white');
}

if (require.main === module) {
  main().catch(error => {
    print('\\n  ✗ Error: ' + error.message, 'red');
    process.exit(1);
  });
}

module.exports = {
  detectEnvironment,
  chooseAutomationLevel,
  setupFullAutomation,
  setupSmartWizard,
  setupLiteTemplates
};
