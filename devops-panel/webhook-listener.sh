#!/bin/bash

# DevOps Panel - GitHub Webhook Listener
# Automatically rebuilds and deploys when GitHub sends push notifications
#
# Setup:
#   1. Install webhook: npm install -g webhook
#   2. Configure GitHub webhook to point to: http://your-server:9000/hooks/devops-panel
#   3. Run this script: ./webhook-listener.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  DevOps Panel - Webhook Listener Setup${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check for webhook package
if ! command -v webhook >/dev/null 2>&1; then
    echo -e "${YELLOW}→ Installing webhook package...${NC}"
    npm install -g webhook
    echo -e "${GREEN}✓ webhook installed${NC}"
fi

# Create hooks.json configuration
cat > "$SCRIPT_DIR/hooks.json" << 'EOF'
[
  {
    "id": "devops-panel",
    "execute-command": "./deploy-on-push.sh",
    "command-working-directory": ".",
    "pass-arguments-to-command": [
      {
        "source": "payload",
        "name": "ref"
      },
      {
        "source": "payload",
        "name": "repository.name"
      },
      {
        "source": "payload",
        "name": "pusher.name"
      }
    ],
    "trigger-rule": {
      "and": [
        {
          "match": {
            "type": "payload-hash-sha1",
            "secret": "your-webhook-secret-here",
            "parameter": {
              "source": "header",
              "name": "X-Hub-Signature"
            }
          }
        },
        {
          "match": {
            "type": "value",
            "value": "refs/heads/main",
            "parameter": {
              "source": "payload",
              "name": "ref"
            }
          }
        }
      ]
    }
  }
]
EOF

# Create deployment script
cat > "$SCRIPT_DIR/deploy-on-push.sh" << 'EOFSCRIPT'
#!/bin/bash

# Auto-deploy script triggered by GitHub webhook

set -e

LOG_FILE="/var/log/devops-panel-deploy.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log "Deployment triggered by GitHub push"
log "Ref: $1"
log "Repository: $2"
log "Pusher: $3"

cd "$SCRIPT_DIR"

# Pull latest changes
log "Pulling latest changes..."
git pull origin main

# Install dependencies
log "Installing dependencies..."
pnpm install

# Build application
log "Building application..."
pnpm build

# Restart with PM2 (if using PM2)
if command -v pm2 >/dev/null 2>&1; then
    log "Restarting application with PM2..."
    pm2 restart devops-panel-preview || pm2 start ecosystem.config.js
else
    log "PM2 not found, skipping restart"
fi

log "Deployment complete!"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
EOFSCRIPT

chmod +x "$SCRIPT_DIR/deploy-on-push.sh"

echo -e "${GREEN}✓ Webhook configuration created${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  Setup Instructions${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}1. Edit hooks.json and set your webhook secret:${NC}"
echo "   nano $SCRIPT_DIR/hooks.json"
echo "   Replace 'your-webhook-secret-here' with a secure random string"
echo ""
echo -e "${BLUE}2. Start the webhook listener:${NC}"
echo "   webhook -hooks $SCRIPT_DIR/hooks.json -verbose -port 9000"
echo ""
echo -e "${BLUE}3. Or run as background service with PM2:${NC}"
echo "   pm2 start webhook -- -hooks $SCRIPT_DIR/hooks.json -verbose -port 9000"
echo "   pm2 save"
echo ""
echo -e "${BLUE}4. Configure GitHub webhook:${NC}"
echo "   - Go to: https://github.com/Fused-Gaming/DevOps/settings/hooks"
echo "   - Click 'Add webhook'"
echo "   - Payload URL: http://YOUR_SERVER_IP:9000/hooks/devops-panel"
echo "   - Content type: application/json"
echo "   - Secret: (same as in hooks.json)"
echo "   - Events: Just the push event"
echo ""
echo -e "${BLUE}5. Configure firewall to allow port 9000:${NC}"
echo "   sudo ufw allow 9000/tcp"
echo ""
echo -e "${GREEN}After setup, pushes to 'main' branch will automatically trigger deployment!${NC}"
echo ""
