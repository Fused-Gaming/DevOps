"""
Telegram bot for attorney search - Polling mode.
Use this for local development and testing.
For production, use webhook mode (api/webhook.py).
"""
import os
import logging
from telegram.ext import Application
from dotenv import load_dotenv

from bot_handlers import setup_handlers

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)


def main():
    """Start the bot in polling mode."""
    # Get bot token
    token = os.getenv('TELEGRAM_BOT_TOKEN')
    if not token:
        raise ValueError("TELEGRAM_BOT_TOKEN not found in environment variables")

    # Create application
    application = Application.builder().token(token).build()

    # Setup all handlers
    setup_handlers(application)

    # Start bot in polling mode
    logger.info("Starting Attorney Finder Bot in polling mode...")
    application.run_polling(allowed_updates=Update.ALL_TYPES)


if __name__ == '__main__':
    from telegram import Update
    main()
