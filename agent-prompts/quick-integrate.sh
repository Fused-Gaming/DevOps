#!/bin/bash

###############################################################################
# Claude Agent Prompts - Quick Integration Script
# Quickly integrate pre-configured agent bundles into your project
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-$(pwd)}"
TARGET_DIR="${TARGET_DIR:-.claude/agents}"

# Presets configuration
declare -A PRESETS

PRESETS[fullstack]="core/coder.md core/tester.md core/reviewer.md core/planner.md"
PRESETS[github]="github/pr-manager.md github/code-review-swarm.md github/issue-tracker.md devops/ci-cd/ops-cicd-github.md"
PRESETS[quality]="core/tester.md core/reviewer.md analysis/code-analyzer.md optimization/performance-monitor.md"
PRESETS[sparc]="sparc/specification.md sparc/pseudocode.md sparc/architecture.md sparc/refinement.md"
PRESETS[swarm]="hive-mind/queen-coordinator.md hive-mind/collective-intelligence-coordinator.md swarm/hierarchical-coordinator.md"
PRESETS[minimal]="core/coder.md core/tester.md core/reviewer.md"
PRESETS[all]="core/*.md github/*.md hive-mind/*.md swarm/*.md sparc/*.md"

# Functions
print_header() {
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║                                                               ║${NC}"
    echo -e "${CYAN}${BOLD}║     🤖  CLAUDE AGENT PROMPTS - QUICK INTEGRATION             ║${NC}"
    echo -e "${CYAN}${BOLD}║                                                               ║${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

show_usage() {
    echo -e "Usage: $0 [preset] [options]\n"
    echo -e "${BOLD}Available Presets:${NC}"
    echo -e "  ${GREEN}fullstack${NC}   - Full-stack development (coder, tester, reviewer, planner)"
    echo -e "  ${GREEN}github${NC}      - GitHub workflow (pr-manager, code-review, issue-tracker, ci-cd)"
    echo -e "  ${GREEN}quality${NC}     - Code quality focus (tester, reviewer, analyzer, performance)"
    echo -e "  ${GREEN}sparc${NC}       - SPARC methodology (specification, pseudocode, architecture, refinement)"
    echo -e "  ${GREEN}swarm${NC}       - Swarm intelligence (queen, collective, hierarchical coordinators)"
    echo -e "  ${GREEN}minimal${NC}     - Essential agents only (coder, tester, reviewer)"
    echo -e "  ${GREEN}all${NC}         - All available agents"
    echo -e "\n${BOLD}Options:${NC}"
    echo -e "  ${CYAN}--target DIR${NC}      Target directory (default: .claude/agents)"
    echo -e "  ${CYAN}--project-root DIR${NC} Project root directory (default: current directory)"
    echo -e "  ${CYAN}--list${NC}            List all available agents"
    echo -e "  ${CYAN}--help${NC}            Show this help message"
    echo -e "\n${BOLD}Examples:${NC}"
    echo -e "  $0 fullstack                          # Integrate full-stack preset"
    echo -e "  $0 github --target my-agents          # Integrate to custom directory"
    echo -e "  $0 minimal --project-root /my/project # Integrate to specific project"
    echo -e ""
}

list_agents() {
    echo -e "${BOLD}${CYAN}Available Agents by Category:${NC}\n"

    for category in core github hive-mind swarm sparc optimization testing devops analysis; do
        if [ -d "$SCRIPT_DIR/$category" ]; then
            echo -e "${YELLOW}${category}:${NC}"
            find "$SCRIPT_DIR/$category" -name "*.md" -type f | while read -r file; do
                basename=$(basename "$file" .md)
                echo -e "  • $basename"
            done
            echo ""
        fi
    done
}

create_target_dir() {
    local target="$1"

    if [ ! -d "$target" ]; then
        print_info "Creating directory: $target"
        mkdir -p "$target"
        print_success "Directory created"
    else
        print_info "Using existing directory: $target"
    fi
}

copy_agents() {
    local preset="$1"
    local target="$2"
    local count=0
    local failed=0

    print_info "Integrating preset: ${BOLD}$preset${NC}\n"

    # Get files to copy
    local files="${PRESETS[$preset]}"

    if [ -z "$files" ]; then
        print_error "Unknown preset: $preset"
        return 1
    fi

    # Create target directory structure
    create_target_dir "$target"

    # Copy each file
    for pattern in $files; do
        for file in $SCRIPT_DIR/$pattern; do
            if [ -f "$file" ]; then
                # Get relative path
                rel_path="${file#$SCRIPT_DIR/}"
                target_file="$target/$rel_path"

                # Create subdirectory if needed
                target_subdir=$(dirname "$target_file")
                mkdir -p "$target_subdir"

                # Copy file
                if cp "$file" "$target_file" 2>/dev/null; then
                    agent_name=$(basename "$file" .md)
                    print_success "Integrated: ${CYAN}$agent_name${NC} ${DIM}→ $rel_path${NC}"
                    ((count++))
                else
                    print_error "Failed to copy: $file"
                    ((failed++))
                fi
            fi
        done
    done

    echo ""

    if [ $count -eq 0 ]; then
        print_error "No agents were integrated"
        return 1
    fi

    print_success "Successfully integrated ${BOLD}$count${NC} agents"

    if [ $failed -gt 0 ]; then
        print_warning "Failed to integrate $failed agents"
    fi

    return 0
}

create_integration_summary() {
    local preset="$1"
    local target="$2"
    local summary_file="$target/INTEGRATION_SUMMARY.md"

    cat > "$summary_file" << EOF
# Agent Integration Summary

**Date:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")
**Preset:** $preset
**Target:** $target

## Integrated Agents

EOF

    find "$target" -name "*.md" -not -name "*.SUMMARY.md" -type f | sort | while read -r file; do
        agent_name=$(basename "$file" .md)
        rel_path="${file#$target/}"
        echo "- **$agent_name** - \`$rel_path\`" >> "$summary_file"
    done

    cat >> "$summary_file" << EOF

## Usage

These agents are now available in your Claude Code environment.

### Quick Start

Reference agents in your prompts:
\`\`\`
Use the coder agent to implement user authentication
\`\`\`

### SPARC Workflow
\`\`\`
Follow SPARC methodology:
1. specification - Define requirements
2. pseudocode - Design algorithms
3. architecture - Plan structure
4. refinement - Implement with TDD
\`\`\`

### Swarm Coordination
\`\`\`
Coordinate with:
- queen-coordinator for orchestration
- worker-specialist for execution
- collective-intelligence for decisions
\`\`\`

## Documentation

Each agent file contains:
- YAML metadata (name, type, capabilities, priority)
- Detailed instructions
- Code examples
- MCP tool integration patterns

For more information, see the main README in the agent-prompts directory.
EOF

    print_success "Created integration summary: $summary_file"
}

# Main execution
main() {
    print_header

    # Parse arguments
    PRESET=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_usage
                exit 0
                ;;
            --list|-l)
                list_agents
                exit 0
                ;;
            --target)
                TARGET_DIR="$2"
                shift 2
                ;;
            --project-root)
                PROJECT_ROOT="$2"
                shift 2
                ;;
            *)
                if [ -z "$PRESET" ]; then
                    PRESET="$1"
                else
                    print_error "Unknown option: $1"
                    show_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done

    # Check if preset provided
    if [ -z "$PRESET" ]; then
        print_error "No preset specified"
        echo ""
        show_usage
        exit 1
    fi

    # Validate preset
    if [ -z "${PRESETS[$PRESET]}" ]; then
        print_error "Unknown preset: $PRESET"
        echo ""
        show_usage
        exit 1
    fi

    # Build target path
    if [[ "$TARGET_DIR" == /* ]]; then
        # Absolute path
        FULL_TARGET="$TARGET_DIR"
    else
        # Relative to project root
        FULL_TARGET="$PROJECT_ROOT/$TARGET_DIR"
    fi

    print_info "Project root: ${BOLD}$PROJECT_ROOT${NC}"
    print_info "Target directory: ${BOLD}$FULL_TARGET${NC}"
    echo ""

    # Perform integration
    if copy_agents "$PRESET" "$FULL_TARGET"; then
        echo ""
        create_integration_summary "$PRESET" "$FULL_TARGET"
        echo ""

        print_success "${BOLD}Integration Complete!${NC}"
        echo ""
        print_info "Next steps:"
        echo -e "  1. Review agents in ${CYAN}$FULL_TARGET${NC}"
        echo -e "  2. Read ${CYAN}$FULL_TARGET/INTEGRATION_SUMMARY.md${NC}"
        echo -e "  3. Start using agents in Claude Code!"
        echo ""

        exit 0
    else
        echo ""
        print_error "Integration failed"
        exit 1
    fi
}

# Run main function
main "$@"
