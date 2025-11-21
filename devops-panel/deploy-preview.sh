#!/bin/bash

# DevOps Panel - Preview Server Deployment Script
# Deploys to preview.vln.gg via SSH
#
# SECURITY: All sensitive values are loaded from environment variables

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
echo -e "${BLUE}  DevOps Control Panel - Preview Server Deployment${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Load environment variables from .env.deploy if it exists
if [ -f "$SCRIPT_DIR/.env.deploy" ]; then
    echo -e "${BLUE}→ Loading deployment configuration...${NC}"
    set -a
    source "$SCRIPT_DIR/.env.deploy"
    set +a
    echo -e "${GREEN}✓ Configuration loaded${NC}"
else
    echo -e "${YELLOW}⚠️  No .env.deploy file found${NC}"
    echo -e "${BLUE}Creating .env.deploy template...${NC}"

    cat > "$SCRIPT_DIR/.env.deploy" << 'EOF'
# Preview Server Deployment Configuration
# IMPORTANT: Keep this file secure and DO NOT commit to git

# SSH Configuration
PREVIEW_SERVER_HOST=your.server.ip.here
PREVIEW_SERVER_USER=root
PREVIEW_SERVER_PORT=22

# Deployment Paths
PREVIEW_DEPLOY_PATH=/var/www/devops-panel
PREVIEW_DOMAIN=preview.vln.gg

# SSH Key (optional - will use ~/.ssh/id_rsa by default)
# PREVIEW_SSH_KEY=~/.ssh/id_rsa_preview

# Node.js Configuration
PREVIEW_NODE_VERSION=18
PREVIEW_APP_PORT=3000

# PM2 Configuration (process manager)
PREVIEW_PM2_APP_NAME=devops-panel-preview
EOF

    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  Configuration file created: .env.deploy${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${RED}Please edit .env.deploy with your server details and run this script again.${NC}"
    echo ""
    echo -e "${BLUE}Required configuration:${NC}"
    echo "  - PREVIEW_SERVER_HOST: Your server IP address"
    echo "  - PREVIEW_SERVER_USER: SSH user (default: root)"
    echo "  - PREVIEW_DEPLOY_PATH: Deployment directory on server"
    echo ""
    exit 1
fi

# Validate required environment variables
REQUIRED_VARS=("PREVIEW_SERVER_HOST" "PREVIEW_SERVER_USER" "PREVIEW_DEPLOY_PATH" "PREVIEW_DOMAIN")
MISSING_VARS=()

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -ne 0 ]; then
    echo -e "${RED}✗ Missing required environment variables:${NC}"
    for var in "${MISSING_VARS[@]}"; do
        echo -e "  - $var"
    done
    echo ""
    echo -e "${YELLOW}Please edit .env.deploy and set all required variables.${NC}"
    exit 1
fi

# Set defaults
PREVIEW_SERVER_PORT=${PREVIEW_SERVER_PORT:-22}
PREVIEW_SSH_KEY=${PREVIEW_SSH_KEY:-~/.ssh/id_rsa}
PREVIEW_NODE_VERSION=${PREVIEW_NODE_VERSION:-18}
PREVIEW_APP_PORT=${PREVIEW_APP_PORT:-3000}
PREVIEW_PM2_APP_NAME=${PREVIEW_PM2_APP_NAME:-devops-panel-preview}

echo -e "${GREEN}✓ Configuration validated${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}→ Checking prerequisites...${NC}"

# Check for SSH
if ! command_exists ssh; then
    echo -e "${RED}✗ SSH is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ SSH available${NC}"

# Check for rsync
if ! command_exists rsync; then
    echo -e "${RED}✗ rsync is not installed${NC}"
    echo -e "${YELLOW}  Install with: apt-get install rsync (Debian/Ubuntu) or yum install rsync (RedHat/CentOS)${NC}"
    exit 1
fi
echo -e "${GREEN}✓ rsync available${NC}"

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
echo -e "${GREEN}✓ Package manager: $PACKAGE_MANAGER${NC}"

echo ""

# SSH Key Setup
echo -e "${YELLOW}→ Checking SSH key setup...${NC}"

SSH_KEY_EXPANDED="${PREVIEW_SSH_KEY/#\~/$HOME}"

if [ ! -f "$SSH_KEY_EXPANDED" ]; then
    echo -e "${YELLOW}⚠️  SSH key not found at: $SSH_KEY_EXPANDED${NC}"
    read -p "  Generate a new SSH key pair? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ssh-keygen -t ed25519 -f "$SSH_KEY_EXPANDED" -C "devops-panel-preview" -N ""
        echo -e "${GREEN}✓ SSH key generated${NC}"
        echo ""
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}  IMPORTANT: Add this public key to your server${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        cat "${SSH_KEY_EXPANDED}.pub"
        echo ""
        echo -e "${BLUE}Run this command on your server (${PREVIEW_SERVER_HOST}):${NC}"
        echo ""
        echo "  mkdir -p ~/.ssh"
        echo "  echo '$(cat ${SSH_KEY_EXPANDED}.pub)' >> ~/.ssh/authorized_keys"
        echo "  chmod 600 ~/.ssh/authorized_keys"
        echo "  chmod 700 ~/.ssh"
        echo ""
        read -p "Press Enter after you've added the key to continue..."
    else
        echo -e "${RED}Cannot proceed without SSH key. Exiting.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ SSH key found${NC}"

# Test SSH connection
echo -e "${YELLOW}→ Testing SSH connection...${NC}"

SSH_CMD="ssh -i $SSH_KEY_EXPANDED -p $PREVIEW_SERVER_PORT -o BatchMode=yes -o ConnectTimeout=10 $PREVIEW_SERVER_USER@$PREVIEW_SERVER_HOST"

if $SSH_CMD "echo 'Connection successful'" >/dev/null 2>&1; then
    echo -e "${GREEN}✓ SSH connection successful${NC}"
else
    echo -e "${RED}✗ SSH connection failed${NC}"
    echo ""
    echo -e "${YELLOW}Troubleshooting:${NC}"
    echo "  1. Verify server IP: $PREVIEW_SERVER_HOST"
    echo "  2. Verify SSH user: $PREVIEW_SERVER_USER"
    echo "  3. Verify port: $PREVIEW_SERVER_PORT"
    echo "  4. Ensure public key is added to server's ~/.ssh/authorized_keys"
    echo "  5. Test manually: ssh -i $SSH_KEY_EXPANDED -p $PREVIEW_SERVER_PORT $PREVIEW_SERVER_USER@$PREVIEW_SERVER_HOST"
    exit 1
fi

echo ""

# Navigate to panel directory
cd "$SCRIPT_DIR"

# Install dependencies
echo -e "${YELLOW}→ Installing dependencies...${NC}"
$PACKAGE_MANAGER install
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Build the application
echo -e "${YELLOW}→ Building application for production...${NC}"
NODE_ENV=production $PACKAGE_MANAGER run build
echo -e "${GREEN}✓ Build complete${NC}"
echo ""

# Create deployment package
echo -e "${YELLOW}→ Preparing deployment package...${NC}"

DEPLOY_TEMP="/tmp/devops-panel-deploy-$$"
mkdir -p "$DEPLOY_TEMP"

# Copy necessary files
cp -r .next "$DEPLOY_TEMP/"
cp -r public "$DEPLOY_TEMP/" 2>/dev/null || true
cp package.json "$DEPLOY_TEMP/"
cp pnpm-lock.yaml "$DEPLOY_TEMP/" 2>/dev/null || cp package-lock.json "$DEPLOY_TEMP/" 2>/dev/null || true
cp next.config.* "$DEPLOY_TEMP/" 2>/dev/null || true

# Create .env.production for the server
cat > "$DEPLOY_TEMP/.env.production" << EOF
NODE_ENV=production
PORT=$PREVIEW_APP_PORT
# Add your production environment variables here
# These should be configured separately on the server for security
EOF

echo -e "${GREEN}✓ Deployment package ready${NC}"
echo ""

# Deploy to server
echo -e "${YELLOW}→ Deploying to $PREVIEW_DOMAIN ($PREVIEW_SERVER_HOST)...${NC}"

# Create deployment directory on server
$SSH_CMD "mkdir -p $PREVIEW_DEPLOY_PATH"

# Sync files to server
rsync -avz --delete \
    -e "ssh -i $SSH_KEY_EXPANDED -p $PREVIEW_SERVER_PORT" \
    "$DEPLOY_TEMP/" \
    "$PREVIEW_SERVER_USER@$PREVIEW_SERVER_HOST:$PREVIEW_DEPLOY_PATH/"

echo -e "${GREEN}✓ Files synced to server${NC}"
echo ""

# Setup and restart application on server
echo -e "${YELLOW}→ Setting up application on server...${NC}"

$SSH_CMD bash << ENDSSH
set -e

cd $PREVIEW_DEPLOY_PATH

# Install Node.js if not present
if ! command -v node &> /dev/null; then
    echo "Installing Node.js $PREVIEW_NODE_VERSION..."
    curl -fsSL https://deb.nodesource.com/setup_${PREVIEW_NODE_VERSION}.x | bash -
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
    name: '$PREVIEW_PM2_APP_NAME',
    script: 'node_modules/.bin/next',
    args: 'start',
    cwd: '$PREVIEW_DEPLOY_PATH',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: $PREVIEW_APP_PORT
    }
  }]
};
EOFPM2

# Restart application with PM2
echo "Restarting application..."
pm2 delete $PREVIEW_PM2_APP_NAME 2>/dev/null || true
pm2 start ecosystem.config.js
pm2 save
pm2 startup | tail -1 | bash || true

echo "Application started successfully!"
ENDSSH

echo -e "${GREEN}✓ Application deployed and running${NC}"
echo ""

# Cleanup
rm -rf "$DEPLOY_TEMP"

# Final status check
echo -e "${YELLOW}→ Checking application status...${NC}"
echo ""

$SSH_CMD "pm2 status $PREVIEW_PM2_APP_NAME"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Application Info:${NC}"
echo "  Domain: https://$PREVIEW_DOMAIN"
echo "  Server: $PREVIEW_SERVER_HOST"
echo "  Port: $PREVIEW_APP_PORT"
echo "  Process: $PREVIEW_PM2_APP_NAME"
echo ""
echo -e "${BLUE}Server Management Commands:${NC}"
echo "  View logs:    ssh -i $SSH_KEY_EXPANDED $PREVIEW_SERVER_USER@$PREVIEW_SERVER_HOST 'pm2 logs $PREVIEW_PM2_APP_NAME'"
echo "  Restart app:  ssh -i $SSH_KEY_EXPANDED $PREVIEW_SERVER_USER@$PREVIEW_SERVER_HOST 'pm2 restart $PREVIEW_PM2_APP_NAME'"
echo "  Stop app:     ssh -i $SSH_KEY_EXPANDED $PREVIEW_SERVER_USER@$PREVIEW_SERVER_HOST 'pm2 stop $PREVIEW_PM2_APP_NAME'"
echo "  App status:   ssh -i $SSH_KEY_EXPANDED $PREVIEW_SERVER_USER@$PREVIEW_SERVER_HOST 'pm2 status'"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Configure Nginx/Apache reverse proxy for HTTPS"
echo "  2. Set up SSL certificate (Let's Encrypt recommended)"
echo "  3. Configure firewall to allow port $PREVIEW_APP_PORT"
echo "  4. Set production environment variables on server"
echo "  5. Test the deployment at https://$PREVIEW_DOMAIN"
echo ""
