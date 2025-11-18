#!/bin/bash

# Attorney Finder Bot Setup Script
# This script sets up the bot environment and dependencies

set -e

echo "🏛️  Attorney Finder Bot Setup"
echo "================================"
echo ""

# Check Python version
echo "📋 Checking Python version..."
python_version=$(python3 --version 2>&1 | grep -oP '\d+\.\d+')
required_version="3.8"

if (( $(echo "$python_version < $required_version" | bc -l) )); then
    echo "❌ Python 3.8 or higher is required. You have Python $python_version"
    exit 1
fi

echo "✅ Python $python_version detected"
echo ""

# Create virtual environment
echo "📦 Creating virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "✅ Virtual environment created"
else
    echo "ℹ️  Virtual environment already exists"
fi
echo ""

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip --quiet

# Install dependencies
echo "📥 Installing dependencies..."
pip install -r requirements.txt --quiet
echo "✅ Dependencies installed"
echo ""

# Create .env if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "✅ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: Edit .env and add your Telegram bot token!"
    echo "   Get your token from: https://t.me/BotFather"
    echo ""
else
    echo "ℹ️  .env file already exists"
    echo ""
fi

# Check if bot token is set
if grep -q "your_bot_token_here" .env; then
    echo "⚠️  WARNING: You need to set your TELEGRAM_BOT_TOKEN in .env"
    echo ""
    read -p "Do you want to set it now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your Telegram Bot Token: " bot_token
        sed -i "s/your_bot_token_here/$bot_token/" .env
        echo "✅ Bot token saved"
    fi
    echo ""
fi

# Initialize database
echo "🗄️  Initializing database..."
python3 -c "from src.database import AttorneyDatabase; db = AttorneyDatabase(); print('✅ Database initialized')"
echo ""

# Final instructions
echo "🎉 Setup complete!"
echo ""
echo "To start the bot:"
echo "  1. Make sure your bot token is set in .env"
echo "  2. Run: ./run.sh"
echo "  OR"
echo "  2. Run: source venv/bin/activate && cd src && python bot.py"
echo ""
echo "For more information, see README.md"
echo ""
