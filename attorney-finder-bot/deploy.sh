#!/bin/bash

# Attorney Finder Bot - Complete Deployment Script
# Deploys to Vercel with full configuration

set -e

echo "🚀 Attorney Finder Bot - Vercel Deployment"
echo "==========================================="
echo ""

# Step 1: Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found!"
    echo ""
    echo "Install it with:"
    echo "  npm install -g vercel"
    echo ""
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found!"
    exit 1
fi

echo "✅ Prerequisites OK"
echo ""

# Step 2: Run build script
echo "🏗️  Running build preparation..."
chmod +x build.sh
./build.sh

echo ""

# Step 3: Check bot token
echo "🔐 Checking bot token..."

if [ ! -f ".env" ]; then
    echo "⚠️  No .env file found"
    read -p "Do you want to create one? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp .env.example .env
        echo "Created .env from template"
        echo "Please edit .env and add your TELEGRAM_BOT_TOKEN"
        exit 1
    fi
else
    if grep -q "your_bot_token_here" .env; then
        echo "⚠️  Bot token not set in .env"
        echo "   You'll need to set TELEGRAM_BOT_TOKEN in Vercel dashboard"
    else
        BOT_TOKEN=$(grep TELEGRAM_BOT_TOKEN .env | cut -d '=' -f2)
        echo "✅ Bot token found"
    fi
fi

echo ""

# Step 4: Login to Vercel
echo "🔑 Checking Vercel authentication..."
vercel whoami > /dev/null 2>&1 || {
    echo "Not logged in to Vercel. Logging in..."
    vercel login
}

echo "✅ Logged in to Vercel"
echo ""

# Step 5: Link to project (if not already)
if [ ! -f ".vercel/project.json" ]; then
    echo "🔗 Linking to Vercel project..."
    echo ""
    echo "Choose your deployment:"
    echo "  1) Link to existing project (team-4eckd/dev-ops)"
    echo "  2) Create new project"
    read -p "Choose (1/2): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^1$ ]]; then
        # Link to existing
        vercel link --yes
    else
        # Will create new on deploy
        echo "Will create new project on deployment"
    fi
else
    echo "✅ Already linked to Vercel project"
fi

echo ""

# Step 6: Set environment variables
echo "🔧 Setting environment variables..."

if [ -n "$BOT_TOKEN" ]; then
    echo "Setting TELEGRAM_BOT_TOKEN..."
    echo "$BOT_TOKEN" | vercel env add TELEGRAM_BOT_TOKEN production || true
fi

echo ""

# Step 7: Deploy
echo "🚀 Deploying to Vercel..."
echo ""

DEPLOY_OUTPUT=$(vercel --prod --yes 2>&1)
echo "$DEPLOY_OUTPUT"

# Extract URL from output
VERCEL_URL=$(echo "$DEPLOY_OUTPUT" | grep -o 'https://[^ ]*vercel\.app' | head -1)

if [ -z "$VERCEL_URL" ]; then
    echo ""
    echo "⚠️  Could not extract deployment URL"
    echo "   Check the output above for your URL"
    read -p "Enter your Vercel URL: " VERCEL_URL
fi

echo ""
echo "✅ Deployment successful!"
echo ""
echo "📍 Your app is live at: $VERCEL_URL"
echo ""

# Step 8: Set webhook
echo "🔗 Setting Telegram webhook..."
echo ""

if [ -n "$BOT_TOKEN" ]; then
    WEBHOOK_URL="${VERCEL_URL}/api/webhook"

    echo "Setting webhook to: $WEBHOOK_URL"

    RESPONSE=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/setWebhook?url=${WEBHOOK_URL}")

    if echo "$RESPONSE" | grep -q '"ok":true'; then
        echo "✅ Webhook set successfully!"
    else
        echo "❌ Failed to set webhook"
        echo "$RESPONSE" | python3 -m json.tool || echo "$RESPONSE"
    fi
else
    echo "⚠️  Bot token not available"
    echo "   Set webhook manually with:"
    echo "   ./set-webhook.sh $VERCEL_URL"
fi

echo ""

# Step 9: Test deployment
echo "🧪 Testing deployment..."
echo ""

echo "1. Web UI: $VERCEL_URL"
echo "2. Telegram Bot: https://t.me/LawmanRoBot"
echo ""

read -p "Open web UI in browser? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v xdg-open &> /dev/null; then
        xdg-open "$VERCEL_URL"
    elif command -v open &> /dev/null; then
        open "$VERCEL_URL"
    else
        echo "Visit: $VERCEL_URL"
    fi
fi

echo ""
echo "🎉 Deployment Complete!"
echo ""
echo "📊 Summary:"
echo "==========="
echo "Web App: $VERCEL_URL"
echo "Telegram: https://t.me/LawmanRoBot"
echo "Webhook: ${VERCEL_URL}/api/webhook"
echo ""
echo "📝 Next Steps:"
echo "1. Test web app (Telegram login)"
echo "2. Test bot in Telegram"
echo "3. Add attorneys with /scrape command"
echo "4. Search via web or Telegram"
echo ""
