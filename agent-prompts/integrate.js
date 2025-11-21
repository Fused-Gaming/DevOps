#!/usr/bin/env node

/**
 * Claude Agent Prompts Integration Tool
 * Interactive CLI for browsing and integrating agent prompts into any project
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

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
  white: '\x1b[37m',
  bgBlue: '\x1b[44m',
  bgGreen: '\x1b[42m'
};

// Loading animation frames
const loadingFrames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
let loadingInterval;

// Breadcrumb trail
let breadcrumbs = ['Home'];

// State
let catalog;
let currentCategory = null;
let selectedAgents = [];

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

function breadcrumb() {
  const trail = breadcrumbs.map((crumb, i) => {
    if (i === breadcrumbs.length - 1) {
      return colors.bright + colors.cyan + crumb + colors.reset;
    }
    return colors.dim + crumb + colors.reset;
  }).join(colors.dim + ' > ' + colors.reset);
  console.log('  ' + trail + '\n');
}

function startLoading(message) {
  let i = 0;
  process.stdout.write('\n  ');
  loadingInterval = setInterval(() => {
    process.stdout.write(`\r  ${colors.cyan}${loadingFrames[i]}${colors.reset} ${message}...`);
    i = (i + 1) % loadingFrames.length;
  }, 80);
}

function stopLoading(message, success = true) {
  clearInterval(loadingInterval);
  const icon = success ? colors.green + '✓' + colors.reset : colors.red + '✗' + colors.reset;
  process.stdout.write(`\r  ${icon} ${message}\n`);
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

function displayMenu(title, options, showBack = true) {
  header(title);
  breadcrumb();

  options.forEach((option, index) => {
    const icon = option.icon || '▸';
    const color = option.color || 'white';
    console.log(`  ${colors[color]}${index + 1}.${colors.reset} ${icon} ${option.label}`);
    if (option.description) {
      console.log(`     ${colors.dim}${option.description}${colors.reset}`);
    }
  });

  if (showBack) {
    console.log(`\n  ${colors.dim}0. ← Back${colors.reset}`);
  }
  console.log(`  ${colors.dim}q. Exit${colors.reset}\n`);
}

async function mainMenu() {
  clear();
  breadcrumbs = ['Home'];

  const options = [
    {
      label: 'Browse Agent Categories',
      icon: '📚',
      color: 'cyan',
      description: 'Explore agents organized by category'
    },
    {
      label: 'Search Agents',
      icon: '🔍',
      color: 'yellow',
      description: 'Find agents by name or capability'
    },
    {
      label: 'View Selected Agents',
      icon: '📋',
      color: 'green',
      description: `Currently selected: ${selectedAgents.length} agents`
    },
    {
      label: 'Integrate Into Project',
      icon: '🚀',
      color: 'magenta',
      description: 'Add selected agents to your project'
    },
    {
      label: 'Quick Integration Presets',
      icon: '⚡',
      color: 'blue',
      description: 'Pre-configured agent bundles for common use cases'
    },
    {
      label: 'About',
      icon: 'ℹ️',
      color: 'white',
      description: 'Learn more about this library'
    },
    {
      label: 'Support This Project',
      icon: '💝',
      color: 'magenta',
      description: 'Help support development'
    }
  ];

  displayMenu('🤖 Claude Agent Prompts Integration Tool', options, false);

  const choice = await prompt('Select an option:');

  switch(choice) {
    case '1': return browseCategories();
    case '2': return searchAgents();
    case '3': return viewSelected();
    case '4': return integrateAgents();
    case '5': return quickPresets();
    case '6': return showAbout();
    case '7': return showSupport();
    case 'q':
    case 'Q':
      print('\n  👋 Goodbye!\n', 'cyan');
      process.exit(0);
    default:
      print('  Invalid choice. Please try again.', 'red');
      await new Promise(resolve => setTimeout(resolve, 1500));
      return mainMenu();
  }
}

async function browseCategories() {
  clear();
  breadcrumbs = ['Home', 'Categories'];

  const categories = Object.entries(catalog.categories);
  const options = categories.map(([key, cat]) => ({
    label: cat.name,
    icon: cat.icon,
    color: 'cyan',
    description: `${cat.description} (${cat.agents.length} agents)`,
    key: key
  }));

  displayMenu('📚 Agent Categories', options);

  const choice = await prompt('Select a category:');

  if (choice === '0') return mainMenu();
  if (choice === 'q' || choice === 'Q') process.exit(0);

  const index = parseInt(choice) - 1;
  if (index >= 0 && index < categories.length) {
    const [categoryKey] = categories[index];
    return viewCategory(categoryKey);
  }

  print('  Invalid choice. Please try again.', 'red');
  await new Promise(resolve => setTimeout(resolve, 1500));
  return browseCategories();
}

async function viewCategory(categoryKey) {
  clear();
  const category = catalog.categories[categoryKey];
  breadcrumbs = ['Home', 'Categories', category.name];

  const options = category.agents.map((agent, index) => ({
    label: agent.name,
    icon: selectedAgents.some(a => a.name === agent.name) ? '✓' : '○',
    color: selectedAgents.some(a => a.name === agent.name) ? 'green' : 'white',
    description: agent.description,
    agent: agent
  }));

  displayMenu(category.icon + ' ' + category.name, options);

  const choice = await prompt('Select agent to view/toggle (or "a" for all):');

  if (choice === '0') return browseCategories();
  if (choice === 'q' || choice === 'Q') process.exit(0);

  if (choice.toLowerCase() === 'a') {
    // Toggle all agents in category
    const allSelected = category.agents.every(agent =>
      selectedAgents.some(a => a.name === agent.name)
    );

    if (allSelected) {
      selectedAgents = selectedAgents.filter(a =>
        !category.agents.some(agent => agent.name === a.name)
      );
      print(`  ✓ Deselected all agents from ${category.name}`, 'yellow');
    } else {
      category.agents.forEach(agent => {
        if (!selectedAgents.some(a => a.name === agent.name)) {
          selectedAgents.push({ ...agent, category: categoryKey });
        }
      });
      print(`  ✓ Selected all agents from ${category.name}`, 'green');
    }

    await new Promise(resolve => setTimeout(resolve, 1500));
    return viewCategory(categoryKey);
  }

  const index = parseInt(choice) - 1;
  if (index >= 0 && index < category.agents.length) {
    const agent = category.agents[index];
    return viewAgent(agent, categoryKey);
  }

  print('  Invalid choice. Please try again.', 'red');
  await new Promise(resolve => setTimeout(resolve, 1500));
  return viewCategory(categoryKey);
}

async function viewAgent(agent, categoryKey) {
  clear();
  const category = catalog.categories[categoryKey];
  breadcrumbs = ['Home', 'Categories', category.name, agent.name];

  header(`${category.icon} ${agent.name}`);
  breadcrumb();

  print(`  Description: ${agent.description}`, 'white');
  print(`  Priority: ${agent.priority}`, agent.priority === 'critical' ? 'red' : agent.priority === 'high' ? 'yellow' : 'green');
  print(`  File: ${agent.file}`, 'dim');

  if (agent.capabilities && agent.capabilities.length > 0) {
    print(`\n  Capabilities:`, 'cyan');
    agent.capabilities.forEach(cap => {
      print(`    • ${cap}`, 'white');
    });
  }

  if (agent.useCase) {
    print(`\n  Use Case:`, 'cyan');
    print(`    ${agent.useCase}`, 'white');
  }

  const isSelected = selectedAgents.some(a => a.name === agent.name);
  print(`\n  Status: ${isSelected ? '✓ Selected' : '○ Not selected'}`, isSelected ? 'green' : 'dim');

  console.log('\n  Options:');
  console.log(`  ${colors.green}1.${colors.reset} ${isSelected ? 'Deselect' : 'Select'} this agent`);
  console.log(`  ${colors.cyan}2.${colors.reset} View full prompt content`);
  console.log(`  ${colors.dim}0. ← Back${colors.reset}\n`);

  const choice = await prompt('Select an option:');

  switch(choice) {
    case '1':
      if (isSelected) {
        selectedAgents = selectedAgents.filter(a => a.name !== agent.name);
        print('  ✓ Agent deselected', 'yellow');
      } else {
        selectedAgents.push({ ...agent, category: categoryKey });
        print('  ✓ Agent selected', 'green');
      }
      await new Promise(resolve => setTimeout(resolve, 1000));
      return viewAgent(agent, categoryKey);

    case '2':
      return viewPromptContent(agent, categoryKey);

    case '0':
      return viewCategory(categoryKey);

    default:
      return viewAgent(agent, categoryKey);
  }
}

async function viewPromptContent(agent, categoryKey) {
  clear();
  const category = catalog.categories[categoryKey];
  breadcrumbs = ['Home', 'Categories', category.name, agent.name, 'Content'];

  header(`${category.icon} ${agent.name} - Prompt Content`);
  breadcrumb();

  try {
    const filePath = path.join(__dirname, agent.file);
    const content = fs.readFileSync(filePath, 'utf8');

    // Display first 30 lines
    const lines = content.split('\n').slice(0, 30);
    lines.forEach(line => console.log('  ' + colors.dim + line + colors.reset));

    if (content.split('\n').length > 30) {
      print('\n  ... (truncated, full content in file)', 'dim');
    }

    print(`\n  Full path: ${filePath}`, 'cyan');

  } catch (error) {
    print('  ✗ Error reading prompt file: ' + error.message, 'red');
  }

  await prompt('\n  Press Enter to go back...');
  return viewAgent(agent, categoryKey);
}

async function searchAgents() {
  clear();
  breadcrumbs = ['Home', 'Search'];

  header('🔍 Search Agents');
  breadcrumb();

  const query = await prompt('Enter search term (name, capability, or use case):');

  if (!query) return mainMenu();

  startLoading('Searching');
  await new Promise(resolve => setTimeout(resolve, 500));

  const results = [];
  Object.entries(catalog.categories).forEach(([categoryKey, category]) => {
    category.agents.forEach(agent => {
      const searchText = `${agent.name} ${agent.description} ${agent.capabilities?.join(' ')} ${agent.useCase}`.toLowerCase();
      if (searchText.includes(query.toLowerCase())) {
        results.push({ ...agent, category: categoryKey, categoryName: category.name });
      }
    });
  });

  stopLoading('Search complete', true);

  if (results.length === 0) {
    print('\n  No agents found matching your search.', 'yellow');
    await prompt('\n  Press Enter to search again...');
    return searchAgents();
  }

  clear();
  header(`🔍 Search Results: "${query}" (${results.length} found)`);
  breadcrumb();

  results.forEach((agent, index) => {
    const isSelected = selectedAgents.some(a => a.name === agent.name);
    const icon = isSelected ? '✓' : '○';
    const color = isSelected ? 'green' : 'white';
    console.log(`  ${colors[color]}${index + 1}.${colors.reset} ${icon} ${agent.name} ${colors.dim}(${agent.categoryName})${colors.reset}`);
    console.log(`     ${colors.dim}${agent.description}${colors.reset}`);
  });

  console.log(`\n  ${colors.dim}0. ← New search${colors.reset}\n`);

  const choice = await prompt('Select agent to view:');

  if (choice === '0') return searchAgents();
  if (choice === 'q' || choice === 'Q') process.exit(0);

  const index = parseInt(choice) - 1;
  if (index >= 0 && index < results.length) {
    const agent = results[index];
    return viewAgent(agent, agent.category);
  }

  return searchAgents();
}

async function viewSelected() {
  clear();
  breadcrumbs = ['Home', 'Selected Agents'];

  header(`📋 Selected Agents (${selectedAgents.length})`);
  breadcrumb();

  if (selectedAgents.length === 0) {
    print('  No agents selected yet.', 'dim');
    print('\n  Browse categories or search to select agents.\n', 'cyan');
    await prompt('  Press Enter to continue...');
    return mainMenu();
  }

  selectedAgents.forEach((agent, index) => {
    console.log(`  ${colors.green}${index + 1}.${colors.reset} ${agent.name} ${colors.dim}(${agent.category})${colors.reset}`);
    console.log(`     ${colors.dim}${agent.description}${colors.reset}`);
  });

  console.log('\n  Options:');
  console.log(`  ${colors.red}c.${colors.reset} Clear all selections`);
  console.log(`  ${colors.cyan}i.${colors.reset} Integrate into project`);
  console.log(`  ${colors.dim}0. ← Back${colors.reset}\n`);

  const choice = await prompt('Select an option:');

  switch(choice.toLowerCase()) {
    case 'c':
      selectedAgents = [];
      print('  ✓ All selections cleared', 'yellow');
      await new Promise(resolve => setTimeout(resolve, 1000));
      return mainMenu();

    case 'i':
      return integrateAgents();

    case '0':
      return mainMenu();

    default:
      const index = parseInt(choice) - 1;
      if (index >= 0 && index < selectedAgents.length) {
        const agent = selectedAgents[index];
        return viewAgent(agent, agent.category);
      }
      return viewSelected();
  }
}

async function integrateAgents() {
  clear();
  breadcrumbs = ['Home', 'Integration'];

  header('🚀 Integrate Agents Into Project');
  breadcrumb();

  if (selectedAgents.length === 0) {
    print('  No agents selected. Please select agents first.', 'yellow');
    await prompt('\n  Press Enter to continue...');
    return mainMenu();
  }

  print(`  You have selected ${selectedAgents.length} agents to integrate.\n`, 'cyan');

  console.log('  Integration options:');
  console.log(`  ${colors.green}1.${colors.reset} Copy to .claude/agents/ directory (recommended)`);
  console.log(`  ${colors.cyan}2.${colors.reset} Copy to custom directory`);
  console.log(`  ${colors.yellow}3.${colors.reset} Generate integration script`);
  console.log(`  ${colors.dim}0. ← Back${colors.reset}\n`);

  const choice = await prompt('Select integration method:');

  switch(choice) {
    case '1':
      return performIntegration('.claude/agents');

    case '2':
      const customPath = await prompt('  Enter custom directory path:');
      if (customPath) {
        return performIntegration(customPath);
      }
      return integrateAgents();

    case '3':
      return generateIntegrationScript();

    case '0':
      return mainMenu();

    default:
      print('  Invalid choice. Please try again.', 'red');
      await new Promise(resolve => setTimeout(resolve, 1500));
      return integrateAgents();
  }
}

async function performIntegration(targetDir) {
  clear();
  header('🚀 Integrating Agents');
  breadcrumb();

  print(`  Target directory: ${targetDir}\n`, 'cyan');

  startLoading('Creating directories');
  await new Promise(resolve => setTimeout(resolve, 500));

  // Determine target path (absolute or relative to current project)
  const projectRoot = process.cwd();
  const absoluteTargetDir = path.isAbsolute(targetDir)
    ? targetDir
    : path.join(projectRoot, targetDir);

  try {
    // Create target directory structure
    for (const agent of selectedAgents) {
      const categoryDir = path.join(absoluteTargetDir, agent.category);
      if (!fs.existsSync(categoryDir)) {
        fs.mkdirSync(categoryDir, { recursive: true });
      }
    }

    stopLoading('Directories created', true);

    // Copy agent files
    let copiedCount = 0;
    for (const agent of selectedAgents) {
      startLoading(`Copying ${agent.name}`);
      await new Promise(resolve => setTimeout(resolve, 200));

      const sourcePath = path.join(__dirname, agent.file);
      const targetPath = path.join(absoluteTargetDir, agent.file);

      fs.copyFileSync(sourcePath, targetPath);
      copiedCount++;

      stopLoading(`Copied ${agent.name}`, true);
    }

    // Create integration summary
    const summaryPath = path.join(absoluteTargetDir, 'AGENTS_INTEGRATED.md');
    const summary = generateIntegrationSummary(selectedAgents, targetDir);
    fs.writeFileSync(summaryPath, summary);

    print(`\n  ${colors.bright}${colors.green}✓ Integration Complete!${colors.reset}`, 'green');
    print(`\n  Summary:`, 'cyan');
    print(`    • Integrated ${copiedCount} agents`, 'white');
    print(`    • Location: ${absoluteTargetDir}`, 'white');
    print(`    • Documentation: ${summaryPath}`, 'white');

    print(`\n  Next steps:`, 'yellow');
    print(`    1. Review the integrated agents in ${targetDir}`, 'white');
    print(`    2. Read AGENTS_INTEGRATED.md for usage instructions`, 'white');
    print(`    3. Configure your Claude Code settings if needed`, 'white');

  } catch (error) {
    stopLoading('Integration failed', false);
    print(`\n  ✗ Error: ${error.message}`, 'red');
  }

  await prompt('\n  Press Enter to continue...');
  return mainMenu();
}

function generateIntegrationSummary(agents, targetDir) {
  const timestamp = new Date().toISOString();

  let summary = `# Integrated Agent Prompts\n\n`;
  summary += `**Integration Date:** ${timestamp}\n`;
  summary += `**Location:** ${targetDir}\n`;
  summary += `**Total Agents:** ${agents.length}\n\n`;

  summary += `## Agents by Category\n\n`;

  const agentsByCategory = {};
  agents.forEach(agent => {
    if (!agentsByCategory[agent.category]) {
      agentsByCategory[agent.category] = [];
    }
    agentsByCategory[agent.category].push(agent);
  });

  Object.entries(agentsByCategory).forEach(([category, categoryAgents]) => {
    const catInfo = catalog.categories[category];
    summary += `### ${catInfo.icon} ${catInfo.name}\n\n`;

    categoryAgents.forEach(agent => {
      summary += `#### ${agent.name}\n\n`;
      summary += `- **Description:** ${agent.description}\n`;
      summary += `- **File:** \`${agent.file}\`\n`;
      summary += `- **Priority:** ${agent.priority}\n`;

      if (agent.capabilities && agent.capabilities.length > 0) {
        summary += `- **Capabilities:** ${agent.capabilities.join(', ')}\n`;
      }

      if (agent.useCase) {
        summary += `- **Use Case:** ${agent.useCase}\n`;
      }

      summary += `\n`;
    });
  });

  summary += `## Usage\n\n`;
  summary += `To use these agents with Claude Code:\n\n`;
  summary += `1. Ensure the agents are in your \`.claude/agents/\` directory\n`;
  summary += `2. Reference them in your prompts or slash commands\n`;
  summary += `3. Configure any required tools or hooks in \`.claude/settings.json\`\n\n`;

  summary += `## Documentation\n\n`;
  summary += `Each agent prompt file contains:\n`;
  summary += `- YAML frontmatter with metadata\n`;
  summary += `- Detailed instructions and responsibilities\n`;
  summary += `- Code examples and best practices\n`;
  summary += `- MCP tool integration patterns\n\n`;

  summary += `For more information, visit the agent-prompts library documentation.\n`;

  return summary;
}

async function generateIntegrationScript() {
  clear();
  header('⚡ Generate Integration Script');
  breadcrumb();

  print('  Generating shell script for integration...\n', 'cyan');

  const scriptPath = path.join(process.cwd(), 'integrate-agents.sh');

  let script = `#!/bin/bash\n\n`;
  script += `# Claude Agent Prompts Integration Script\n`;
  script += `# Generated: ${new Date().toISOString()}\n`;
  script += `# Agents: ${selectedAgents.length}\n\n`;

  script += `set -e\n\n`;
  script += `echo "🚀 Integrating ${selectedAgents.length} agent prompts..."\n\n`;

  script += `# Create directory structure\n`;
  script += `mkdir -p .claude/agents\n\n`;

  const categories = [...new Set(selectedAgents.map(a => a.category))];
  categories.forEach(cat => {
    script += `mkdir -p .claude/agents/${cat}\n`;
  });

  script += `\n# Copy agent files\n`;
  selectedAgents.forEach(agent => {
    const sourcePath = path.join(__dirname, agent.file);
    script += `echo "  Copying ${agent.name}..."\n`;
    script += `cp "${sourcePath}" .claude/agents/${agent.file}\n`;
  });

  script += `\necho ""\n`;
  script += `echo "✓ Integration complete!"\n`;
  script += `echo "  Location: .claude/agents/"\n`;
  script += `echo "  Agents: ${selectedAgents.length}"\n`;

  fs.writeFileSync(scriptPath, script);
  fs.chmodSync(scriptPath, '755');

  print(`  ✓ Script generated: ${scriptPath}`, 'green');
  print(`\n  To integrate, run:`, 'cyan');
  print(`    ./integrate-agents.sh\n`, 'yellow');

  await prompt('  Press Enter to continue...');
  return mainMenu();
}

async function quickPresets() {
  clear();
  breadcrumbs = ['Home', 'Quick Presets'];

  const presets = [
    {
      name: 'Full-Stack Development',
      icon: '🌐',
      description: 'Complete set for web application development',
      agents: ['coder', 'tester', 'reviewer', 'planner']
    },
    {
      name: 'GitHub Workflow',
      icon: '🐙',
      description: 'PR management, code review, and CI/CD',
      agents: ['pr-manager', 'code-review-swarm', 'issue-tracker', 'ci-cd-github']
    },
    {
      name: 'Code Quality Focus',
      icon: '✨',
      description: 'Testing, analysis, and optimization',
      agents: ['tester', 'reviewer', 'code-analyzer', 'performance-monitor']
    },
    {
      name: 'SPARC Methodology',
      icon: '⚡',
      description: 'Complete SPARC development workflow',
      agents: ['specification', 'pseudocode', 'architecture', 'refinement']
    },
    {
      name: 'Swarm Intelligence',
      icon: '🐝',
      description: 'Multi-agent coordination and hive-mind',
      agents: ['queen-coordinator', 'collective-intelligence-coordinator', 'hierarchical-coordinator']
    }
  ];

  const options = presets.map((preset, index) => ({
    label: preset.name,
    icon: preset.icon,
    color: 'cyan',
    description: `${preset.description} (${preset.agents.length} agents)`,
    preset: preset
  }));

  displayMenu('⚡ Quick Integration Presets', options);

  const choice = await prompt('Select a preset:');

  if (choice === '0') return mainMenu();
  if (choice === 'q' || choice === 'Q') process.exit(0);

  const index = parseInt(choice) - 1;
  if (index >= 0 && index < presets.length) {
    const preset = presets[index];

    // Select all agents in preset
    selectedAgents = [];
    Object.entries(catalog.categories).forEach(([categoryKey, category]) => {
      category.agents.forEach(agent => {
        if (preset.agents.includes(agent.name)) {
          selectedAgents.push({ ...agent, category: categoryKey });
        }
      });
    });

    print(`\n  ✓ Selected ${selectedAgents.length} agents from "${preset.name}" preset`, 'green');
    await new Promise(resolve => setTimeout(resolve, 1500));

    return integrateAgents();
  }

  print('  Invalid choice. Please try again.', 'red');
  await new Promise(resolve => setTimeout(resolve, 1500));
  return quickPresets();
}

async function showAbout() {
  clear();
  breadcrumbs = ['Home', 'About'];

  header('ℹ️  About Claude Agent Prompts Library');
  breadcrumb();

  print(`  ${colors.bright}${catalog.name}${colors.reset}`, 'cyan');
  print(`  Version: ${catalog.version} (Stable)`, 'white');
  print(`  Release Date: November 17, 2025`, 'dim');
  print(`\n  ${catalog.description}`, 'white');

  print(`\n  📊 Library Statistics:`, 'cyan');
  const totalAgents = Object.values(catalog.categories).reduce((sum, cat) => sum + cat.agents.length, 0);
  const totalCategories = Object.keys(catalog.categories).length;
  print(`    • ${totalCategories} categories`, 'white');
  print(`    • ${totalAgents} specialized agents`, 'white');
  print(`    • 76+ agent prompts`, 'white');
  print(`    • 27,000+ lines of prompts`, 'white');
  print(`    • 83 files total`, 'white');

  print(`\n  🎯 Key Features:`, 'cyan');
  print(`    • Organized by functional categories`, 'white');
  print(`    • Interactive browsing and search`, 'white');
  print(`    • Easy integration into any project`, 'white');
  print(`    • Pre-configured quick presets`, 'white');
  print(`    • Comprehensive documentation`, 'white');

  print(`\n  📦 Source:`, 'cyan');
  print(`    Based on claude-flow by ruvnet`, 'white');
  print(`    https://github.com/ruvnet/claude-flow`, 'dim');
  print(`\n  🎮 Curated & Integrated by:`, 'cyan');
  print(`    Fused Gaming`, 'white');
  print(`    https://github.com/Fused-Gaming/DevOps`, 'dim');

  print(`\n  📚 Documentation:`, 'cyan');
  print(`    • README.md - Complete documentation`, 'white');
  print(`    • QUICKSTART.md - 5-minute getting started`, 'white');
  print(`    • INTEGRATION_GUIDE.md - Developer guide`, 'white');
  print(`    • CHANGELOG.md - Version history`, 'white');
  print(`    • RELEASES.md - Official releases`, 'white');

  await prompt('\n  Press Enter to continue...');
  return mainMenu();
}

async function showSupport() {
  clear();
  breadcrumbs = ['Home', 'Support'];

  header('💝 Support This Project');
  breadcrumb();

  print(`  If you find this library helpful, consider supporting its development!\n`, 'white');

  print(`  ${colors.bright}Solana Donations:${colors.reset}`, 'magenta');
  print(`\n  Address:`, 'cyan');
  print(`  ${colors.bright}GMr9rXrFSt5H3xX1wi85vyCQfwwLsQpULwNEjrSghvRN${colors.reset}`, 'green');

  print(`\n  🔗 View on Solscan:`, 'cyan');
  print(`  https://solscan.io/account/GMr9rXrFSt5H3xX1wi85vyCQfwwLsQpULwNEjrSghvRN`, 'blue');

  print(`\n  💡 How to donate:`, 'cyan');
  print(`    1. Copy the Solana address above`, 'white');
  print(`    2. Open your Solana wallet (Phantom, Solflare, etc.)`, 'white');
  print(`    3. Send SOL or SPL tokens to the address`, 'white');
  print(`    4. View your transaction on Solscan!`, 'white');

  print(`\n  ${colors.bright}Your support helps:${colors.reset}`, 'yellow');
  print(`    • Maintain and improve this library`, 'white');
  print(`    • Add new agent prompts and features`, 'white');
  print(`    • Create better documentation`, 'white');
  print(`    • Support the open-source community`, 'white');

  print(`\n  Thank you for your support! 🙏`, 'green');

  await prompt('\n  Press Enter to continue...');
  return mainMenu();
}

// Main execution
async function main() {
  try {
    // Load catalog
    const catalogPath = path.join(__dirname, 'catalog.json');
    catalog = JSON.parse(fs.readFileSync(catalogPath, 'utf8'));

    // Show welcome screen
    clear();
    print(`
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                                                                           ║
    ║         🤖  CLAUDE AGENT PROMPTS INTEGRATION TOOL                        ║
    ║                          Version ${catalog.version}                                   ║
    ║                                                                           ║
    ║         Comprehensive library of 76+ specialized agent prompts           ║
    ║         Easy integration for any project                                 ║
    ║                                                                           ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
    `, 'cyan');

    await new Promise(resolve => setTimeout(resolve, 1500));

    // Start main menu
    await mainMenu();

  } catch (error) {
    print(`\n  ✗ Fatal error: ${error.message}`, 'red');
    console.error(error);
    process.exit(1);
  }
}

// Run the tool
if (require.main === module) {
  main();
}

module.exports = { main };
