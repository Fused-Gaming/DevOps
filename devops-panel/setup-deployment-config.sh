#!/bin/bash

# DevOps Panel - Deployment Configuration Wizard
# Interactive setup for .env.deploy configuration

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  DevOps Panel - Deployment Configuration Wizard${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}This wizard will help you configure deployment settings for your preview servers.${NC}"
echo ""

# Check if .env.deploy already exists
if [ -f "$SCRIPT_DIR/.env.deploy" ]; then
    echo -e "${YELLOW}⚠️  .env.deploy already exists!${NC}"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Keeping existing configuration. Exiting.${NC}"
        exit 0
    fi
    echo ""
fi

# Function to read input with default value
read_with_default() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    if [ -n "$default" ]; then
        read -p "$(echo -e ${CYAN}$prompt${NC}) [${GREEN}$default${NC}]: " value
        value="${value:-$default}"
    else
        read -p "$(echo -e ${CYAN}$prompt${NC}): " value
    fi

    eval "$var_name='$value'"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION 1: Domain Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  Domain Configuration${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read_with_default "Top-level domain (e.g., vln.gg, example.com)" "vln.gg" TLD
echo ""

echo -e "${BLUE}Configure your subdomains:${NC}"
echo -e "${BLUE}(Press Enter to skip additional subdomains)${NC}"
echo ""

read_with_default "Subdomain 1 (e.g., preview, dev, staging)" "preview" SUB_DOMAIN1
read_with_default "Subdomain 2 (optional)" "dev" SUB_DOMAIN2
read_with_default "Subdomain 3 (optional)" "" SUB_DOMAIN3
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION 2: Server Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  Server Configuration${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read_with_default "Server IP address" "" SERVER_IP

# Validate IP format
if [[ ! $SERVER_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo -e "${YELLOW}⚠️  Warning: IP address format may be invalid${NC}"
fi
echo ""

read_with_default "SSH user" "root" SSH_USER
read_with_default "SSH port" "22" SSH_PORT
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION 3: SSH Key Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  SSH Key Configuration${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check for existing SSH keys
DEFAULT_KEY_PATH="$HOME/.ssh/id_rsa"
if [ -f "$DEFAULT_KEY_PATH" ]; then
    echo -e "${GREEN}✓ Found SSH key at: $DEFAULT_KEY_PATH${NC}"
    read_with_default "Path to your SSH private key" "$DEFAULT_KEY_PATH" SSH_PRIVATE_KEY
else
    echo -e "${YELLOW}⚠️  No SSH key found at $DEFAULT_KEY_PATH${NC}"
    echo ""
    read -p "Do you want to generate a new SSH key now? (Y/n): " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        KEY_PATH="$HOME/.ssh/id_rsa_devops"
        ssh-keygen -t ed25519 -f "$KEY_PATH" -C "devops-panel-deployment" -N ""
        echo -e "${GREEN}✓ SSH key generated at: $KEY_PATH${NC}"
        SSH_PRIVATE_KEY="$KEY_PATH"
        DEFAULT_KEY_PATH="$KEY_PATH"
    else
        read_with_default "Path to your SSH private key" "$HOME/.ssh/id_rsa" SSH_PRIVATE_KEY
    fi
fi
echo ""

# Get public key
if [ -f "${SSH_PRIVATE_KEY}.pub" ]; then
    DEFAULT_PUBLIC_KEY=$(cat "${SSH_PRIVATE_KEY}.pub")
    echo -e "${GREEN}✓ Found public key:${NC}"
    echo -e "${BLUE}$DEFAULT_PUBLIC_KEY${NC}"
    echo ""
    read -p "Use this public key for server access? (Y/n): " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        ROOT_SSH_KEY="$DEFAULT_PUBLIC_KEY"
    else
        echo ""
        echo -e "${CYAN}Paste your public SSH key:${NC}"
        read -r ROOT_SSH_KEY
    fi
elif [ -f "${SSH_PRIVATE_KEY/#\~/$HOME}.pub" ]; then
    EXPANDED_KEY="${SSH_PRIVATE_KEY/#\~/$HOME}.pub"
    DEFAULT_PUBLIC_KEY=$(cat "$EXPANDED_KEY")
    echo -e "${GREEN}✓ Found public key:${NC}"
    echo -e "${BLUE}$DEFAULT_PUBLIC_KEY${NC}"
    echo ""
    ROOT_SSH_KEY="$DEFAULT_PUBLIC_KEY"
else
    echo -e "${YELLOW}⚠️  Could not find public key file${NC}"
    echo -e "${CYAN}Paste your public SSH key (from ~/.ssh/id_rsa.pub):${NC}"
    read -r ROOT_SSH_KEY
fi
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION 4: Deployment Settings
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  Deployment Settings${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read_with_default "Default subdomain to deploy to" "SUB_DOMAIN1" DEFAULT_SUBDOMAIN
read_with_default "Base deployment path on server" "/var/www" DEPLOY_BASE_PATH
read_with_default "Node.js version" "18" NODE_VERSION
read_with_default "Base application port" "3000" BASE_APP_PORT
read_with_default "PM2 app name prefix" "devops-panel" PM2_APP_PREFIX
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Create .env.deploy file
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}→ Creating .env.deploy file...${NC}"

cat > "$SCRIPT_DIR/.env.deploy" << EOF
# Server Deployment Configuration
# Generated: $(date -u '+%Y-%m-%d %H:%M:%S UTC')
# SECURITY: This file is git-ignored - NEVER commit it to version control

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DOMAIN CONFIGURATION
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TLD=$TLD
SUB_DOMAIN1=$SUB_DOMAIN1
EOF

if [ -n "$SUB_DOMAIN2" ]; then
    echo "SUB_DOMAIN2=$SUB_DOMAIN2" >> "$SCRIPT_DIR/.env.deploy"
fi

if [ -n "$SUB_DOMAIN3" ]; then
    echo "SUB_DOMAIN3=$SUB_DOMAIN3" >> "$SCRIPT_DIR/.env.deploy"
fi

cat >> "$SCRIPT_DIR/.env.deploy" << EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SERVER CONFIGURATION
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SERVER_IP=$SERVER_IP
SSH_USER=$SSH_USER
SSH_PORT=$SSH_PORT
SSH_PRIVATE_KEY=$SSH_PRIVATE_KEY
ROOT_SSH_KEY=$ROOT_SSH_KEY

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DEPLOYMENT SETTINGS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DEFAULT_SUBDOMAIN=$DEFAULT_SUBDOMAIN
DEPLOY_BASE_PATH=$DEPLOY_BASE_PATH
NODE_VERSION=$NODE_VERSION
BASE_APP_PORT=$BASE_APP_PORT
PM2_APP_PREFIX=$PM2_APP_PREFIX
EOF

echo -e "${GREEN}✓ Configuration saved to .env.deploy${NC}"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Setup SSH Key on Server
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  SSH Key Setup${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "Do you want to automatically add your SSH key to the server? (Y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo ""
    echo -e "${YELLOW}→ Adding SSH key to $SSH_USER@$SERVER_IP...${NC}"
    echo -e "${BLUE}You may be prompted for the server password.${NC}"
    echo ""

    # Try ssh-copy-id first
    if command -v ssh-copy-id >/dev/null 2>&1; then
        ssh-copy-id -i "${SSH_PRIVATE_KEY}.pub" -p "$SSH_PORT" "$SSH_USER@$SERVER_IP" && \
            echo -e "${GREEN}✓ SSH key successfully added to server${NC}" || \
            echo -e "${RED}✗ Failed to add SSH key automatically${NC}"
    else
        # Manual method
        cat "${SSH_PRIVATE_KEY}.pub" | ssh -p "$SSH_PORT" "$SSH_USER@$SERVER_IP" \
            "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh" && \
            echo -e "${GREEN}✓ SSH key successfully added to server${NC}" || \
            echo -e "${RED}✗ Failed to add SSH key automatically${NC}"
    fi

    echo ""
    echo -e "${BLUE}Testing SSH connection...${NC}"
    if ssh -i "${SSH_PRIVATE_KEY/#\~/$HOME}" -p "$SSH_PORT" -o BatchMode=yes -o ConnectTimeout=5 "$SSH_USER@$SERVER_IP" "echo 'Connection successful'" 2>/dev/null; then
        echo -e "${GREEN}✓ SSH connection successful! No password required.${NC}"
    else
        echo -e "${YELLOW}⚠️  SSH connection test inconclusive. Try manually:${NC}"
        echo -e "${BLUE}  ssh -i $SSH_PRIVATE_KEY -p $SSH_PORT $SSH_USER@$SERVER_IP${NC}"
    fi
else
    echo ""
    echo -e "${BLUE}To manually add your SSH key to the server, run:${NC}"
    echo ""
    echo -e "${CYAN}  ssh-copy-id -i ${SSH_PRIVATE_KEY}.pub -p $SSH_PORT $SSH_USER@$SERVER_IP${NC}"
    echo ""
    echo -e "${BLUE}Or manually on the server:${NC}"
    echo ""
    echo -e "${CYAN}  mkdir -p ~/.ssh${NC}"
    echo -e "${CYAN}  echo '$ROOT_SSH_KEY' >> ~/.ssh/authorized_keys${NC}"
    echo -e "${CYAN}  chmod 600 ~/.ssh/authorized_keys${NC}"
    echo -e "${CYAN}  chmod 700 ~/.ssh${NC}"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Configuration Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Configuration Summary:${NC}"
echo -e "  Domain: ${GREEN}$SUB_DOMAIN1.$TLD${NC}"
echo -e "  Server: ${GREEN}$SSH_USER@$SERVER_IP:$SSH_PORT${NC}"
echo -e "  SSH Key: ${GREEN}$SSH_PRIVATE_KEY${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo -e "  1. Deploy to ${SUB_DOMAIN1}.$TLD:"
echo -e "     ${CYAN}./deploy-to-subdomain.sh SUB_DOMAIN1${NC}"
echo ""
echo -e "  2. Or use auto-deploy script:"
echo -e "     ${CYAN}./auto-deploy.sh${NC}"
echo -e "     ${BLUE}(Choose option 3 - Deploy to preview server)${NC}"
echo ""
echo -e "  3. Configure DNS A record:"
echo -e "     ${BLUE}Point $SUB_DOMAIN1.$TLD to $SERVER_IP${NC}"
echo ""
