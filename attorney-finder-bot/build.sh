#!/bin/bash

# Attorney Finder Bot - Vercel Build Script
# Prepares the bot for deployment to Vercel

set -e

echo "🚀 Attorney Finder Bot - Vercel Build"
echo "======================================"
echo ""

BOT_DIR=$(pwd)

# Check if we're in the right directory
if [ ! -f "vercel.json" ]; then
    echo "❌ Error: vercel.json not found!"
    echo "   Run this script from attorney-finder-bot/ directory"
    exit 1
fi

# Step 1: Create public directory for web UI
echo "📁 Creating public directory..."
mkdir -p public/assets/{css,js,images}

# Step 2: Copy source files to root for Vercel
echo "📋 Preparing source files..."
# Vercel needs src files accessible from api/
# They're already in src/, api/ can import them

# Step 3: Create __init__.py files for Python imports
echo "🐍 Setting up Python modules..."
touch src/__init__.py
touch api/__init__.py

# Step 4: Install dependencies locally (for testing)
if [ "$1" == "--local" ]; then
    echo "📦 Installing dependencies..."
    if [ ! -d "venv" ]; then
        python3 -m venv venv
    fi
    source venv/bin/activate
    pip install -r requirements.txt --quiet
    echo "✅ Local environment ready"
fi

# Step 5: Check environment variables
echo "🔐 Checking environment configuration..."
if [ -f ".env" ]; then
    if grep -q "your_bot_token_here" .env; then
        echo "⚠️  Warning: Bot token not set in .env"
        echo "   You'll need to set it in Vercel dashboard"
    else
        echo "✅ Bot token found in .env"
    fi
else
    echo "⚠️  No .env file found (will use Vercel env vars)"
fi

# Step 6: Verify critical files exist
echo "✅ Verifying files..."
REQUIRED_FILES=(
    "vercel.json"
    "api/webhook.py"
    "api/web/search.py"
    "api/web/auth.py"
    "src/database.py"
    "src/scraper.py"
    "src/bot_handlers.py"
    "public/index.html"
    "requirements.txt"
)

MISSING=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "   ❌ Missing: $file"
        MISSING=$((MISSING + 1))
    fi
done

if [ $MISSING -gt 0 ]; then
    echo ""
    echo "❌ $MISSING required file(s) missing!"
    echo "   Run setup first or check file paths"
    exit 1
fi

echo "✅ All required files present"
echo ""

# Step 7: Build summary
echo "📊 Build Summary"
echo "================"
echo "Project: Attorney Finder Bot"
echo "API Routes:"
echo "  - POST /api/webhook        (Telegram webhook)"
echo "  - GET  /api/web/search     (Web search API)"
echo "  - POST /api/web/auth       (Telegram login)"
echo ""
echo "Web UI: /public/index.html"
echo "Database: SQLite (temporary on Vercel)"
echo ""

# Step 8: Instructions
echo "🎯 Next Steps"
echo "============="
echo ""
echo "1. Deploy to Vercel:"
echo "   vercel --prod"
echo ""
echo "2. Set environment variables in Vercel dashboard:"
echo "   - TELEGRAM_BOT_TOKEN=your_token"
echo ""
echo "3. Set webhook:"
echo "   ./set-webhook.sh https://your-deployment.vercel.app"
echo ""
echo "4. Visit web UI:"
echo "   https://your-deployment.vercel.app"
echo ""

echo "✅ Build preparation complete!"
echo ""

# Exit with success
exit 0
