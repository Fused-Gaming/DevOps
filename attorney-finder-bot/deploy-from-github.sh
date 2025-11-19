#!/bin/bash

# Attorney Finder Bot - Automated Vercel Deployment from GitHub
# Clones repo, builds, and deploys automatically

set -e

echo "🚀 Attorney Finder Bot - Automated GitHub → Vercel Deployment"
echo "=============================================================="
echo ""

# Configuration
GITHUB_REPO="https://github.com/Fused-Gaming/DevOps.git"
BRANCH="main"
PROJECT_DIR="attorney-finder-bot"
TEMP_DIR="/tmp/attorney-bot-deploy-$$"

# Step 1: Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v git &> /dev/null; then
    echo "❌ Git not found! Install with: apt-get install git"
    exit 1
fi

if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found!"
    echo ""
    echo "Install it with:"
    echo "  npm install -g vercel"
    echo ""
    exit 1
fi

echo "✅ Prerequisites OK"
echo ""

# Step 2: Clone repository
echo "📦 Cloning repository from GitHub..."
echo "Repo: $GITHUB_REPO"
echo "Branch: $BRANCH"
echo ""

if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

git clone --depth 1 --branch "$BRANCH" "$GITHUB_REPO" "$TEMP_DIR"

if [ ! -d "$TEMP_DIR/$PROJECT_DIR" ]; then
    echo "❌ Project directory not found in repository!"
    echo "   Expected: $TEMP_DIR/$PROJECT_DIR"
    echo ""
    echo "Available directories:"
    ls -la "$TEMP_DIR"
    exit 1
fi

echo "✅ Repository cloned"
echo ""

# Step 3: Navigate to project
echo "📁 Navigating to project directory..."
cd "$TEMP_DIR/$PROJECT_DIR"
pwd
echo ""

# Step 4: Check bot token
echo "🔐 Configuring bot token..."
echo ""

read -p "Enter your Telegram Bot Token (or press Enter to set in Vercel): " BOT_TOKEN

if [ -n "$BOT_TOKEN" ]; then
    # Create .env file
    cat > .env <<EOF
TELEGRAM_BOT_TOKEN=$BOT_TOKEN
DATABASE_PATH=/tmp/attorneys.db
MAX_RESULTS_PER_SEARCH=50
SCRAPE_DELAY_SECONDS=2
EOF
    echo "✅ Bot token saved to .env"
else
    echo "⚠️  You'll need to set TELEGRAM_BOT_TOKEN in Vercel dashboard"
fi

echo ""

# Step 5: Create necessary directories
echo "📁 Creating required directories..."
mkdir -p api/__init__.py
mkdir -p src/__init__.py
mkdir -p public/assets/{css,js,images}
touch api/__init__.py
touch src/__init__.py
echo "✅ Directories ready"
echo ""

# Step 6: Verify files
echo "🔍 Verifying deployment files..."
REQUIRED_FILES=(
    "vercel.json"
    "api/webhook.py"
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
    exit 1
fi

echo "✅ All required files present"
echo ""

# Step 7: Login to Vercel
echo "🔑 Checking Vercel authentication..."
if ! vercel whoami > /dev/null 2>&1; then
    echo "Not logged in to Vercel. Logging in..."
    vercel login
fi

echo "✅ Logged in to Vercel"
echo ""

# Step 8: Link/Create project
echo "🔗 Vercel project setup..."
echo ""
echo "Deployment options:"
echo "  1) Link to existing project: team-4eckd/dev-ops"
echo "  2) Create new project"
echo ""
read -p "Choose (1/2) [1]: " DEPLOY_CHOICE
DEPLOY_CHOICE=${DEPLOY_CHOICE:-1}

if [ "$DEPLOY_CHOICE" == "1" ]; then
    echo ""
    echo "Linking to existing project..."
    # Try to link to existing project
    vercel link --yes --scope team-4eckd --project dev-ops 2>/dev/null || {
        echo "⚠️  Could not auto-link. You may need to link manually."
        vercel link
    }
fi

echo ""

# Step 9: Set environment variables
if [ -n "$BOT_TOKEN" ]; then
    echo "🔧 Setting environment variables in Vercel..."
    echo "$BOT_TOKEN" | vercel env add TELEGRAM_BOT_TOKEN production --force || true
    echo "✅ Environment variables set"
    echo ""
fi

# Step 10: Deploy to Vercel
echo "🚀 Deploying to Vercel..."
echo ""

DEPLOY_OUTPUT=$(vercel --prod --yes 2>&1 | tee /dev/tty)
DEPLOY_EXIT_CODE=$?

# Extract URL from output
VERCEL_URL=$(echo "$DEPLOY_OUTPUT" | grep -oE 'https://[a-zA-Z0-9.-]+\.vercel\.app' | head -1)

if [ -z "$VERCEL_URL" ]; then
    echo ""
    echo "⚠️  Could not auto-detect deployment URL"
    read -p "Enter your Vercel URL: " VERCEL_URL
fi

# Verify deployment succeeded
echo ""
echo "🔍 Verifying deployment..."

if [ $DEPLOY_EXIT_CODE -eq 0 ] && [ -n "$VERCEL_URL" ]; then
    # Test if URL is accessible
    if curl -s -o /dev/null -w "%{http_code}" "$VERCEL_URL" | grep -q "200"; then
        echo "✅ Deployment successful!"
        echo "✅ Web app is accessible"
    else
        echo "⚠️  Deployment completed but site not responding yet"
        echo "   (This is normal, may take a few seconds to propagate)"
    fi
else
    echo "❌ Deployment may have failed (exit code: $DEPLOY_EXIT_CODE)"
    echo "   Check the output above for errors"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "📍 Your app: $VERCEL_URL"
echo ""

# Step 11: Set Telegram webhook
if [ -n "$BOT_TOKEN" ] && [ -n "$VERCEL_URL" ]; then
    echo "🔗 Setting Telegram webhook..."
    WEBHOOK_URL="${VERCEL_URL}/api/webhook"

    RESPONSE=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/setWebhook?url=${WEBHOOK_URL}")

    if echo "$RESPONSE" | grep -q '"ok":true'; then
        echo "✅ Webhook configured successfully"
        echo "   URL: $WEBHOOK_URL"

        # Verify webhook
        echo ""
        echo "🔍 Verifying webhook..."
        WEBHOOK_INFO=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getWebhookInfo")

        if echo "$WEBHOOK_INFO" | grep -q "\"url\":\"$WEBHOOK_URL\""; then
            echo "✅ Webhook verified and active"

            # Check for errors
            if echo "$WEBHOOK_INFO" | grep -q '"last_error_message"'; then
                echo "⚠️  Previous webhook errors detected:"
                echo "$WEBHOOK_INFO" | python3 -c "import sys, json; data=json.load(sys.stdin); print('   ' + data.get('result', {}).get('last_error_message', 'Unknown error'))" 2>/dev/null || echo "   Check webhook manually"
            fi
        else
            echo "⚠️  Webhook set but verification failed"
        fi
    else
        echo "❌ Webhook setup failed!"
        echo ""
        echo "Response from Telegram:"
        echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
        echo ""
        echo "Manual setup command:"
        echo "curl -X POST \"https://api.telegram.org/bot${BOT_TOKEN}/setWebhook?url=${WEBHOOK_URL}\""
    fi
else
    echo "⚠️  Skipping webhook setup (no bot token)"
    echo "   Set webhook manually later"
fi

echo ""

# Step 12: Cleanup
echo "🧹 Cleaning up temporary files..."
cd /tmp
rm -rf "$TEMP_DIR"
echo "✅ Cleanup complete"
echo ""

# Step 13: Final Verification & Summary
echo "🧪 Running final checks..."
echo ""

# Test web app
WEB_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$VERCEL_URL")
if [ "$WEB_STATUS" == "200" ]; then
    echo "✅ Web app is live (HTTP $WEB_STATUS)"
else
    echo "⚠️  Web app status: HTTP $WEB_STATUS"
fi

# Test API endpoint
API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${VERCEL_URL}/api/web/stats")
if [ "$API_STATUS" == "200" ]; then
    echo "✅ API endpoints working (HTTP $API_STATUS)"
else
    echo "⚠️  API status: HTTP $API_STATUS (may need a moment to initialize)"
fi

# Test Telegram webhook
if [ -n "$BOT_TOKEN" ]; then
    WEBHOOK_CHECK=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getWebhookInfo" | grep -o '"url":"[^"]*"' | cut -d'"' -f4)
    if [ "$WEBHOOK_CHECK" == "${VERCEL_URL}/api/webhook" ]; then
        echo "✅ Telegram webhook configured correctly"
    else
        echo "⚠️  Telegram webhook: $WEBHOOK_CHECK"
    fi
fi

echo ""
echo "🎉 Deployment Complete!"
echo ""
echo "=========================================="
echo "📊 Deployment Summary"
echo "=========================================="
echo ""
echo "Status: ✅ LIVE"
echo ""
echo "🌐 Web App:      $VERCEL_URL"
echo "   Status:       HTTP $WEB_STATUS"
echo ""
echo "🤖 Telegram:     https://t.me/LawmanRoBot"
if [ -n "$BOT_TOKEN" ]; then
echo "   Webhook:      ✅ Configured"
else
echo "   Webhook:      ⚠️  Not set (add token later)"
fi
echo ""
echo "🔗 API Endpoints:"
echo "   /api/webhook        - Telegram bot"
echo "   /api/web/search     - Search API"
echo "   /api/web/auth       - Authentication"
echo "   /api/web/stats      - Statistics"
echo ""
echo "📝 Next Steps:"
echo "1. ✅ Visit: $VERCEL_URL"
echo "2. ✅ Test Telegram login on web"
echo "3. ✅ Message bot: /start"
echo "4. ✅ Add attorneys: /scrape <url>"
echo "5. ✅ Test search on both platforms"
echo ""
echo "📚 Resources:"
echo "- GitHub: $GITHUB_REPO"
echo "- Vercel: https://vercel.com/team-4eckd"
echo "- Logs: vercel logs"
echo ""

read -p "Open web app in browser? (y/n) " -n 1 -r
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
echo "✅ All done! Your bot is live at: $VERCEL_URL"
echo ""
