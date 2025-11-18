# 🏛️ Attorney Finder Telegram Bot

A Telegram bot that helps people find legal counsel by searching through a database of attorneys. Users can search by location, practice area, and the bot can scrape attorney information from web pages.

## ✨ Features

- 🔍 **Smart Search** - Search by ZIP code, city, or practice area
- 🌐 **Web Scraping** - Automatically extract attorney information from URLs
- 💾 **SQLite Database** - Fast, local storage of attorney data
- 🤖 **Telegram Interface** - Clean, modern bot interface
- 📱 **Mobile Friendly** - Works on any device with Telegram
- 🔒 **Privacy Focused** - No automated calling, users contact attorneys manually

## 🚀 Quick Start

### Prerequisites

- Python 3.8 or higher
- Telegram account
- Telegram Bot Token (get from [@BotFather](https://t.me/BotFather))

### Installation

1. **Clone the repository:**
```bash
cd attorney-finder-bot
```

2. **Install dependencies:**
```bash
pip install -r requirements.txt
```

3. **Set up environment variables:**
```bash
cp .env.example .env
```

Edit `.env` and add your Telegram bot token:
```env
TELEGRAM_BOT_TOKEN=8011471379:AAGaEH6l4E3Ro66_BYuShA7IZoita1Zazpc
DATABASE_PATH=attorneys.db
MAX_RESULTS_PER_SEARCH=50
SCRAPE_DELAY_SECONDS=2
```

4. **Run the bot:**
```bash
cd src
python bot.py
```

## 📖 Usage

### Bot Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/start` | Welcome message and overview | `/start` |
| `/help` | Show help and usage instructions | `/help` |
| `/search` | Search for attorneys | `/search 94621 family law` |
| `/scrape` | Add attorney from URL | `/scrape https://example.com/attorney/john-doe` |
| `/stats` | View database statistics | `/stats` |

### Search Examples

**By ZIP Code:**
```
94621
```

**By City:**
```
Oakland
```

**By Practice Area:**
```
family law
```

**Combined Search:**
```
94621 divorce
Oakland family law
```

### Adding Attorneys

You can add attorneys by providing their profile URL:

```
/scrape https://www.consumeradvocates.org/attorney/lisa-espada/
```

The bot will automatically extract:
- Name
- Phone number(s)
- Email address
- Physical address
- Practice areas
- Website

## 🏗️ Project Structure

```
attorney-finder-bot/
├── src/
│   ├── bot.py          # Main Telegram bot
│   ├── database.py     # SQLite database management
│   └── scraper.py      # Web scraping logic
├── requirements.txt    # Python dependencies
├── .env.example       # Environment variables template
├── .gitignore         # Git ignore rules
└── README.md          # This file
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TELEGRAM_BOT_TOKEN` | Your Telegram bot token | Required |
| `DATABASE_PATH` | Path to SQLite database file | `attorneys.db` |
| `MAX_RESULTS_PER_SEARCH` | Maximum search results | `50` |
| `SCRAPE_DELAY_SECONDS` | Delay between scraping requests | `2` |

### Database Schema

The bot uses SQLite with the following schema:

```sql
CREATE TABLE attorneys (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    website TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    practice_areas TEXT,
    source_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🛠️ Development

### Running in Development

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run bot
cd src
python bot.py
```

### Adding New Features

The bot is modular and easy to extend:

- **Bot Commands**: Add new handlers in `src/bot.py`
- **Search Logic**: Modify `src/database.py`
- **Scraping**: Enhance extractors in `src/scraper.py`

## 📊 Database Management

### View Statistics

```
/stats
```

Shows:
- Total attorneys in database
- Unique cities covered
- Unique states covered

### Backup Database

```bash
cp attorneys.db attorneys_backup_$(date +%Y%m%d).db
```

### Reset Database

```bash
rm attorneys.db
# Database will be recreated on next run
```

## 🔒 Legal & Ethical Considerations

This bot is designed for **legitimate use only**:

✅ **Allowed:**
- Helping people find legal counsel
- Aggregating public attorney information
- Providing contact details for users to manually reach out

❌ **NOT Allowed:**
- Automated calling or messaging
- Spam or harassment
- Violating website terms of service
- Collecting non-public information

**Important:** Users must manually contact attorneys. This bot does not automate any communication.

## 🐛 Troubleshooting

### Bot doesn't respond

1. Check bot is running: `ps aux | grep bot.py`
2. Verify bot token in `.env`
3. Check logs for errors

### Scraping fails

1. Ensure URL is accessible
2. Check website doesn't block bots
3. Verify delay settings (increase if needed)

### Database errors

1. Check file permissions on `attorneys.db`
2. Ensure SQLite is installed
3. Try resetting database

## 📝 License

This project is provided as-is for educational and legitimate business purposes.

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Support

For issues or questions:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Review bot logs for errors
3. Open an issue in the repository

## 🎯 Roadmap

Future enhancements:

- [ ] Advanced filtering options
- [ ] Attorney rating system
- [ ] Export search results to CSV
- [ ] Multi-language support
- [ ] Integration with legal directories
- [ ] Webhook support for automated updates
- [ ] Web dashboard for admin

## 🙏 Acknowledgments

Built with:
- [python-telegram-bot](https://github.com/python-telegram-bot/python-telegram-bot)
- [BeautifulSoup4](https://www.crummy.com/software/BeautifulSoup/)
- [SQLite](https://www.sqlite.org/)

---

**Made with ❤️ to help people find legal representation**
