# Quick Start Guide - 5 Minutes to Running

Get the DevOps Control Panel running locally in 5 minutes.

## Step 1: Install Dependencies (2 min)

```bash
cd k:/git/DevOps/devops-panel
pnpm install
```

Don't have pnpm? Install it:
```bash
npm install -g pnpm
```

## Step 2: Set Up Environment (1 min)

```bash
# Copy example file
cp .env.example .env

# Edit .env (use any text editor)
# Set at minimum:
# DEVOPS_USERNAME=admin
# DEVOPS_PASSWORD=yourpassword
# SESSION_SECRET=your_random_32_character_string_here
```

Quick generate session secret:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

## Step 3: Run Development Server (1 min)

```bash
pnpm dev
```

## Step 4: Access the Panel (1 min)

1. Open browser to **http://localhost:3000**
2. You'll see the login page
3. Log in with your credentials from `.env`
4. Explore the dashboard!

## That's It!

You now have a running DevOps control panel.

## What You'll See

- **Dashboard**: Overview of system status
- **Milestones**: Project progress tracking
- **Deployments**: Recent deployment history
- **Quick Actions**: Buttons to run DevOps scripts
- **Status Cards**: System health indicators

## Next Steps

### Add GitHub Integration
```bash
# Get token: https://github.com/settings/tokens
# Add to .env:
echo 'GITHUB_TOKEN=ghp_yourtoken' >> .env
pnpm dev
```

### Add Vercel Integration
```bash
# Get token: https://vercel.com/account/tokens
# Add to .env:
echo 'VERCEL_TOKEN=your_vercel_token' >> .env
pnpm dev
```

### Deploy to Production
See `DEPLOYMENT.md` for full deployment guide to dev.vln.gg

## Common Issues

### Port 3000 in use?
```bash
pnpm dev -- -p 3001
```

### Dependencies fail to install?
```bash
# Try npm instead
npm install
npm run dev
```

### Login fails?
- Check `.env` file exists
- Verify DEVOPS_USERNAME and DEVOPS_PASSWORD are set
- Make sure SESSION_SECRET is at least 32 characters

### API routes return errors?
- Make sure all environment variables are set
- Check console for specific error messages

## Production Build

Test production build locally:
```bash
pnpm build
pnpm start
```

## Need Help?

1. Check `README.md` for full documentation
2. Check `DEPLOYMENT.md` for deployment guide
3. Check `PROJECT_SUMMARY.md` for technical overview
4. View logs for errors

---

Enjoy your DevOps Control Panel! 🚀
