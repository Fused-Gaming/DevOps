# ⚡ Quick Start Guide

Get your Attorney Finder Bot running in 5 minutes!

## 🚀 Installation (3 steps)

### 1. Navigate to the project
```bash
cd attorney-finder-bot
```

### 2. Run setup script
```bash
./setup.sh
```

This will:
- Create a virtual environment
- Install all dependencies
- Initialize the database
- Set up your .env file

### 3. Start the bot
```bash
./run.sh
```

That's it! Your bot is now running! 🎉

## 📱 Using Your Bot

1. **Open Telegram** and search for your bot: [@LawmanRoBot](https://t.me/LawmanRoBot)

2. **Start a conversation:**
   ```
   /start
   ```

3. **Add an attorney** from a URL:
   ```
   /scrape https://www.consumeradvocates.org/attorney/lisa-espada/
   ```

4. **Search for attorneys:**
   ```
   94621
   ```
   or
   ```
   Oakland family law
   ```

## 🎯 Common Commands

| What you want | Command |
|---------------|---------|
| Welcome message | `/start` |
| Search by ZIP | `94621` |
| Search by city | `Oakland` |
| Search by practice | `family law` |
| Combined search | `94621 divorce` |
| Add attorney | `/scrape <url>` |
| View stats | `/stats` |
| Get help | `/help` |

## 🛠️ Troubleshooting

### Bot doesn't start?
```bash
# Check if .env has your bot token
cat .env | grep TELEGRAM_BOT_TOKEN
```

### Need to reset?
```bash
# Remove database and virtual environment
rm -rf venv attorneys.db
# Run setup again
./setup.sh
```

### Still having issues?
Check the full [README.md](README.md) for detailed troubleshooting.

## 📊 Next Steps

1. **Populate your database** - Use `/scrape` to add attorneys
2. **Test searches** - Try different ZIP codes and practice areas
3. **Customize** - Edit bot messages in `src/bot.py`
4. **Deploy** - Run on a server for 24/7 availability

## 🎨 Customization

### Change bot responses
Edit `src/bot.py` - all messages are in the command functions

### Adjust scraping
Edit `src/scraper.py` - modify extraction logic

### Database queries
Edit `src/database.py` - customize search logic

## 🌐 Deployment Options

### Run on VPS/Cloud Server
```bash
# Install screen or tmux
apt-get install screen

# Run in background
screen -S attorney-bot
./run.sh
# Press Ctrl+A, then D to detach
```

### Run with systemd (Linux)
```bash
# Create service file
sudo nano /etc/systemd/system/attorney-bot.service

# Add:
[Unit]
Description=Attorney Finder Bot
After=network.target

[Service]
Type=simple
User=youruser
WorkingDirectory=/path/to/attorney-finder-bot
ExecStart=/path/to/attorney-finder-bot/venv/bin/python /path/to/attorney-finder-bot/src/bot.py
Restart=always

[Install]
WantedBy=multi-user.target

# Enable and start
sudo systemctl enable attorney-bot
sudo systemctl start attorney-bot
```

### Run with Docker
```bash
# Create Dockerfile (not included yet)
# Coming soon!
```

## 💡 Pro Tips

1. **Bulk import**: Create a script to scrape multiple URLs
2. **Regular updates**: Schedule scraping for fresh data
3. **Backup database**: `cp attorneys.db backup.db` regularly
4. **Monitor logs**: Check console output for errors
5. **Test first**: Add a few attorneys before sharing bot

## 📚 Learn More

- Full documentation: [README.md](README.md)
- Bot code: `src/bot.py`
- Scraper code: `src/scraper.py`
- Database code: `src/database.py`

---

**Questions?** Check [README.md](README.md#-troubleshooting) troubleshooting section
