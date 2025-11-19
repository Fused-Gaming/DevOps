# Preview Server Setup Guide

Complete guide for setting up `preview.vln.gg` on your VPS server.

## Prerequisites

- VPS server (Ubuntu 20.04+ / Debian 11+ recommended)
- Root or sudo access
- Domain `preview.vln.gg` pointing to server IP via DNS

## Initial Server Setup

### 1. Update System

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Required Software

```bash
# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt install -y nodejs

# Install build essentials
sudo apt install -y build-essential

# Install Nginx
sudo apt install -y nginx

# Install Certbot for SSL
sudo apt install -y certbot python3-certbot-nginx

# Install rsync (for deployment)
sudo apt install -y rsync

# Install PM2 globally
sudo npm install -g pm2 pnpm
```

### 3. Configure Firewall

```bash
# Allow SSH, HTTP, and HTTPS
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

## SSH Key Setup (Local Machine)

On your **local development machine**, set up SSH keys for automated deployment:

### Option 1: Use Existing SSH Key

If you already have an SSH key (`~/.ssh/id_rsa`), skip to step 3.

### Option 2: Generate New SSH Key

```bash
# Generate a new SSH key specifically for deployment
ssh-keygen -t ed25519 -f ~/.ssh/id_rsa_preview -C "devops-panel-preview"
```

### 3. Copy Public Key to Server

```bash
# Replace YOUR_SERVER_IP with your actual server IP
ssh-copy-id -i ~/.ssh/id_rsa_preview.pub root@YOUR_SERVER_IP

# Or manually:
cat ~/.ssh/id_rsa_preview.pub | ssh root@YOUR_SERVER_IP "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### 4. Test SSH Connection

```bash
ssh -i ~/.ssh/id_rsa_preview root@YOUR_SERVER_IP
```

## Server Configuration

### 1. Create Deployment Directory

```bash
sudo mkdir -p /var/www/devops-panel
sudo chown -R $USER:$USER /var/www/devops-panel
```

### 2. Configure Nginx

```bash
# Copy the nginx configuration
sudo nano /etc/nginx/sites-available/devops-panel-preview
```

Paste the contents from `nginx-preview.conf` (in this directory), then:

```bash
# Create symlink
sudo ln -s /etc/nginx/sites-available/devops-panel-preview /etc/nginx/sites-enabled/

# Remove default site (optional)
sudo rm /etc/nginx/sites-enabled/default

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

### 3. Set Up SSL Certificate

```bash
# Obtain SSL certificate from Let's Encrypt
sudo certbot --nginx -d preview.vln.gg

# Follow the prompts and select:
# - Redirect HTTP to HTTPS: Yes (recommended)
```

### 4. Configure Environment Variables

On the **server**, create the production environment file:

```bash
cd /var/www/devops-panel
nano .env.production
```

Add your production configuration:

```env
NODE_ENV=production
PORT=3000

# Authentication
DEVOPS_USERNAME=admin
DEVOPS_PASSWORD_HASH=your_bcrypt_hash_here

# Session Security
SESSION_SECRET=your_secure_32_character_session_secret

# GitHub Integration (Optional)
GITHUB_TOKEN=your_github_token
GITHUB_REPO=Fused-Gaming/DevOps

# Vercel Integration (Optional)
VERCEL_TOKEN=your_vercel_token
```

**Generate secure credentials:**

```bash
# Generate password hash
node -e "const bcrypt = require('bcryptjs'); console.log(bcrypt.hashSync('your_password', 10));"

# Generate session secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'));"
```

### 5. Set Up PM2 Auto-Start

```bash
# Configure PM2 to start on boot
pm2 startup systemd

# Run the command that PM2 outputs (it will be specific to your system)
# Example: sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER --hp /home/$USER
```

## Deploy from Local Machine

### 1. Configure Deployment Settings

On your **local machine**, in the `devops-panel` directory:

```bash
# Copy the example configuration
cp .env.deploy.example .env.deploy

# Edit with your server details
nano .env.deploy
```

Configure:

```env
PREVIEW_SERVER_HOST=YOUR_SERVER_IP  # Your actual server IP address
PREVIEW_SERVER_USER=root
PREVIEW_SERVER_PORT=22
PREVIEW_DEPLOY_PATH=/var/www/devops-panel
PREVIEW_DOMAIN=preview.vln.gg
PREVIEW_SSH_KEY=~/.ssh/id_rsa_preview  # Path to your SSH key
PREVIEW_APP_PORT=3000
```

### 2. Run Deployment

```bash
./deploy-preview.sh
```

The script will:
1. ✓ Build the Next.js application
2. ✓ Sync files to the server via rsync
3. ✓ Install dependencies on the server
4. ✓ Start/restart the application with PM2
5. ✓ Display status and management commands

## Verify Deployment

### 1. Check Application Status

```bash
# On the server
pm2 status
pm2 logs devops-panel-preview
```

### 2. Test in Browser

Visit: https://preview.vln.gg

### 3. Check Nginx Logs

```bash
# Access logs
sudo tail -f /var/log/nginx/devops-panel-preview-access.log

# Error logs
sudo tail -f /var/log/nginx/devops-panel-preview-error.log
```

## Server Management

### Application Management

```bash
# View logs
pm2 logs devops-panel-preview

# Restart application
pm2 restart devops-panel-preview

# Stop application
pm2 stop devops-panel-preview

# Start application
pm2 start devops-panel-preview

# View resource usage
pm2 monit
```

### Nginx Management

```bash
# Test configuration
sudo nginx -t

# Reload configuration
sudo systemctl reload nginx

# Restart Nginx
sudo systemctl restart nginx

# Check status
sudo systemctl status nginx
```

### SSL Certificate Renewal

Certbot auto-renews certificates. To test renewal:

```bash
sudo certbot renew --dry-run
```

## Troubleshooting

### Issue: Cannot Connect via SSH

**Solution:**
```bash
# Check SSH service
sudo systemctl status sshd

# Check firewall
sudo ufw status

# Verify authorized_keys permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### Issue: Application Not Starting

**Solution:**
```bash
# Check PM2 logs
pm2 logs devops-panel-preview --err

# Check Node.js version
node --version  # Should be 18+

# Reinstall dependencies
cd /var/www/devops-panel
pnpm install --prod
```

### Issue: 502 Bad Gateway

**Solution:**
```bash
# Check if application is running
pm2 status

# Check application logs
pm2 logs devops-panel-preview

# Verify port 3000 is listening
sudo netstat -tlnp | grep :3000

# Restart application
pm2 restart devops-panel-preview
```

### Issue: SSL Certificate Error

**Solution:**
```bash
# Renew certificate
sudo certbot renew

# Check certificate expiry
sudo certbot certificates

# Restart Nginx
sudo systemctl restart nginx
```

### Issue: Deployment Fails

**Solution:**
```bash
# Check SSH connectivity from local machine
ssh -i ~/.ssh/id_rsa_preview root@YOUR_SERVER_IP

# Verify rsync is installed on both machines
which rsync

# Check .env.deploy configuration
cat .env.deploy
```

## Security Best Practices

1. **Firewall**: Only allow necessary ports (22, 80, 443)
2. **SSH**: Disable password authentication, use keys only
3. **Updates**: Keep system packages updated
4. **Monitoring**: Set up uptime monitoring
5. **Backups**: Regular backups of `/var/www/devops-panel`
6. **Logs**: Monitor logs for suspicious activity
7. **Environment**: Never commit `.env.deploy` to git

## Disable Password SSH Authentication

After setting up SSH keys:

```bash
# On the server
sudo nano /etc/ssh/sshd_config

# Set these values:
PasswordAuthentication no
PubkeyAuthentication yes

# Restart SSH
sudo systemctl restart sshd
```

## Monitoring Setup (Optional)

### Install Netdata for Server Monitoring

```bash
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
```

Access at: `http://YOUR_SERVER_IP:19999`

### PM2 Monitoring

```bash
# Enable PM2 web dashboard
pm2 web
```

## Continuous Deployment

For automatic deployments on git push, see `deploy-production.sh` script options or set up GitHub Actions.

## Support

For issues with the deployment script or server setup:
1. Check the logs: `pm2 logs devops-panel-preview`
2. Review Nginx logs: `/var/log/nginx/`
3. Test deployment locally: `./deploy-preview.sh`
4. Verify DNS: `nslookup preview.vln.gg`

---

**Last Updated:** 2025-11-19
