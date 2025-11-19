#!/bin/bash

# Attorney Finder Bot Setup Script
# This script sets up the bot environment and dependencies

echo "🏛️  Attorney Finder Bot Setup"
echo "================================"
echo ""

# Check Python version (without bc)
echo "📋 Checking Python version..."
python_version=$(python3 --version 2>&1 | grep -oP '\d+\.\d+' | head -1)
major=$(echo $python_version | cut -d. -f1)
minor=$(echo $python_version | cut -d. -f2)

if [ "$major" -lt 3 ] || ([ "$major" -eq 3 ] && [ "$minor" -lt 8 ]); then
    echo "❌ Python 3.8 or higher is required. You have Python $python_version"
    exit 1
fi

echo "✅ Python $python_version detected"
echo ""

# Create virtual environment
echo "📦 Creating virtual environment..."
if [ ! -d "venv" ]; then
    if python3 -m venv venv; then
        echo "✅ Virtual environment created"
    else
        echo "❌ Failed to create virtual environment"
        echo "   Try installing: apt-get install python3-venv"
        exit 1
    fi
else
    echo "ℹ️  Virtual environment already exists"
fi
echo ""

# Check if activate script exists
if [ ! -f "venv/bin/activate" ]; then
    echo "❌ Virtual environment activation script not found!"
    echo "   Trying to recreate virtual environment..."
    rm -rf venv
    python3 -m venv venv

    if [ ! -f "venv/bin/activate" ]; then
        echo "❌ Still can't create virtual environment"
        echo "   Please install: apt-get install python3-venv"
        exit 1
    fi
fi

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip --quiet

# Install dependencies
echo "📥 Installing dependencies..."
if pip install -r requirements.txt --quiet; then
    echo "✅ Dependencies installed"
else
    echo "❌ Failed to install dependencies"
    echo "   Check requirements.txt and try again"
    exit 1
fi
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
if grep -q "your_bot_token_here" .env 2>/dev/null; then
    echo "⚠️  WARNING: You need to set your TELEGRAM_BOT_TOKEN in .env"
    echo ""
    read -p "Do you want to set it now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your Telegram Bot Token: " bot_token
        if [ "$(uname)" == "Darwin" ]; then
            # macOS
            sed -i '' "s/your_bot_token_here/$bot_token/" .env
        else
            # Linux
            sed -i "s/your_bot_token_here/$bot_token/" .env
        fi
        echo "✅ Bot token saved"
    fi
    echo ""
fi

# Initialize database
echo "🗄️  Initializing database..."
if python3 -c "from src.database import AttorneyDatabase; db = AttorneyDatabase(); print('✅ Database initialized')" 2>/dev/null; then
    :
else
    echo "⚠️  Database initialization skipped (will be created on first run)"
fi
echo ""

# Final instructions
echo "🎉 Setup complete!"
echo ""
echo "📝 Next steps:"
echo ""
if grep -q "your_bot_token_here" .env 2>/dev/null; then
    echo "  1. ⚠️  Edit .env and add your TELEGRAM_BOT_TOKEN"
    echo "     Get token from: https://t.me/BotFather"
    echo ""
fi
echo "  2. Start the bot:"
echo "     ./run.sh"
echo ""
echo "  OR run locally:"
echo "     source venv/bin/activate"
echo "     cd src && python bot.py"
echo ""
echo "  OR deploy to Vercel:"
echo "     ./deploy.sh"
echo ""
echo "📚 For more information, see README.md"
echo ""
