# Deployment Guide

## Quick Deployment to dev.vln.gg

This guide will walk you through deploying the DevOps Control Panel to Vercel at `dev.vln.gg`.

### Prerequisites

- Vercel account with access to vln.gg domain
- GitHub repository with the DevOps panel code
- Vercel CLI installed: `npm i -g vercel`

### Step 1: Prepare Environment Variables

First, generate a secure password hash:

```bash
node -e "const bcrypt = require('bcryptjs'); console.log(bcrypt.hashSync('YOUR_SECURE_PASSWORD', 10));"
```

Generate a session secret:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'));"
```

### Step 2: Set Up Vercel Project

1. Navigate to the panel directory:
```bash
cd k:/git/DevOps/devops-panel
```

2. Link to Vercel (create new project):
```bash
vercel
```

Follow the prompts:
- Set up and deploy? **Y**
- Which scope? Select your account/team
- Link to existing project? **N**
- Project name? **devops-panel**
- Directory? **./devops-panel**
- Override settings? **N**

### Step 3: Add Environment Variables

Add secrets to Vercel:

```bash
# Required
vercel env add DEVOPS_USERNAME
# Enter: admin (or your preferred username)

vercel env add DEVOPS_PASSWORD_HASH
# Enter: (paste the bcrypt hash from Step 1)

vercel env add SESSION_SECRET
# Enter: (paste the random hex from Step 1)

# Optional but recommended
vercel env add GITHUB_TOKEN
# Enter: your GitHub Personal Access Token (with repo and workflow scopes)

vercel env add VERCEL_TOKEN
# Enter: your Vercel API token (from vercel.com/account/tokens)
```

For each variable, select:
- Environment: **Production, Preview, Development** (select all)

### Step 4: Deploy to Production

```bash
vercel --prod
```

This will deploy to a URL like `devops-panel-xxx.vercel.app`

### Step 5: Configure Custom Domain

1. Add the custom domain:
```bash
vercel domains add dev.vln.gg
```

2. Or through Vercel Dashboard:
   - Go to your project settings
   - Navigate to "Domains"
   - Add `dev.vln.gg`
   - Follow DNS configuration instructions

### Step 6: DNS Configuration

Add the following DNS records to your domain provider:

**For Cloudflare (if using):**
- Type: `CNAME`
- Name: `dev`
- Target: `cname.vercel-dns.com`
- Proxy status: DNS only (or Proxied if you want Cloudflare protection)

**For other providers:**
- Type: `CNAME`
- Name: `dev`
- Value: `cname.vercel-dns.com`

### Step 7: Verify Deployment

1. Visit `https://dev.vln.gg`
2. You should see the login page
3. Log in with your configured credentials
4. Verify all features work:
   - Dashboard loads
   - Status cards display
   - Milestone tracking works
   - Deployments list (if Vercel token configured)
   - GitHub Actions (if GitHub token configured)

## GitHub Integration Setup

To enable GitHub Actions monitoring:

1. Create a GitHub Personal Access Token:
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Generate new token (classic)
   - Select scopes: `repo`, `workflow`
   - Copy the token

2. Add to Vercel:
```bash
vercel env add GITHUB_TOKEN
# Paste your token
```

3. Redeploy:
```bash
vercel --prod
```

## Vercel Integration Setup

To enable deployment monitoring:

1. Get your Vercel token:
   - Go to https://vercel.com/account/tokens
   - Create new token
   - Copy the token

2. Add to Vercel:
```bash
vercel env add VERCEL_TOKEN
# Paste your token
```

3. Redeploy:
```bash
vercel --prod
```

## Continuous Deployment

### Option 1: Vercel GitHub Integration

1. Go to your Vercel project settings
2. Connect your GitHub repository
3. Configure:
   - Root Directory: `devops-panel`
   - Build Command: `npm run build`
   - Output Directory: `.next`
   - Install Command: `npm install`

Now every push to main will auto-deploy!

### Option 2: GitHub Actions

Create `.github/workflows/deploy-panel.yml`:

```yaml
name: Deploy DevOps Panel

on:
  push:
    branches: [main]
    paths:
      - 'devops-panel/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          working-directory: ./devops-panel
```

## Troubleshooting

### Login Fails

- Verify `DEVOPS_PASSWORD_HASH` is set correctly
- Check `SESSION_SECRET` is at least 32 characters
- Ensure cookies are enabled in browser

### API Routes Return 500

- Check environment variables are set in Vercel
- View logs: `vercel logs --prod`
- Verify tokens have correct permissions

### Deployments Don't Show

- Confirm `VERCEL_TOKEN` is valid
- Check token has read access to deployments
- View browser console for errors

### GitHub Actions Don't Load

- Verify `GITHUB_TOKEN` is set
- Ensure token has `repo` and `workflow` scopes
- Check repository name in API call

## Security Checklist

- [ ] Strong password hash set
- [ ] Session secret is random and secure
- [ ] Tokens stored as Vercel secrets (not in code)
- [ ] HTTPS enforced
- [ ] `.env` file in `.gitignore`
- [ ] Security headers configured
- [ ] Rate limiting considered (add if needed)

## Monitoring

View logs in real-time:
```bash
vercel logs --prod --follow
```

View specific deployment logs:
```bash
vercel logs <deployment-url>
```

## Updating

To update the panel:

```bash
# Make changes
git add .
git commit -m "Update panel"
git push

# Or manual deploy
vercel --prod
```

## Rollback

If something breaks:

```bash
vercel rollback
```

Or in Vercel Dashboard:
- Go to Deployments
- Find previous working deployment
- Click "Promote to Production"

## Support

For issues:
1. Check Vercel logs
2. Verify environment variables
3. Test locally with `pnpm dev`
4. Review API route responses

## Next Steps

After deployment:

1. **Set up monitoring**: Configure alerts for deployment failures
2. **Add custom actions**: Extend Quick Actions with your DevOps scripts
3. **Integrate webhooks**: Add webhook endpoints for automated updates
4. **Add analytics**: Monitor usage and performance
5. **Customize branding**: Update colors, logos, and metadata
