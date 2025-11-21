#!/bin/bash

# DevOps Panel - Production Deployment Script
# This script builds and deploys the panel to production

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
echo -e "${BLUE}  DevOps Control Panel - Production Deployment${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Navigate to panel directory
cd "$SCRIPT_DIR"

# Check for Vercel CLI
if ! command_exists vercel; then
    echo -e "${RED}✗ Vercel CLI is not installed${NC}"
    echo -e "${YELLOW}→ Installing Vercel CLI...${NC}"
    npm install -g vercel
    echo -e "${GREEN}✓ Vercel CLI installed${NC}"
fi

echo -e "${GREEN}✓ Vercel CLI detected${NC}"
echo ""

# Check package manager
PACKAGE_MANAGER=""
if command_exists pnpm; then
    PACKAGE_MANAGER="pnpm"
elif command_exists npm; then
    PACKAGE_MANAGER="npm"
else
    echo -e "${RED}✗ No package manager found${NC}"
    exit 1
fi

# Ask deployment type
echo -e "${YELLOW}Select deployment type:${NC}"
echo "  1) Deploy to production (--prod)"
echo "  2) Deploy to preview"
echo "  3) Just build locally"
echo ""
read -p "Choice (1/2/3): " -n 1 -r
echo ""
echo ""

case $REPLY in
    1)
        echo -e "${YELLOW}→ Deploying to production...${NC}"
        echo ""

        # Check if environment variables are set
        echo -e "${BLUE}Note: Make sure you've configured environment variables in Vercel:${NC}"
        echo -e "  - DEVOPS_USERNAME"
        echo -e "  - DEVOPS_PASSWORD_HASH (recommended) or DEVOPS_PASSWORD"
        echo -e "  - SESSION_SECRET"
        echo -e "  - GITHUB_TOKEN (optional)"
        echo -e "  - VERCEL_TOKEN (optional)"
        echo ""
        read -p "Press Enter to continue or Ctrl+C to cancel..."
        echo ""

        vercel --prod

        echo ""
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✓ Deployed to production!${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${BLUE}Next steps:${NC}"
        echo "  1. Add custom domain: vercel domains add dev.vln.gg"
        echo "  2. Configure DNS: CNAME dev -> cname.vercel-dns.com"
        echo "  3. Visit your deployment URL above"
        ;;
    2)
        echo -e "${YELLOW}→ Deploying to preview...${NC}"
        echo ""
        vercel

        echo ""
        echo -e "${GREEN}✓ Preview deployment complete!${NC}"
        ;;
    3)
        echo -e "${YELLOW}→ Building project locally...${NC}"
        echo ""

        # Check for .env
        if [ ! -f ".env" ]; then
            echo -e "${YELLOW}⚠️  No .env file found${NC}"
            echo -e "${BLUE}  Creating .env from .env.example...${NC}"
            cp .env.example .env
            echo -e "${YELLOW}  Please edit .env with your configuration${NC}"
        fi

        # Install dependencies
        echo -e "${YELLOW}→ Installing dependencies...${NC}"
        $PACKAGE_MANAGER install

        # Build
        echo -e "${YELLOW}→ Running build...${NC}"
        $PACKAGE_MANAGER run build

        echo ""
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✓ Build successful!${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${BLUE}To start production server locally:${NC}"
        echo "  $PACKAGE_MANAGER start"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
