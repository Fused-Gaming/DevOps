# Subdomain Deployment Guide

Quick guide for deploying the DevOps Panel to multiple subdomains with a single command.

## Overview

This system allows you to deploy the DevOps Panel to any subdomain (preview.vln.gg, dev.vln.gg, staging.vln.gg, etc.) using environment variables and automated SSH key setup.

## Quick Start

### One-Command Setup & Deploy

```bash
# 1. Run configuration wizard
./setup-deployment-config.sh

# 2. Deploy to your first subdomain (e.g., preview.vln.gg)
./deploy-to-subdomain.sh SUB_DOMAIN1
```

That's it! Your panel is now running at https://preview.vln.gg 🎉

## Configuration File Structure

The `.env.deploy` file contains all deployment settings:

```env
# Domain Configuration
TLD=vln.gg                    # Your top-level domain
SUB_DOMAIN1=preview           # First subdomain (preview.vln.gg)
SUB_DOMAIN2=dev               # Second subdomain (dev.vln.gg)
SUB_DOMAIN3=staging           # Third subdomain (staging.vln.gg)

# Server Configuration
SERVER_IP=your.server.ip      # Your VPS IP address
SSH_USER=root                 # SSH username
SSH_PORT=22                   # SSH port
ROOT_SSH_KEY=ssh-rsa AAAA...  # Your PUBLIC SSH key

# Deployment Settings
DEFAULT_SUBDOMAIN=SUB_DOMAIN1 # Default deployment target
DEPLOY_BASE_PATH=/var/www     # Base path on server
NODE_VERSION=18               # Node.js version
BASE_APP_PORT=3000            # Starting port number
PM2_APP_PREFIX=devops-panel   # PM2 process name prefix
```

## Step-by-Step Setup

### Step 1: Run Configuration Wizard

```bash
cd devops-panel
./setup-deployment-config.sh
```

The wizard will prompt you for:

1. **Domain Configuration**
   - Top-level domain (e.g., vln.gg)
   - Subdomain names (preview, dev, staging, etc.)

2. **Server Configuration**
   - Server IP address
   - SSH user (default: root)
   - SSH port (default: 22)

3. **SSH Key Setup**
   - Automatically detects existing SSH keys
   - Offers to generate new key if needed
   - Can automatically add key to server

4. **Deployment Settings**
   - Default subdomain
   - Deployment paths
   - Node.js version
   - Port numbers

### Step 2: Verify Configuration

```bash
# View your configuration
cat .env.deploy

# Test SSH connection
ssh -i ~/.ssh/id_rsa root@YOUR_SERVER_IP
```

### Step 3: Deploy to Subdomain

```bash
# Deploy to preview.vln.gg (SUB_DOMAIN1)
./deploy-to-subdomain.sh SUB_DOMAIN1

# Deploy to dev.vln.gg (SUB_DOMAIN2)
./deploy-to-subdomain.sh SUB_DOMAIN2

# Deploy to staging.vln.gg (SUB_DOMAIN3)
./deploy-to-subdomain.sh SUB_DOMAIN3
```

## What Gets Deployed

Each subdomain gets its own:

- **Deployment directory**: `/var/www/preview-panel`, `/var/www/dev-panel`, etc.
- **Port number**: Auto-increments (3000, 3001, 3002, etc.)
- **PM2 process**: `devops-panel-preview`, `devops-panel-dev`, etc.
- **Domain**: `preview.vln.gg`, `dev.vln.gg`, etc.

## Deployment Process

When you run `./deploy-to-subdomain.sh SUB_DOMAIN1`, it:

1. ✓ Loads configuration from `.env.deploy`
2. ✓ Validates SSH connection to server
3. ✓ Builds Next.js application locally
4. ✓ Syncs files to server via rsync
5. ✓ Installs dependencies on server (pnpm)
6. ✓ Configures PM2 process manager
7. ✓ Starts/restarts the application
8. ✓ Shows status and management commands

## Managing Deployments

### View All Running Apps

```bash
ssh root@YOUR_SERVER_IP "pm2 status"
```

### View Logs for Specific Subdomain

```bash
# Preview logs
ssh root@YOUR_SERVER_IP "pm2 logs devops-panel-preview"

# Dev logs
ssh root@YOUR_SERVER_IP "pm2 logs devops-panel-dev"
```

### Restart Specific Subdomain

```bash
# Restart preview
ssh root@YOUR_SERVER_IP "pm2 restart devops-panel-preview"

# Restart dev
ssh root@YOUR_SERVER_IP "pm2 restart devops-panel-dev"
```

### Stop Specific Subdomain

```bash
ssh root@YOUR_SERVER_IP "pm2 stop devops-panel-preview"
```

## Advanced Configuration

### Custom Port for Specific Subdomain

Add to `.env.deploy`:

```env
SUB_DOMAIN2_PORT=3005        # Override port for dev.vln.gg
SUB_DOMAIN3_PORT=3010        # Override port for staging.vln.gg
```

### Custom Deploy Path

Add to `.env.deploy`:

```env
SUB_DOMAIN2_DEPLOY_PATH=/var/www/custom-dev-path
```

### Multiple Servers

Create multiple config files:

```bash
# Production server
cp .env.deploy .env.deploy.prod

# Staging server
cp .env.deploy .env.deploy.staging

# Deploy with specific config
source .env.deploy.prod && ./deploy-to-subdomain.sh SUB_DOMAIN1
```

## DNS Configuration

For each subdomain, configure DNS A records:

| Subdomain | Record Type | Name | Value |
|-----------|-------------|------|-------|
| preview.vln.gg | A | preview | YOUR_SERVER_IP |
| dev.vln.gg | A | dev | YOUR_SERVER_IP |
| staging.vln.gg | A | staging | YOUR_SERVER_IP |

## Nginx Configuration

Each subdomain needs a reverse proxy configuration.

### Quick Setup (All Subdomains)

```bash
# On your server
cd /etc/nginx/sites-available

# Create config for each subdomain
for subdomain in preview dev staging; do
  cat > devops-panel-$subdomain << EOF
server {
    listen 80;
    server_name $subdomain.vln.gg;

    location / {
        proxy_pass http://localhost:PORT;  # Use correct port
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

  # Enable site
  ln -s /etc/nginx/sites-available/devops-panel-$subdomain /etc/nginx/sites-enabled/
done

# Test and reload
nginx -t && systemctl reload nginx
```

### SSL with Let's Encrypt

```bash
# Install certbot
apt install certbot python3-certbot-nginx

# Get certificates for all subdomains
certbot --nginx -d preview.vln.gg -d dev.vln.gg -d staging.vln.gg
```

## Integration with Auto-Deploy

The auto-deploy script automatically uses this configuration:

```bash
# Run auto-deploy
curl -fsSL https://github.com/Fused-Gaming/DevOps/raw/main/devops-panel/auto-deploy.sh | bash

# Choose option 3 - Deploy to preview server
# If .env.deploy doesn't exist, it will automatically run the wizard
```

## Troubleshooting

### Configuration Not Found

**Error:** `.env.deploy` not found

**Solution:**
```bash
./setup-deployment-config.sh
```

### SSH Connection Failed

**Error:** SSH connection failed

**Solutions:**
1. Verify server IP: `ping YOUR_SERVER_IP`
2. Test SSH manually: `ssh -i ~/.ssh/id_rsa root@YOUR_SERVER_IP`
3. Check if key is on server: `ssh root@YOUR_SERVER_IP "cat ~/.ssh/authorized_keys"`
4. Re-run setup: `./setup-deployment-config.sh`

### Port Already in Use

**Error:** Port 3000 already in use

**Solution:** Override port in `.env.deploy`:
```env
SUB_DOMAIN1_PORT=3005
```

### PM2 Process Not Starting

**Error:** PM2 process failed to start

**Solution:**
```bash
# SSH to server
ssh root@YOUR_SERVER_IP

# Check PM2 logs
pm2 logs devops-panel-preview

# Restart PM2
pm2 restart devops-panel-preview
```

### DNS Not Resolving

**Error:** Can't access subdomain.vln.gg

**Solutions:**
1. Verify DNS records in your domain provider
2. Wait for DNS propagation (up to 48 hours)
3. Test with `dig preview.vln.gg` or `nslookup preview.vln.gg`
4. Check server firewall: `ufw status`

## Security Best Practices

### 1. Secure .env.deploy

```bash
# Never commit .env.deploy
echo ".env.deploy" >> .gitignore

# Set restrictive permissions
chmod 600 .env.deploy
```

### 2. Use SSH Keys (Not Passwords)

The setup wizard automatically configures SSH key authentication.

### 3. Firewall Configuration

```bash
# On server
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw enable
```

### 4. Regular Updates

```bash
# On server
apt update && apt upgrade -y
```

### 5. Environment Variables

Never commit production secrets. Set them on the server:

```bash
ssh root@YOUR_SERVER_IP
cd /var/www/preview-panel
nano .env.production
```

## Quick Reference

### Configuration
```bash
./setup-deployment-config.sh          # Run configuration wizard
cat .env.deploy                        # View configuration
nano .env.deploy                       # Edit configuration
```

### Deployment
```bash
./deploy-to-subdomain.sh SUB_DOMAIN1  # Deploy to preview.vln.gg
./deploy-to-subdomain.sh SUB_DOMAIN2  # Deploy to dev.vln.gg
./deploy-to-subdomain.sh SUB_DOMAIN3  # Deploy to staging.vln.gg
```

### Management
```bash
# View all apps
ssh root@SERVER_IP "pm2 status"

# View logs
ssh root@SERVER_IP "pm2 logs devops-panel-preview"

# Restart app
ssh root@SERVER_IP "pm2 restart devops-panel-preview"

# Stop app
ssh root@SERVER_IP "pm2 stop devops-panel-preview"
```

### DNS
```
A record: preview.vln.gg → YOUR_SERVER_IP
A record: dev.vln.gg → YOUR_SERVER_IP
A record: staging.vln.gg → YOUR_SERVER_IP
```

### SSL
```bash
certbot --nginx -d preview.vln.gg -d dev.vln.gg
```

## Example: Complete Setup

```bash
# 1. Clone repository
git clone https://github.com/Fused-Gaming/DevOps.git
cd DevOps/devops-panel

# 2. Run configuration wizard
./setup-deployment-config.sh
# Answer prompts...

# 3. Deploy to preview
./deploy-to-subdomain.sh SUB_DOMAIN1

# 4. Configure DNS
# Point preview.vln.gg to your server IP

# 5. Set up Nginx + SSL (on server)
ssh root@YOUR_SERVER_IP
# ... configure nginx ...
certbot --nginx -d preview.vln.gg

# 6. Access your panel
# Visit: https://preview.vln.gg
```

## Support

For issues:
1. Check logs: `ssh root@SERVER "pm2 logs app-name"`
2. Verify configuration: `cat .env.deploy`
3. Test SSH: `ssh -i ~/.ssh/id_rsa root@SERVER_IP`
4. Review [SERVER-SETUP.md](./SERVER-SETUP.md) for server configuration
5. See [QUICK-REFERENCE.md](./QUICK-REFERENCE.md) for command reference

---

**Last Updated:** 2025-11-19
