# 🚀 Vercel Deployment Guide

Complete guide to deploying Attorney Finder Bot to Vercel with web UI and Telegram integration.

## ⚡ Quick Deploy

```bash
./deploy.sh
```

That's it! The script handles everything automatically.

## 📋 Prerequisites

1. **Vercel Account** - Free tier works fine
   - Sign up at https://vercel.com

2. **Vercel CLI**
   ```bash
   npm install -g vercel
   ```

3. **Telegram Bot Token**
   - Get from @BotFather
   - Already in your `.env` file

## 🏗️ What Gets Deployed

### Web UI (Public)
- **URL**: `https://your-deployment.vercel.app`
- **Features**:
  - Telegram login widget
  - Attorney search interface
  - Real-time database statistics
  - Mobile-responsive design

### API Routes
- `POST /api/webhook` - Telegram bot webhook
- `GET /api/web/search` - Attorney search API
- `POST /api/web/auth` - Telegram authentication
- `GET /api/web/stats` - Database statistics

### Bot Integration
- Webhook automatically configured
- Works with @LawmanRoBot
- Same database as web UI

## 📦 Deployment Steps

### Option 1: Automated (Recommended)

```bash
# One command deployment
./deploy.sh
```

The script will:
1. ✅ Check prerequisites
2. ✅ Build and prepare files
3. ✅ Deploy to Vercel
4. ✅ Set environment variables
5. ✅ Configure webhook
6. ✅ Test deployment

### Option 2: Manual

```bash
# 1. Build
./build.sh

# 2. Deploy
vercel --prod

# 3. Set environment variable
vercel env add TELEGRAM_BOT_TOKEN

# 4. Set webhook
./set-webhook.sh https://your-deployment.vercel.app
```

## 🔧 Configuration

### Environment Variables

Set in Vercel Dashboard or via CLI:

```bash
# Required
TELEGRAM_BOT_TOKEN=your_bot_token_here

# Optional (have defaults)
DATABASE_PATH=/tmp/attorneys.db
MAX_RESULTS_PER_SEARCH=50
SCRAPE_DELAY_SECONDS=2
```

### Vercel Dashboard

1. Go to https://vercel.com/dashboard
2. Select your project (team-4eckd/dev-ops)
3. Settings → Environment Variables
4. Add `TELEGRAM_BOT_TOKEN`

## 📱 Telegram Integration

### Web Login

The web UI uses Telegram Login Widget:

1. User clicks "Login with Telegram"
2. Authorizes via Telegram app
3. Returns to web UI (authenticated)
4. Can search attorneys

### Bot Commands

In Telegram (@LawmanRoBot):

```
/start - Welcome message
/search <query> - Search attorneys
/scrape <url> - Add attorney from URL
/stats - Database statistics
/help - Help message
```

## 🗄️ Database

### Important: Vercel Storage

Vercel uses **ephemeral storage** (`/tmp/`):
- Data persists during function execution
- **Resets on new deployments**
- Not suitable for production data

### Solutions:

#### Option 1: External Database (Recommended)

Use PostgreSQL or MySQL:

```bash
# Install psycopg2
pip install psycopg2-binary

# Update DATABASE_PATH in .env
DATABASE_PATH=postgresql://user:pass@host/db
```

#### Option 2: Vercel Postgres

```bash
# Install Vercel Postgres
vercel postgres create

# Link to project
vercel link

# Use connection string
```

#### Option 3: Temporary/Demo

Keep SQLite for testing:
- Data resets on deploy
- Good for demos
- Not for production

## 🧪 Testing

### Test Web UI

1. Visit: `https://your-deployment.vercel.app`
2. Click "Login with Telegram"
3. Authorize in Telegram
4. Try searching (if you have data)

### Test Telegram Bot

1. Open: https://t.me/LawmanRoBot
2. Send: `/start`
3. Try: `/stats`
4. Search: `94621 family law`

### Test Webhook

```bash
# Get webhook info
curl https://api.telegram.org/bot<TOKEN>/getWebhookInfo
```

Should show:
```json
{
  "ok": true,
  "result": {
    "url": "https://your-deployment.vercel.app/api/webhook",
    "has_custom_certificate": false,
    "pending_update_count": 0
  }
}
```

## 📊 Monitoring

### Vercel Dashboard

- **Functions**: See API calls and execution
- **Logs**: Real-time function logs
- **Analytics**: Traffic and performance

### Check Webhook

```bash
# Webhook status
curl https://api.telegram.org/bot<TOKEN>/getWebhookInfo | python3 -m json.tool
```

### Check Deployment

```bash
# List deployments
vercel ls

# View logs
vercel logs
```

## 🔄 Updates

### Redeploy

```bash
# Make changes, then:
./deploy.sh
```

### Rollback

```bash
# In Vercel dashboard:
# Deployments → Previous deployment → Promote to Production
```

## 🐛 Troubleshooting

### Webhook not working

```bash
# 1. Check webhook
curl https://api.telegram.org/bot<TOKEN>/getWebhookInfo

# 2. Reset webhook
./set-webhook.sh https://your-deployment.vercel.app

# 3. Test manually
curl -X POST https://your-deployment.vercel.app/api/webhook \
  -H "Content-Type: application/json" \
  -d '{"message":{"text":"test"}}'
```

### Web UI not loading

1. Check deployment succeeded: `vercel ls`
2. Check logs: `vercel logs`
3. Verify files: Check `public/` directory exists

### Telegram login fails

1. Check bot username in HTML (should be `LawmanRoBot`)
2. Verify domain is HTTPS
3. Check TELEGRAM_BOT_TOKEN is set in Vercel

### Database empty

Remember: SQLite resets on deploy!
- Use persistent database for production
- Or re-add data after each deploy

## 💡 Best Practices

1. **Use Environment Variables** - Never commit tokens
2. **Test Locally First** - Run `./run.sh` before deploying
3. **Check Logs** - Monitor Vercel logs for errors
4. **Persistent Database** - Use external DB for production
5. **Version Control** - Commit before deploying

## 📚 Resources

- **Vercel Docs**: https://vercel.com/docs
- **Telegram Bot API**: https://core.telegram.org/bots/api
- **Telegram Login**: https://core.telegram.org/widgets/login
- **python-telegram-bot**: https://docs.python-telegram-bot.org/

## 🔗 Links

- **Web App**: https://your-deployment.vercel.app
- **Telegram Bot**: https://t.me/LawmanRoBot
- **Vercel Dashboard**: https://vercel.com/team-4eckd/dev-ops
- **GitHub Repo**: https://github.com/Fused-Gaming/DevOps

## 🎯 Next Steps

After deployment:

1. ✅ Test web UI with Telegram login
2. ✅ Test bot in Telegram
3. ✅ Add attorneys: `/scrape <url>`
4. ✅ Test search on both platforms
5. ✅ Consider persistent database
6. ✅ Monitor usage and logs

---

**Need help?** Check logs with `vercel logs` or review this guide.
