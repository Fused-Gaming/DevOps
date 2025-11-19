"""
Vercel serverless function for Telegram webhook.
Handles incoming updates from Telegram Bot API.
"""
import os
import json
from telegram import Update
from telegram.ext import Application, ContextTypes
import asyncio
import sys

# Add parent directory to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from src.bot_handlers import setup_handlers

# Initialize application
TOKEN = os.getenv('TELEGRAM_BOT_TOKEN')
if not TOKEN:
    raise ValueError("TELEGRAM_BOT_TOKEN not found in environment variables")

application = Application.builder().token(TOKEN).build()

# Setup handlers
setup_handlers(application)


async def process_update(update_data):
    """Process a single update from Telegram."""
    try:
        update = Update.de_json(update_data, application.bot)
        await application.initialize()
        await application.process_update(update)
        return {"statusCode": 200, "body": "OK"}
    except Exception as e:
        print(f"Error processing update: {e}")
        return {"statusCode": 500, "body": str(e)}


def handler(request):
    """
    Vercel serverless function handler.

    Args:
        request: Vercel request object

    Returns:
        Response dict with statusCode and body
    """
    # Only accept POST requests
    if request.method != 'POST':
        return {
            "statusCode": 405,
            "body": "Method Not Allowed"
        }

    try:
        # Parse request body
        body = request.body
        if isinstance(body, bytes):
            body = body.decode('utf-8')

        update_data = json.loads(body)

        # Process update asynchronously
        result = asyncio.run(process_update(update_data))

        return result

    except Exception as e:
        print(f"Webhook error: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }


# For Vercel, the handler must be exported
def webhook(request):
    """Main webhook entry point for Vercel."""
    return handler(request)
