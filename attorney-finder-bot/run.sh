#!/bin/bash

# Attorney Finder Bot Run Script
# Starts the Telegram bot

set -e

echo "🏛️  Starting Attorney Finder Bot..."
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "   Run ./setup.sh first"
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "   Run ./setup.sh first"
    exit 1
fi

# Check if bot token is set
if grep -q "your_bot_token_here" .env; then
    echo "❌ TELEGRAM_BOT_TOKEN not set in .env!"
    echo "   Edit .env and add your bot token from @BotFather"
    exit 1
fi

# Start the bot
echo "🚀 Launching bot..."
echo ""
cd src
python bot.py
