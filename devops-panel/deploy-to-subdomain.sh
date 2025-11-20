#!/bin/bash

# DevOps Panel - Deploy to Any Subdomain
# Quick deployment to any configured subdomain with one command
#
# Usage:
#   ./deploy-to-subdomain.sh SUB_DOMAIN1    # Deploy to preview.vln.gg
#   ./deploy-to-subdomain.sh SUB_DOMAIN2    # Deploy to dev.vln.gg
#   ./deploy-to-subdomain.sh SUB_DOMAIN3    # Deploy to staging.vln.gg

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Load Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [ ! -f "$SCRIPT_DIR/.env.deploy" ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}  Configuration Error${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${RED}✗ Configuration file not found: .env.deploy${NC}"
    echo ""
    echo -e "${YELLOW}The deployment configuration is missing. You need to run the setup wizard first.${NC}"
    echo ""
    echo -e "${BLUE}Option 1: Run the configuration wizard (Recommended)${NC}"
    echo -e "${CYAN}  cd $SCRIPT_DIR${NC}"
    echo -e "${CYAN}  ./setup-deployment-config.sh${NC}"
    echo ""
    echo -e "${BLUE}Option 2: Copy and edit the example file manually${NC}"
    echo -e "${CYAN}  cd $SCRIPT_DIR${NC}"
    echo -e "${CYAN}  cp .env.deploy.example .env.deploy${NC}"
    echo -e "${CYAN}  nano .env.deploy${NC}"
    echo ""
    echo -e "${BLUE}Required configuration:${NC}"
    echo "  - TLD (e.g., vln.gg)"
    echo "  - SUB_DOMAIN1 (e.g., preview)"
    echo "  - SERVER_IP (your server IP address)"
    echo "  - SSH_USER (default: root)"
    echo "  - ROOT_SSH_KEY (your public SSH key)"
    echo ""
    exit 1
fi

# Load environment variables
echo -e "${YELLOW}→ Loading configuration from .env.deploy...${NC}"
set -a
source "$SCRIPT_DIR/.env.deploy"
set +a
echo -e "${GREEN}✓ Configuration loaded${NC}"
echo ""

# Validate required variables
REQUIRED_VARS=("TLD" "SERVER_IP" "SSH_USER" "DEPLOY_BASE_PATH")
MISSING_VARS=()

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -ne 0 ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}  Configuration Error${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${RED}✗ Missing required variables in .env.deploy:${NC}"
    for var in "${MISSING_VARS[@]}"; do
        echo -e "  ${YELLOW}- $var${NC}"
    done
    echo ""
    echo -e "${YELLOW}Please run the configuration wizard to fix this:${NC}"
    echo -e "${CYAN}  ./setup-deployment-config.sh${NC}"
    echo ""
    echo -e "${BLUE}Or manually edit .env.deploy and add the missing variables.${NC}"
    echo ""
    exit 1
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Parse Subdomain Argument
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SUBDOMAIN_VAR="${1:-$DEFAULT_SUBDOMAIN}"

# Get the actual subdomain value
if [ -z "${!SUBDOMAIN_VAR}" ]; then
    echo -e "${RED}✗ Subdomain not configured: $SUBDOMAIN_VAR${NC}"
    echo ""
    echo -e "${BLUE}Available subdomains:${NC}"
    for var in $(compgen -v | grep "^SUB_DOMAIN"); do
        if [ -n "${!var}" ]; then
            echo -e "  ${GREEN}$var${NC} = ${!var}.$TLD"
        fi
    done
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  ./deploy-to-subdomain.sh SUB_DOMAIN1"
    echo -e "  ./deploy-to-subdomain.sh SUB_DOMAIN2"
    echo ""
    exit 1
fi

SUBDOMAIN="${!SUBDOMAIN_VAR}"
FULL_DOMAIN="$SUBDOMAIN.$TLD"

# Calculate deployment settings
DEPLOY_PATH="$DEPLOY_BASE_PATH/$SUBDOMAIN-panel"
PM2_APP_NAME="$PM2_APP_PREFIX-$SUBDOMAIN"

# Auto-increment port based on subdomain number
if [[ $SUBDOMAIN_VAR =~ SUB_DOMAIN([0-9]+) ]]; then
    SUBDOMAIN_NUM="${BASH_REMATCH[1]}"
    APP_PORT=$((BASE_APP_PORT + SUBDOMAIN_NUM - 1))
else
    APP_PORT=$BASE_APP_PORT
fi

# Check for subdomain-specific overrides
OVERRIDE_PORT="${SUBDOMAIN_VAR}_PORT"
OVERRIDE_PATH="${SUBDOMAIN_VAR}_DEPLOY_PATH"

if [ -n "${!OVERRIDE_PORT}" ]; then
    APP_PORT="${!OVERRIDE_PORT}"
fi

if [ -n "${!OVERRIDE_PATH}" ]; then
    DEPLOY_PATH="${!OVERRIDE_PATH}"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Display Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  DevOps Panel - Deploy to $FULL_DOMAIN${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Deployment Configuration:${NC}"
echo -e "  Domain:       ${GREEN}https://$FULL_DOMAIN${NC}"
echo -e "  Server:       ${GREEN}$SSH_USER@$SERVER_IP:$SSH_PORT${NC}"
echo -e "  Deploy Path:  ${GREEN}$DEPLOY_PATH${NC}"
echo -e "  App Port:     ${GREEN}$APP_PORT${NC}"
echo -e "  PM2 Name:     ${GREEN}$PM2_APP_NAME${NC}"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Check SSH Connection
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SSH_KEY_EXPANDED="${SSH_PRIVATE_KEY/#\~/$HOME}"
SSH_CMD="ssh -i $SSH_KEY_EXPANDED -p $SSH_PORT -o BatchMode=yes -o ConnectTimeout=10 $SSH_USER@$SERVER_IP"

echo -e "${YELLOW}→ Testing SSH connection...${NC}"

if $SSH_CMD "echo 'Connection successful'" >/dev/null 2>&1; then
    echo -e "${GREEN}✓ SSH connection successful${NC}"
else
    echo -e "${RED}✗ SSH connection failed${NC}"
    echo ""
    echo -e "${YELLOW}Troubleshooting:${NC}"
    echo -e "  1. Verify server IP: $SERVER_IP"
    echo -e "  2. Verify SSH user: $SSH_USER"
    echo -e "  3. Verify port: $SSH_PORT"
    echo -e "  4. Ensure public key is added to server's ~/.ssh/authorized_keys"
    echo -e "  5. Test manually: ${CYAN}ssh -i $SSH_PRIVATE_KEY -p $SSH_PORT $SSH_USER@$SERVER_IP${NC}"
    echo ""
    exit 1
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Check Prerequisites
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${YELLOW}→ Checking prerequisites...${NC}"

if ! command_exists rsync; then
    echo -e "${RED}✗ rsync is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ rsync available${NC}"

PACKAGE_MANAGER=""
if command_exists pnpm; then
    PACKAGE_MANAGER="pnpm"
elif command_exists npm; then
    PACKAGE_MANAGER="npm"
else
    echo -e "${RED}✗ No package manager found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Package manager: $PACKAGE_MANAGER${NC}"

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Build Application
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

cd "$SCRIPT_DIR"

echo -e "${YELLOW}→ Installing dependencies...${NC}"
$PACKAGE_MANAGER install
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

echo -e "${YELLOW}→ Building application for production...${NC}"
NODE_ENV=production $PACKAGE_MANAGER run build
echo -e "${GREEN}✓ Build complete${NC}"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Prepare Deployment Package
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}→ Preparing deployment package...${NC}"

DEPLOY_TEMP="/tmp/devops-panel-deploy-$$"
mkdir -p "$DEPLOY_TEMP"

cp -r .next "$DEPLOY_TEMP/"
cp -r public "$DEPLOY_TEMP/" 2>/dev/null || true
cp package.json "$DEPLOY_TEMP/"
cp pnpm-lock.yaml "$DEPLOY_TEMP/" 2>/dev/null || cp package-lock.json "$DEPLOY_TEMP/" 2>/dev/null || true
cp next.config.* "$DEPLOY_TEMP/" 2>/dev/null || true

echo -e "${GREEN}✓ Deployment package ready${NC}"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Deploy to Server
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}→ Deploying to $FULL_DOMAIN ($SERVER_IP)...${NC}"

# Create deployment directory on server
$SSH_CMD "mkdir -p $DEPLOY_PATH"

# Sync files to server
rsync -avz --delete \
    -e "ssh -i $SSH_KEY_EXPANDED -p $SSH_PORT" \
    "$DEPLOY_TEMP/" \
    "$SSH_USER@$SERVER_IP:$DEPLOY_PATH/"

echo -e "${GREEN}✓ Files synced to server${NC}"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Setup and Start Application
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}→ Setting up application on server...${NC}"

$SSH_CMD bash << ENDSSH
set -e

cd $DEPLOY_PATH

# Install Node.js if not present
if ! command -v node &> /dev/null; then
    echo "Installing Node.js $NODE_VERSION..."
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
    apt-get install -y nodejs
fi

# Install pnpm if not present
if ! command -v pnpm &> /dev/null; then
    echo "Installing pnpm..."
    npm install -g pnpm
fi

# Install PM2 if not present
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2..."
    npm install -g pm2
fi

# Install production dependencies
echo "Installing dependencies..."
pnpm install --prod

# Create PM2 ecosystem file
cat > ecosystem.config.js << 'EOFPM2'
module.exports = {
  apps: [{
    name: '$PM2_APP_NAME',
    script: 'node_modules/.bin/next',
    args: 'start',
    cwd: '$DEPLOY_PATH',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: $APP_PORT
    }
  }]
};
EOFPM2

# Restart application with PM2
echo "Restarting application..."
pm2 delete $PM2_APP_NAME 2>/dev/null || true
pm2 start ecosystem.config.js
pm2 save
pm2 startup | tail -1 | bash || true

echo "Application started successfully!"
ENDSSH

echo -e "${GREEN}✓ Application deployed and running${NC}"
echo ""

# Cleanup
rm -rf "$DEPLOY_TEMP"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Final Status
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}→ Checking application status...${NC}"
echo ""

$SSH_CMD "pm2 status $PM2_APP_NAME"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Application Info:${NC}"
echo "  Domain:       https://$FULL_DOMAIN"
echo "  Server:       $SERVER_IP:$APP_PORT"
echo "  Process:      $PM2_APP_NAME"
echo "  Deploy Path:  $DEPLOY_PATH"
echo ""
echo -e "${BLUE}Server Management:${NC}"
echo "  View logs:    ssh -i $SSH_PRIVATE_KEY $SSH_USER@$SERVER_IP 'pm2 logs $PM2_APP_NAME'"
echo "  Restart app:  ssh -i $SSH_PRIVATE_KEY $SSH_USER@$SERVER_IP 'pm2 restart $PM2_APP_NAME'"
echo "  Stop app:     ssh -i $SSH_PRIVATE_KEY $SSH_USER@$SERVER_IP 'pm2 stop $PM2_APP_NAME'"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Configure DNS A record: Point $SUBDOMAIN.$TLD to $SERVER_IP"
echo "  2. Set up Nginx reverse proxy (see SERVER-SETUP.md)"
echo "  3. Configure SSL with Let's Encrypt"
echo "  4. Set production environment variables on server"
echo "  5. Test the deployment at https://$FULL_DOMAIN"
echo ""
