"""
Bot command handlers - separated for reuse in both polling and webhook modes.
"""
import os
from telegram import Update
from telegram.ext import (
    CommandHandler,
    MessageHandler,
    CallbackQueryHandler,
    ContextTypes,
    filters,
    Application
)
from dotenv import load_dotenv

from database import AttorneyDatabase
from scraper import AttorneyScraper

# Load environment variables
load_dotenv()

# Initialize database and scraper
db = AttorneyDatabase(os.getenv('DATABASE_PATH', 'attorneys.db'))
scraper = AttorneyScraper(delay=float(os.getenv('SCRAPE_DELAY_SECONDS', '2')))


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Send welcome message when /start is issued."""
    welcome_message = """
🏛️ *Welcome to Attorney Finder Bot!*

I help you find legal counsel quickly and easily.

*Available Commands:*
/search - Search for attorneys
/scrape <url> - Add attorney from URL
/stats - View database statistics
/help - Show this message

*Quick Search:*
Just send me a message with:
- ZIP code (e.g., "94621")
- City name (e.g., "Oakland")
- Practice area (e.g., "family law")
- Combination (e.g., "94621 family law")

Let me know how I can help you find legal representation!
    """
    await update.message.reply_text(welcome_message, parse_mode='Markdown')


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Send help message."""
    help_text = """
📖 *How to Use Attorney Finder Bot*

*Search Methods:*

1️⃣ *Quick Search* - Just send a message:
   • `94621` - Search by ZIP code
   • `Oakland` - Search by city
   • `family law` - Search by practice area
   • `94621 divorce` - Combine location + practice area

2️⃣ */search* command:
   • `/search 94621` - ZIP code search
   • `/search Oakland, CA` - City search
   • `/search Oakland family law` - Combined search

3️⃣ *Add Attorney* from URL:
   • `/scrape https://example.com/attorney/john-doe`
   • Bot will extract contact info automatically

*Other Commands:*
/stats - View database statistics
/help - Show this message

*Tips:*
💡 More specific searches give better results
💡 Try different combinations if you don't find what you need
💡 You can search by city name, ZIP code, or practice area

Need help? Just ask!
    """
    await update.message.reply_text(help_text, parse_mode='Markdown')


async def stats_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Show database statistics."""
    stats = db.get_stats()

    stats_text = f"""
📊 *Database Statistics*

👨‍⚖️ Total Attorneys: {stats['total_attorneys']}
🏙️ Unique Cities: {stats['unique_cities']}
🗺️ Unique States: {stats['unique_states']}

Keep adding more attorneys to grow the database!
    """
    await update.message.reply_text(stats_text, parse_mode='Markdown')


async def scrape_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Scrape attorney data from a URL."""
    if not context.args:
        await update.message.reply_text(
            "Please provide a URL to scrape.\n\n"
            "Usage: `/scrape https://example.com/attorney/john-doe`",
            parse_mode='Markdown'
        )
        return

    url = context.args[0]

    # Validate URL
    if not url.startswith(('http://', 'https://')):
        await update.message.reply_text("Please provide a valid URL starting with http:// or https://")
        return

    # Send processing message
    processing_msg = await update.message.reply_text("🔍 Scraping attorney information...")

    try:
        # Scrape the URL
        attorneys = scraper.scrape_url(url)

        if not attorneys:
            await processing_msg.edit_text(
                "❌ Could not extract attorney information from this URL.\n\n"
                "Please make sure the URL contains attorney contact details."
            )
            return

        # Add to database
        added_count = 0
        for attorney_data in attorneys:
            if attorney_data.get('name') or attorney_data.get('phone'):
                db.add_attorney(attorney_data)
                added_count += 1

        if added_count > 0:
            await processing_msg.edit_text(
                f"✅ Successfully added {added_count} attorney(s) to the database!\n\n"
                f"Use /search to find them."
            )
        else:
            await processing_msg.edit_text(
                "⚠️ No valid attorney information found at this URL."
            )

    except Exception as e:
        await processing_msg.edit_text(
            f"❌ Error scraping URL: {str(e)}\n\n"
            f"Please try again or contact support."
        )


async def search_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Search for attorneys."""
    if not context.args:
        await update.message.reply_text(
            "Please provide search criteria.\n\n"
            "Examples:\n"
            "`/search 94621`\n"
            "`/search Oakland`\n"
            "`/search Oakland family law`\n"
            "`/search 94621 divorce`",
            parse_mode='Markdown'
        )
        return

    query = ' '.join(context.args)
    await perform_search(update, query)


async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handle text messages as search queries."""
    query = update.message.text.strip()

    # Ignore empty messages
    if not query:
        return

    # Perform search
    await perform_search(update, query)


async def perform_search(update: Update, query: str):
    """Perform attorney search and send results."""
    # Parse query
    search_params = parse_search_query(query)

    # Send searching message
    searching_msg = await update.message.reply_text(f"🔍 Searching for attorneys...")

    # Search database
    results = db.search_attorneys(
        city=search_params.get('city'),
        zip_code=search_params.get('zip_code'),
        practice_area=search_params.get('practice_area'),
        limit=50
    )

    if not results:
        await searching_msg.edit_text(
            "❌ No attorneys found matching your search.\n\n"
            "Try:\n"
            "• Different location or practice area\n"
            "• Adding attorneys with /scrape command\n"
            "• Using /help for search tips"
        )
        return

    # Format and send results
    await searching_msg.edit_text(
        f"✅ Found {len(results)} attorney(s)!\n\n"
        f"Sending results..."
    )

    # Send results in batches
    for i in range(0, len(results), 5):
        batch = results[i:i+5]
        message = format_results(batch, i+1)
        await update.message.reply_text(message, parse_mode='Markdown')


def parse_search_query(query: str) -> dict:
    """Parse search query into search parameters."""
    import re

    params = {}

    # Check for ZIP code (5 digits)
    zip_match = re.search(r'\b(\d{5})\b', query)
    if zip_match:
        params['zip_code'] = zip_match.group(1)
        query = query.replace(zip_match.group(0), '').strip()

    # Common practice areas
    practice_areas = [
        'criminal', 'family', 'divorce', 'personal injury', 'dui', 'dwi',
        'immigration', 'bankruptcy', 'estate planning', 'real estate',
        'business', 'corporate', 'employment', 'civil', 'litigation',
        'medical malpractice', 'workers compensation', 'tax', 'intellectual property'
    ]

    # Check for practice area
    query_lower = query.lower()
    for area in practice_areas:
        if area in query_lower:
            params['practice_area'] = area
            query = query.replace(area, '').replace(area.title(), '').strip()
            break

    # Remaining text is likely city
    if query.strip():
        # Remove common state abbreviations and commas
        city = re.sub(r',?\s*[A-Z]{2}\s*$', '', query).strip()
        if city:
            params['city'] = city

    return params


def format_results(attorneys: list, start_num: int = 1) -> str:
    """Format search results for display."""
    if not attorneys:
        return "No results found."

    message = ""
    for i, attorney in enumerate(attorneys, start=start_num):
        name = attorney.get('name', 'Unknown')
        phone = attorney.get('phone', 'N/A')
        email = attorney.get('email', 'N/A')
        address = attorney.get('address', 'N/A')
        city = attorney.get('city', '')
        state = attorney.get('state', '')
        zip_code = attorney.get('zip_code', '')
        practice_areas = attorney.get('practice_areas', 'General Practice')
        website = attorney.get('website', 'N/A')

        location = f"{city}, {state} {zip_code}".strip()
        if not location.replace(',', '').strip():
            location = address

        message += f"*{i}. {name}*\n"
        message += f"📱 Phone: `{phone}`\n"
        if email != 'N/A':
            message += f"📧 Email: {email}\n"
        message += f"📍 Location: {location}\n"
        message += f"⚖️ Practice: {practice_areas}\n"
        if website != 'N/A':
            message += f"🌐 Website: {website}\n"
        message += "\n"

    return message.strip()


async def button_callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handle button callbacks."""
    query = update.callback_query
    await query.answer()

    # Handle different callback actions here
    # For future expansion


async def error_handler(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handle errors."""
    print(f"Update {update} caused error {context.error}")


def setup_handlers(application: Application):
    """
    Setup all bot handlers.

    Args:
        application: Telegram Application instance
    """
    # Add command handlers
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("help", help_command))
    application.add_handler(CommandHandler("stats", stats_command))
    application.add_handler(CommandHandler("search", search_command))
    application.add_handler(CommandHandler("scrape", scrape_command))

    # Add message handler
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))

    # Add callback query handler
    application.add_handler(CallbackQueryHandler(button_callback))

    # Add error handler
    application.add_error_handler(error_handler)
