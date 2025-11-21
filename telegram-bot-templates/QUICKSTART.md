# ⚡ Quick Start - Create a Bot in 60 Seconds

## 1. Create Bot (10 seconds)

```bash
cd telegram-bot-templates
./create-bot.sh my-bot YOUR_BOT_TOKEN
```

## 2. Setup (20 seconds)

```bash
cd my-bot-bot
./setup.sh
```

## 3. Run (10 seconds)

```bash
./run.sh
```

## 4. Test (20 seconds)

Open Telegram, message your bot:
```
/start
```

## ✅ Done! Bot is running!

---

## Deploy to Production (2 minutes)

### 1. Install Vercel CLI

```bash
npm install -g vercel
```

### 2. Login to Vercel

```bash
vercel login
```

### 3. Deploy

```bash
./deploy-vercel.sh
```

### 4. Set Webhook

```bash
./set-webhook.sh https://your-deployment.vercel.app
```

## ✅ Live on Vercel!

---

## Customize Your Bot

Edit `src/bot_handlers.py`:

```python
async def handle_message(update, context):
    # Your custom logic here!
    user_message = update.message.text

    # Example: Echo bot
    await update.message.reply_text(f"You said: {user_message}")

    # Example: Command bot
    if "help" in user_message.lower():
        await update.message.reply_text("How can I help you?")
```

Save and restart:
```bash
./run.sh
```

---

## Examples

### Create Multiple Bots

```bash
./create-bot.sh customer-support
./create-bot.sh notifications
./create-bot.sh admin-panel
./create-bot.sh data-collector
```

Each bot is independent and ready to customize!

---

## File Structure Reference

```
my-bot-bot/
├── src/
│   └── bot_handlers.py    ← EDIT THIS for your logic
├── .env                   ← Your bot token (secret)
├── run.sh                 ← Start locally
├── deploy-vercel.sh       ← Deploy to production
└── set-webhook.sh         ← Configure webhook
```

---

## Common Tasks

### Add a new command

```python
# In bot_handlers.py

async def custom_command(update, context):
    await update.message.reply_text("Custom command!")

def setup_handlers(application):
    # ... existing handlers ...
    application.add_handler(CommandHandler("custom", custom_command))
```

### Add button interactions

```python
from telegram import InlineKeyboardButton, InlineKeyboardMarkup

async def show_buttons(update, context):
    keyboard = [
        [InlineKeyboardButton("Button 1", callback_data='1')],
        [InlineKeyboardButton("Button 2", callback_data='2')],
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.message.reply_text('Choose:', reply_markup=reply_markup)

async def button_handler(update, context):
    query = update.callback_query
    await query.answer()
    await query.edit_message_text(f"You pressed: {query.data}")
```

### Store user data

```python
# Simple in-memory storage
user_data = {}

async def save_name(update, context):
    user_id = update.effective_user.id
    name = ' '.join(context.args)
    user_data[user_id] = {'name': name}
    await update.message.reply_text(f"Saved: {name}")

async def get_name(update, context):
    user_id = update.effective_user.id
    name = user_data.get(user_id, {}).get('name', 'Unknown')
    await update.message.reply_text(f"Your name: {name}")
```

---

## Pro Tips 💡

1. **Test locally first** - Always use `./run.sh` before deploying
2. **Keep .env secret** - Never commit bot tokens
3. **Read logs** - `vercel logs` shows production errors
4. **Use context** - Store temporary data in `context.user_data`
5. **Handle errors** - Add try/except blocks for robust bots

---

## Need Help?

- 📖 Full docs: [README.md](README.md)
- 🤖 Example: [../attorney-finder-bot/](../attorney-finder-bot/)
- 📚 API docs: https://docs.python-telegram-bot.org/

---

**You're ready to build amazing bots! 🚀**
