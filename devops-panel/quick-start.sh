#!/bin/bash

# DevOps Panel Quick Start Script
# This script sets up and runs the DevOps Control Panel from scratch

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  DevOps Control Panel - Quick Start${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to generate random string
generate_secret() {
    node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
}

# Function to generate password hash
generate_password_hash() {
    local password="$1"
    node -e "const bcrypt = require('bcryptjs'); console.log(bcrypt.hashSync('$password', 10));"
}

# Step 1: Check Prerequisites
echo -e "${YELLOW}→ Checking prerequisites...${NC}"

if ! command_exists node; then
    echo -e "${RED}✗ Node.js is not installed${NC}"
    echo -e "${YELLOW}  Please install Node.js 18+ from https://nodejs.org/${NC}"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}✗ Node.js version must be 18 or higher (found: $(node -v))${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Node.js $(node -v) detected${NC}"

# Check for package manager
PACKAGE_MANAGER=""
if command_exists pnpm; then
    PACKAGE_MANAGER="pnpm"
    echo -e "${GREEN}✓ pnpm $(pnpm -v) detected${NC}"
elif command_exists npm; then
    PACKAGE_MANAGER="npm"
    echo -e "${GREEN}✓ npm $(npm -v) detected${NC}"
else
    echo -e "${RED}✗ No package manager found${NC}"
    echo -e "${YELLOW}  Installing pnpm...${NC}"
    npm install -g pnpm
    PACKAGE_MANAGER="pnpm"
fi

echo ""

# Step 2: Navigate to panel directory
cd "$SCRIPT_DIR"
echo -e "${YELLOW}→ Working directory: ${SCRIPT_DIR}${NC}"
echo ""

# Step 3: Install dependencies
echo -e "${YELLOW}→ Installing dependencies...${NC}"

if [ -d "node_modules" ] && [ -f "pnpm-lock.yaml" ]; then
    echo -e "${BLUE}  node_modules already exists, skipping installation${NC}"
    echo -e "${BLUE}  (Run '$PACKAGE_MANAGER install' manually if you need fresh install)${NC}"
else
    $PACKAGE_MANAGER install
    echo -e "${GREEN}✓ Dependencies installed${NC}"
fi

echo ""

# Step 4: Setup environment variables
echo -e "${YELLOW}→ Setting up environment variables...${NC}"

if [ -f ".env" ]; then
    echo -e "${BLUE}  .env file already exists${NC}"
    read -p "  Do you want to regenerate it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}  Keeping existing .env file${NC}"
        SKIP_ENV=true
    else
        rm .env
        SKIP_ENV=false
    fi
else
    SKIP_ENV=false
fi

if [ "$SKIP_ENV" = false ]; then
    echo -e "${BLUE}  Creating .env file...${NC}"

    # Prompt for username
    read -p "  Admin username (default: admin): " USERNAME
    USERNAME=${USERNAME:-admin}

    # Prompt for password
    read -s -p "  Admin password (default: changeme): " PASSWORD
    echo
    PASSWORD=${PASSWORD:-changeme}

    # Generate session secret
    echo -e "${BLUE}  Generating session secret...${NC}"
    SESSION_SECRET=$(generate_secret)

    # Ask if they want to use GitHub integration
    read -p "  Enable GitHub integration? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "  GitHub Personal Access Token: " GITHUB_TOKEN
        read -p "  GitHub Repository (default: Fused-Gaming/DevOps): " GITHUB_REPO
        GITHUB_REPO=${GITHUB_REPO:-Fused-Gaming/DevOps}
        ENABLE_GITHUB=true
    else
        ENABLE_GITHUB=false
    fi

    # Ask if they want to use Vercel integration
    read -p "  Enable Vercel integration? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "  Vercel Token: " VERCEL_TOKEN
        read -p "  Vercel Project ID (optional): " VERCEL_PROJECT_ID
        ENABLE_VERCEL=true
    else
        ENABLE_VERCEL=false
    fi

    # Create .env file
    cat > .env << EOF
# Authentication
DEVOPS_USERNAME=$USERNAME
DEVOPS_PASSWORD=$PASSWORD

# Session Security
SESSION_SECRET=$SESSION_SECRET

EOF

    if [ "$ENABLE_GITHUB" = true ]; then
        cat >> .env << EOF
# GitHub Integration
GITHUB_TOKEN=$GITHUB_TOKEN
GITHUB_REPO=$GITHUB_REPO

EOF
    fi

    if [ "$ENABLE_VERCEL" = true ]; then
        cat >> .env << EOF
# Vercel Integration
VERCEL_TOKEN=$VERCEL_TOKEN
EOF
        if [ -n "$VERCEL_PROJECT_ID" ]; then
            echo "VERCEL_PROJECT_ID=$VERCEL_PROJECT_ID" >> .env
        fi
        echo "" >> .env
    fi

    cat >> .env << EOF
# DevOps Scripts
DEVOPS_SCRIPTS_PATH=$SCRIPT_DIR/../scripts

# Application
NODE_ENV=development
EOF

    echo -e "${GREEN}✓ .env file created${NC}"
fi

echo ""

# Step 5: Build check (optional for dev)
echo -e "${YELLOW}→ Checking build configuration...${NC}"
echo -e "${BLUE}  Skipping build for development mode${NC}"
echo -e "${BLUE}  (Run '$PACKAGE_MANAGER run build' to test production build)${NC}"
echo ""

# Step 6: Start development server
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Setup complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Configuration Summary:${NC}"
echo -e "  Username: ${USERNAME:-admin}"
echo -e "  Password: ********"
echo -e "  Panel URL: ${GREEN}http://localhost:3000${NC}"
echo ""
echo -e "${YELLOW}→ Starting development server...${NC}"
echo ""

# Start the dev server
exec $PACKAGE_MANAGER run dev
