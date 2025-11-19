#!/bin/bash

# DevOps Panel - Auto Deploy from GitHub
# Fetches latest code and automatically builds/starts the panel
#
# Usage:
#   # Interactive menu:
#   curl -fsSL https://github.com/Fused-Gaming/DevOps/raw/main/devops-panel/auto-deploy.sh | bash
#
#   # Auto-deploy to preview server:
#   curl -fsSL https://github.com/Fused-Gaming/DevOps/raw/main/devops-panel/auto-deploy.sh | AUTO_DEPLOY_MODE=preview bash
#
#   # Auto-deploy options: dev, build, preview, vercel

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  DevOps Panel - Auto Deploy from GitHub${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Configuration
REPO_URL="https://github.com/Fused-Gaming/DevOps.git"
BRANCH="${DEPLOY_BRANCH:-main}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/devops-panel}"
AUTO_START="${AUTO_START:-yes}"
AUTO_DEPLOY_MODE="${AUTO_DEPLOY_MODE:-}"  # Set to: dev, build, preview, vercel, or leave empty for menu

echo -e "${BLUE}Configuration:${NC}"
echo "  Repository: $REPO_URL"
echo "  Branch: $BRANCH"
echo "  Install Directory: $INSTALL_DIR"
echo ""

# Check prerequisites
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${YELLOW}→ Checking prerequisites...${NC}"

if ! command_exists git; then
    echo -e "${RED}✗ Git is not installed${NC}"
    echo -e "${YELLOW}→ Installing Git...${NC}"
    if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y git
    elif command_exists yum; then
        sudo yum install -y git
    else
        echo -e "${RED}Please install Git manually${NC}"
        exit 1
    fi
fi
echo -e "${GREEN}✓ Git installed${NC}"

if ! command_exists node; then
    echo -e "${YELLOW}→ Node.js not found, installing...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
    sudo apt-get install -y nodejs
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}✗ Node.js 18+ required (found: $(node -v))${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js $(node -v)${NC}"

echo ""

# Clone or update repository
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "${YELLOW}→ Updating existing installation...${NC}"
    cd "$INSTALL_DIR"
    git fetch origin
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
    echo -e "${GREEN}✓ Repository updated${NC}"
else
    echo -e "${YELLOW}→ Cloning repository...${NC}"
    git clone --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
    echo -e "${GREEN}✓ Repository cloned${NC}"
fi

cd "$INSTALL_DIR/devops-panel"

echo ""
echo -e "${YELLOW}→ Installing dependencies...${NC}"

# Install pnpm if not present
if ! command_exists pnpm; then
    npm install -g pnpm
fi

pnpm install

echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Ask what to do (or use AUTO_DEPLOY_MODE if set)
if [ -n "$AUTO_DEPLOY_MODE" ]; then
    case "$AUTO_DEPLOY_MODE" in
        dev|1)
            CHOICE=1
            echo -e "${BLUE}Auto-deploying: Development server${NC}"
            ;;
        build|2)
            CHOICE=2
            echo -e "${BLUE}Auto-deploying: Production build${NC}"
            ;;
        preview|3)
            CHOICE=3
            echo -e "${BLUE}Auto-deploying: Preview server (SSH)${NC}"
            ;;
        vercel|4)
            CHOICE=4
            echo -e "${BLUE}Auto-deploying: Vercel production${NC}"
            ;;
        *)
            echo -e "${RED}Invalid AUTO_DEPLOY_MODE: $AUTO_DEPLOY_MODE${NC}"
            echo -e "${YELLOW}Valid options: dev, build, preview, vercel${NC}"
            exit 1
            ;;
    esac
else
    echo -e "${YELLOW}What would you like to do?${NC}"
    echo "  1) Start development server (quick-start.sh)"
    echo "  2) Build for production"
    echo "  3) Deploy to preview server (SSH)"
    echo "  4) Deploy to Vercel production"
    echo "  5) Exit"
    echo ""
    read -p "Choice (1-5): " -n 1 -r CHOICE < /dev/tty
    echo ""
fi
echo ""

case $CHOICE in
    1)
        echo -e "${YELLOW}→ Starting development server...${NC}"
        if [ -f "./quick-start.sh" ]; then
            chmod +x ./quick-start.sh
            exec ./quick-start.sh
        else
            pnpm dev
        fi
        ;;
    2)
        echo -e "${YELLOW}→ Building for production...${NC}"
        pnpm build
        echo ""
        echo -e "${GREEN}✓ Build complete!${NC}"
        echo -e "${BLUE}To start production server: pnpm start${NC}"
        ;;
    3)
        echo -e "${YELLOW}→ Deploying to preview server...${NC}"
        if [ -f "./deploy-preview.sh" ]; then
            chmod +x ./deploy-preview.sh
            exec ./deploy-preview.sh
        else
            echo -e "${RED}deploy-preview.sh not found${NC}"
            exit 1
        fi
        ;;
    4)
        echo -e "${YELLOW}→ Deploying to Vercel...${NC}"
        if [ -f "./deploy-production.sh" ]; then
            chmod +x ./deploy-production.sh
            exec ./deploy-production.sh
        else
            echo -e "${RED}deploy-production.sh not found${NC}"
            exit 1
        fi
        ;;
    5)
        echo -e "${GREEN}Done! Files are in: $INSTALL_DIR/devops-panel${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac
