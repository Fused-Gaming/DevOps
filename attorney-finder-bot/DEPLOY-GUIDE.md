# 🚀 Deployment Guide

Two ways to deploy: **Automated from GitHub** (recommended) or **Manual from local**.

## ⚡ Option 1: Automated Deployment (Recommended)

**One command - runs from anywhere!**

```bash
curl -fsSL https://raw.githubusercontent.com/Fused-Gaming/DevOps/main/attorney-finder-bot/deploy-from-github.sh | bash
```

Or download and run:

```bash
wget https://raw.githubusercontent.com/Fused-Gaming/DevOps/main/attorney-finder-bot/deploy-from-github.sh
chmod +x deploy-from-github.sh
./deploy-from-github.sh
```

### What it does:
1. ✅ Clones latest code from GitHub
2. ✅ Navigates to project directory
3. ✅ Verifies all files present
4. ✅ Prompts for bot token
5. ✅ Logs into Vercel
6. ✅ Links to your project (team-4eckd/dev-ops)
7. ✅ Deploys to production
8. ✅ Sets Telegram webhook
9. ✅ Cleans up temp files
10. ✅ Opens web app

**Zero manual steps required!**

---

## 📦 Option 2: Local Deployment

If you already have the code locally:

```bash
cd attorney-finder-bot
./deploy.sh
```

### Prerequisites:
- Code already cloned
- In correct directory
- .env file configured

---

## 🔧 Manual Setup (Step by Step)

If scripts don't work, here's the manual process:

### 1. Clone Repository
```bash
git clone https://github.com/Fused-Gaming/DevOps.git
cd DevOps/attorney-finder-bot
```

### 2. Install Vercel CLI
```bash
npm install -g vercel
```

### 3. Login to Vercel
```bash
vercel login
```

### 4. Link Project
```bash
vercel link --yes --scope team-4eckd --project dev-ops
```

### 5. Set Environment Variable
```bash
# Add your bot token
vercel env add TELEGRAM_BOT_TOKEN
# Paste token when prompted
```

### 6. Deploy
```bash
vercel --prod
```

### 7. Set Webhook
```bash
# Replace <TOKEN> and <URL>
curl -X POST "https://api.telegram.org/bot<TOKEN>/setWebhook?url=<URL>/api/webhook"
```

---

## 🎯 Quick Reference

| Method | Use When | Command |
|--------|----------|---------|
| **Auto from GitHub** | Fresh start, CI/CD | `curl ... \| bash` |
| **Local deploy** | You have code locally | `./deploy.sh` |
| **Manual** | Troubleshooting | Follow steps above |

---

## 🔍 Troubleshooting

### Script not found
```bash
# Make sure you're in the right repo
git clone https://github.com/Fused-Gaming/DevOps.git
cd DevOps/attorney-finder-bot
ls -la deploy*.sh
```

### Vercel CLI not installed
```bash
npm install -g vercel
# Or using yarn
yarn global add vercel
```

### Permission denied
```bash
chmod +x deploy-from-github.sh
chmod +x deploy.sh
```

### Wrong directory
```bash
# Always run from attorney-finder-bot/
cd /path/to/DevOps/attorney-finder-bot
pwd  # Should show: .../DevOps/attorney-finder-bot
```

### Vercel link fails
```bash
# Manually link
vercel link
# Choose:
# - Scope: team-4eckd
# - Project: dev-ops (or create new)
```

---

## 💡 Best Practices

1. **Use automated script** for consistent deployments
2. **Test locally first** with `./run.sh`
3. **Check logs** with `vercel logs`
4. **Monitor webhook** with Telegram's getWebhookInfo
5. **Keep token secret** - never commit to git

---

## 📚 More Info

- Full deployment docs: [VERCEL-DEPLOYMENT.md](VERCEL-DEPLOYMENT.md)
- Project README: [README.md](README.md)
- Quick start: [QUICKSTART.md](QUICKSTART.md)

---

**Need help?** Open an issue on GitHub or check Vercel logs.
