# 🤖 Telegram Bot Templates

Quickly create production-ready Telegram bots with Vercel deployment built-in!

## ⚡ Quick Start

### Create a New Bot (One Command!)

```bash
./create-bot.sh my-awesome-bot YOUR_BOT_TOKEN
```

That's it! Your bot is ready to develop and deploy.

### Without Token (Add Later)

```bash
./create-bot.sh my-awesome-bot
# Then edit my-awesome-bot-bot/.env
```

## 📦 What You Get

Every bot created includes:

### ✨ Features
- **Polling Mode** - Local development with instant testing
- **Webhook Mode** - Production-ready Vercel deployment
- **One-Click Deploy** - Simple deployment scripts
- **Auto-Configuration** - Environment setup automated
- **Clean Structure** - Organized, maintainable code

### 📁 File Structure
```
your-bot-bot/
├── src/
│   ├── bot.py              # Local development (polling)
│   └── bot_handlers.py     # Your bot logic HERE
├── api/
│   └── webhook.py          # Production webhook (Vercel)
├── setup.sh               # Install dependencies
├── run.sh                 # Run locally
├── deploy-vercel.sh       # Deploy to Vercel
├── set-webhook.sh         # Configure Telegram webhook
├── vercel.json            # Vercel configuration
├── requirements.txt       # Python dependencies
├── .env                   # Your secrets (gitignored)
├── .env.example           # Template for others
├── .gitignore             # Protects secrets
└── README.md              # Bot-specific docs
```

## 🚀 Usage Workflow

### 1. Create Your Bot

```bash
cd telegram-bot-templates
./create-bot.sh customer-support 123456:ABC-DEF
```

### 2. Develop Locally

```bash
cd customer-support-bot
./setup.sh              # Install dependencies
./run.sh                # Start bot
# Test in Telegram!
```

### 3. Customize

Edit `src/bot_handlers.py`:

```python
async def start(update, context):
    await update.message.reply_text("Welcome to Customer Support!")

async def handle_message(update, context):
    # Your custom logic here
    user_message = update.message.text
    response = process_customer_query(user_message)
    await update.message.reply_text(response)
```

### 4. Deploy to Production

```bash
./deploy-vercel.sh                                    # Deploy
./set-webhook.sh https://customer-support.vercel.app  # Set webhook
# Bot is LIVE! 🎉
```

## 📚 Template Features

### Dual Mode Operation

**Polling Mode** (Local Dev):
- Instant feedback while developing
- No webhook configuration needed
- Perfect for testing
- Run with `./run.sh`

**Webhook Mode** (Production):
- Scales automatically with Vercel
- No server maintenance
- Free tier available
- Serverless architecture

### Built-In Scripts

| Script | Purpose |
|--------|---------|
| `setup.sh` | Install dependencies, create venv |
| `run.sh` | Start bot locally (polling mode) |
| `deploy-vercel.sh` | Deploy to Vercel |
| `set-webhook.sh` | Configure Telegram webhook |

### Security

- `.env` automatically gitignored
- Bot tokens never committed
- Environment-based configuration
- Vercel environment variables support

## 🎨 Examples

### Create Different Types of Bots

**Customer Support Bot:**
```bash
./create-bot.sh customer-support
```

**Notification Bot:**
```bash
./create-bot.sh notifications
```

**Data Collection Bot:**
```bash
./create-bot.sh survey-bot
```

**Admin Bot:**
```bash
./create-bot.sh admin-panel
```

## 🔧 Advanced Customization

### Add Database Support

Edit `requirements.txt`:
```
python-telegram-bot==20.7
python-dotenv==1.0.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
```

### Add External APIs

```python
# In bot_handlers.py
import requests

async def fetch_data(update, context):
    response = requests.get('https://api.example.com/data')
    data = response.json()
    await update.message.reply_text(f"Data: {data}")
```

### Add Inline Keyboards

```python
from telegram import InlineKeyboardButton, InlineKeyboardMarkup

async def start(update, context):
    keyboard = [
        [InlineKeyboardButton("Option 1", callback_data='1')],
        [InlineKeyboardButton("Option 2", callback_data='2')],
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.message.reply_text(
        'Choose an option:',
        reply_markup=reply_markup
    )
```

## 📊 Real-World Bot Examples

This template was used to create:

1. **Attorney Finder Bot** (`../attorney-finder-bot/`)
   - Web scraping
   - Database integration
   - Complex search logic

2. **More examples coming soon!**

## 🛠️ Requirements

### Local Development
- Python 3.8+
- pip
- virtualenv

### Deployment
- Vercel account (free tier OK)
- Vercel CLI: `npm install -g vercel`

## 🤝 Template Workflow Integration

### Use with Git

```bash
./create-bot.sh my-bot
cd my-bot-bot
git init
git add .
git commit -m "feat: initialize my-bot"
git remote add origin <your-repo>
git push -u origin main
```

### CI/CD with GitHub Actions

```yaml
name: Deploy Bot
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID}}
          vercel-project-id: ${{ secrets.PROJECT_ID}}
```

## 📖 Best Practices

1. **Always test locally first** - Use polling mode during development
2. **Keep tokens secret** - Never commit `.env` files
3. **Use environment variables** - Configure via `.env` and Vercel
4. **Version control** - Git track all code except secrets
5. **Document changes** - Update README for your specific bot

## 🐛 Troubleshooting

### Bot doesn't respond locally
```bash
# Check .env has valid token
cat .env | grep TELEGRAM_BOT_TOKEN

# Check bot is running
./run.sh
```

### Webhook not working
```bash
# Verify webhook is set
curl "https://api.telegram.org/bot<TOKEN>/getWebhookInfo"

# Reset webhook
./set-webhook.sh https://your-deployment.vercel.app
```

### Vercel deployment fails
```bash
# Check vercel.json is valid
cat vercel.json | python -m json.tool

# Check logs
vercel logs
```

## 💡 Pro Tips

1. **Use this template for all bots** - Consistent structure
2. **Keep handlers modular** - One function per command
3. **Test webhook locally** - Use ngrok for testing
4. **Monitor Vercel logs** - Check for errors
5. **Set usage limits** - Prevent abuse

## 🌟 Features Roadmap

- [ ] Database templates (SQLite, PostgreSQL)
- [ ] Authentication templates
- [ ] Payment integration examples
- [ ] Multi-language support template
- [ ] Admin panel template
- [ ] Analytics integration
- [ ] Rate limiting examples

## 📞 Support

Questions? Check:
- Template examples in this repo
- [python-telegram-bot docs](https://docs.python-telegram-bot.org/)
- [Vercel documentation](https://vercel.com/docs)

## 🎉 Quick Command Reference

```bash
# Create bot
./create-bot.sh <name> [token]

# In bot directory:
./setup.sh                    # Setup
./run.sh                      # Run locally
./deploy-vercel.sh            # Deploy
./set-webhook.sh <url>        # Set webhook

# Vercel commands:
vercel                        # Deploy (interactive)
vercel --prod                 # Deploy to production
vercel logs                   # View logs
vercel env add                # Add environment variable
```

---

**Happy Bot Building! 🤖**

*Part of the DevOps Arsenal - Making bot development fast and easy.*
