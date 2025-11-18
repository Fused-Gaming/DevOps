#!/bin/bash

# Telegram Bot Generator Script
# Creates a new Telegram bot from template with Vercel deployment support

set -e

echo "🤖 Telegram Bot Generator"
echo "=========================="
echo ""

# Check if bot name was provided
if [ -z "$1" ]; then
    echo "Usage: ./create-bot.sh <bot-name> [bot-token]"
    echo ""
    echo "Example: ./create-bot.sh my-awesome-bot 123456:ABC-DEF..."
    echo ""
    exit 1
fi

BOT_NAME="$1"
BOT_TOKEN="${2:-}"
BOT_DIR="${BOT_NAME}-bot"

# Validate bot name (lowercase, hyphen-separated)
if [[ ! "$BOT_NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo "❌ Bot name must be lowercase letters, numbers, and hyphens only"
    echo "   Example: my-awesome-bot"
    exit 1
fi

# Check if directory already exists
if [ -d "$BOT_DIR" ]; then
    echo "❌ Directory '$BOT_DIR' already exists!"
    exit 1
fi

echo "📦 Creating bot: $BOT_NAME"
echo ""

# Create bot directory structure
echo "📁 Creating directory structure..."
mkdir -p "$BOT_DIR"/{src,api,.github/workflows}

# Copy base template files
echo "📋 Copying template files..."

# Create requirements.txt
cat > "$BOT_DIR/requirements.txt" <<'EOF'
python-telegram-bot==20.7
python-dotenv==1.0.0
EOF

# Create .gitignore
cat > "$BOT_DIR/.gitignore" <<'EOF'
# Environment
.env
*.db
*.sqlite

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
build/
dist/
*.egg-info/

# IDE
.vscode/
.idea/
*.swp
*.swo

# Logs
*.log

# Vercel
.vercel
EOF

# Create .env.example
cat > "$BOT_DIR/.env.example" <<EOF
# Telegram Bot Configuration
TELEGRAM_BOT_TOKEN=your_bot_token_here

# Vercel Deployment
VERCEL_URL=your-deployment-url.vercel.app
EOF

# Create .env with token if provided
if [ -n "$BOT_TOKEN" ]; then
    cat > "$BOT_DIR/.env" <<EOF
# Telegram Bot Configuration
TELEGRAM_BOT_TOKEN=$BOT_TOKEN

# Vercel Deployment
VERCEL_URL=
EOF
    echo "✅ Created .env with bot token"
else
    cp "$BOT_DIR/.env.example" "$BOT_DIR/.env"
    echo "⚠️  Remember to add your bot token to .env"
fi

# Create src/bot_handlers.py
cat > "$BOT_DIR/src/bot_handlers.py" <<'PYEOF'
"""
Bot command handlers.
"""
import os
from telegram import Update
from telegram.ext import (
    CommandHandler,
    MessageHandler,
    ContextTypes,
    filters,
    Application
)
from dotenv import load_dotenv

load_dotenv()


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Send welcome message."""
    welcome_message = """
🤖 *Welcome!*

This is your new Telegram bot!

*Commands:*
/start - Show this message
/help - Get help

Start customizing your bot by editing src/bot_handlers.py!
    """
    await update.message.reply_text(welcome_message, parse_mode='Markdown')


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Send help message."""
    help_text = """
📖 *Help*

Add your custom commands here!

Edit src/bot_handlers.py to customize this bot.
    """
    await update.message.reply_text(help_text, parse_mode='Markdown')


async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handle text messages."""
    text = update.message.text
    response = f"You said: {text}\n\nCustomize this in src/bot_handlers.py!"
    await update.message.reply_text(response)


async def error_handler(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handle errors."""
    print(f"Update {update} caused error {context.error}")


def setup_handlers(application: Application):
    """Setup all bot handlers."""
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("help", help_command))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    application.add_error_handler(error_handler)
PYEOF

# Create src/bot.py (polling mode)
cat > "$BOT_DIR/src/bot.py" <<'PYEOF'
"""
Telegram bot - Polling mode (for local development).
"""
import os
import logging
from telegram import Update
from telegram.ext import Application
from dotenv import load_dotenv

from bot_handlers import setup_handlers

load_dotenv()

logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)


def main():
    """Start the bot in polling mode."""
    token = os.getenv('TELEGRAM_BOT_TOKEN')
    if not token:
        raise ValueError("TELEGRAM_BOT_TOKEN not found in environment variables")

    application = Application.builder().token(token).build()
    setup_handlers(application)

    logger.info("Starting bot in polling mode...")
    application.run_polling(allowed_updates=Update.ALL_TYPES)


if __name__ == '__main__':
    main()
PYEOF

# Create api/webhook.py (Vercel function)
cat > "$BOT_DIR/api/webhook.py" <<'PYEOF'
"""
Vercel serverless function for Telegram webhook.
"""
import os
import json
import sys
from telegram import Update
from telegram.ext import Application
import asyncio

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from src.bot_handlers import setup_handlers

TOKEN = os.getenv('TELEGRAM_BOT_TOKEN')
if not TOKEN:
    raise ValueError("TELEGRAM_BOT_TOKEN not found")

application = Application.builder().token(TOKEN).build()
setup_handlers(application)


async def process_update(update_data):
    """Process a Telegram update."""
    try:
        update = Update.de_json(update_data, application.bot)
        await application.initialize()
        await application.process_update(update)
        return {"statusCode": 200, "body": "OK"}
    except Exception as e:
        print(f"Error: {e}")
        return {"statusCode": 500, "body": str(e)}


def handler(request):
    """Vercel request handler."""
    if request.method != 'POST':
        return {"statusCode": 405, "body": "Method Not Allowed"}

    try:
        body = request.body
        if isinstance(body, bytes):
            body = body.decode('utf-8')

        update_data = json.loads(body)
        result = asyncio.run(process_update(update_data))
        return result
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}
PYEOF

# Create vercel.json
cat > "$BOT_DIR/vercel.json" <<'EOF'
{
  "version": 2,
  "builds": [
    {
      "src": "api/webhook.py",
      "use": "@vercel/python"
    }
  ],
  "routes": [
    {
      "src": "/api/webhook",
      "dest": "api/webhook.py"
    }
  ],
  "env": {
    "TELEGRAM_BOT_TOKEN": "@telegram_bot_token"
  }
}
EOF

# Create setup scripts
cat > "$BOT_DIR/setup.sh" <<'SETUPEOF'
#!/bin/bash
set -e

echo "🤖 Bot Setup"
echo "============"
echo ""

echo "📦 Creating virtual environment..."
python3 -m venv venv

echo "🔌 Activating virtual environment..."
source venv/bin/activate

echo "📥 Installing dependencies..."
pip install --upgrade pip --quiet
pip install -r requirements.txt --quiet

echo "✅ Setup complete!"
echo ""
echo "To start the bot:"
echo "  ./run.sh"
echo ""
SETUPEOF

chmod +x "$BOT_DIR/setup.sh"

cat > "$BOT_DIR/run.sh" <<'RUNEOF'
#!/bin/bash
set -e

if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found! Run ./setup.sh first"
    exit 1
fi

source venv/bin/activate
echo "🚀 Starting bot..."
cd src
python bot.py
RUNEOF

chmod +x "$BOT_DIR/run.sh"

# Create deployment script
cat > "$BOT_DIR/deploy-vercel.sh" <<'DEPLOYEOF'
#!/bin/bash
set -e

echo "🚀 Deploying to Vercel"
echo "====================="
echo ""

# Check if vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found!"
    echo "   Install: npm install -g vercel"
    exit 1
fi

# Check if .env has token
if grep -q "your_bot_token_here" .env; then
    echo "❌ Please set TELEGRAM_BOT_TOKEN in .env first!"
    exit 1
fi

BOT_TOKEN=$(grep TELEGRAM_BOT_TOKEN .env | cut -d '=' -f2)

echo "📤 Deploying to Vercel..."
vercel --prod

echo ""
echo "✅ Deployed!"
echo ""
echo "Next steps:"
echo "1. Note your Vercel URL (e.g., https://your-bot.vercel.app)"
echo "2. Set webhook: ./set-webhook.sh <vercel-url>"
echo ""
DEPLOYEOF

chmod +x "$BOT_DIR/deploy-vercel.sh"

# Create webhook setup script
cat > "$BOT_DIR/set-webhook.sh" <<'WEBHOOKEOF'
#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: ./set-webhook.sh <vercel-url>"
    echo "Example: ./set-webhook.sh https://my-bot.vercel.app"
    exit 1
fi

VERCEL_URL="$1"
BOT_TOKEN=$(grep TELEGRAM_BOT_TOKEN .env | cut -d '=' -f2)

if [ -z "$BOT_TOKEN" ] || [ "$BOT_TOKEN" = "your_bot_token_here" ]; then
    echo "❌ TELEGRAM_BOT_TOKEN not set in .env!"
    exit 1
fi

WEBHOOK_URL="${VERCEL_URL}/api/webhook"

echo "🔗 Setting webhook to: $WEBHOOK_URL"
echo ""

RESPONSE=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/setWebhook?url=${WEBHOOK_URL}")

echo "$RESPONSE" | python3 -m json.tool

if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo ""
    echo "✅ Webhook set successfully!"

    # Update .env with Vercel URL
    sed -i "s|VERCEL_URL=.*|VERCEL_URL=$VERCEL_URL|" .env
else
    echo ""
    echo "❌ Failed to set webhook"
    exit 1
fi
WEBHOOKEOF

chmod +x "$BOT_DIR/set-webhook.sh"

# Create README
cat > "$BOT_DIR/README.md" <<README
# ${BOT_NAME} Bot

Telegram bot created with DevOps bot template.

## 🚀 Quick Start

### Local Development

\`\`\`bash
# 1. Setup
./setup.sh

# 2. Add your bot token to .env
# Edit .env and add your TELEGRAM_BOT_TOKEN

# 3. Run locally
./run.sh
\`\`\`

### Deploy to Vercel

\`\`\`bash
# 1. Deploy
./deploy-vercel.sh

# 2. Set webhook
./set-webhook.sh https://your-deployment.vercel.app
\`\`\`

## 📁 Structure

\`\`\`
${BOT_DIR}/
├── src/
│   ├── bot.py              # Polling mode (local dev)
│   └── bot_handlers.py     # Bot logic
├── api/
│   └── webhook.py          # Webhook mode (Vercel)
├── setup.sh               # Setup script
├── run.sh                 # Run locally
├── deploy-vercel.sh       # Deploy to Vercel
├── set-webhook.sh         # Set Telegram webhook
├── vercel.json            # Vercel config
└── requirements.txt       # Python dependencies
\`\`\`

## 🛠️ Customization

Edit \`src/bot_handlers.py\` to add your bot logic:

- \`start()\` - Welcome message
- \`help_command()\` - Help text
- \`handle_message()\` - Message handler
- Add new commands and features!

## 📚 Resources

- [python-telegram-bot docs](https://docs.python-telegram-bot.org/)
- [Vercel docs](https://vercel.com/docs)
- [Telegram Bot API](https://core.telegram.org/bots/api)

---

Created with DevOps Telegram Bot Template
README

echo ""
echo "✅ Bot created successfully!"
echo ""
echo "📁 Directory: $BOT_DIR"
echo ""
echo "Next steps:"
echo "  cd $BOT_DIR"
if [ -z "$BOT_TOKEN" ]; then
    echo "  # Add your bot token to .env"
fi
echo "  ./setup.sh"
echo "  ./run.sh"
echo ""
echo "To deploy to Vercel:"
echo "  ./deploy-vercel.sh"
echo "  ./set-webhook.sh <vercel-url>"
echo ""
