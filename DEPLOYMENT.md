# One-Click Subdomain Deployment

## Overview

The DevOps Panel now includes a one-click subdomain deployment feature that allows you to deploy projects to various subdomains directly from the dashboard.

## Features

### Supported Projects

1. **Design Standards** (`design-standards/`)
   - Docusaurus-based documentation site
   - Deploys to: `design.vln.gg`

2. **DevOps Panel** (`devops-panel/`)
   - Next.js dashboard application
   - Deploys to:
     - `preview.vln.gg` - Preview environment
     - `dev.vln.gg` - Development environment
     - `staging.vln.gg` - Staging environment

### How It Works

1. **Click "Deploy to Subdomain"** button in Quick Actions
2. **Select Project** (Design Standards or DevOps Panel)
3. **Choose Subdomain** (based on selected project)
4. **Click "Deploy Now"**
5. **Monitor Progress** with real-time status updates
6. **View Deployment URL** when complete

## Setup Requirements

### 1. Vercel Token

Create a Vercel token and add it to your environment variables:

```bash
# Get token from: https://vercel.com/account/tokens
export VERCEL_TOKEN=your_vercel_token_here
```

### 2. Vercel CLI (Optional)

For local testing:

```bash
# Install Vercel CLI globally
npm install -g vercel

# Or use with npx
npx vercel --version
```

### 3. Environment Variables

Add to `.env.local` in `devops-panel/`:

```env
# Required for deployment feature
VERCEL_TOKEN=your_vercel_token_here
VERCEL_PROJECT_ID=your_project_id (optional)

# Authentication (already configured)
DEVOPS_USERNAME=admin
DEVOPS_PASSWORD=your_secure_password
SESSION_SECRET=your_session_secret
```

## API Endpoints

### POST /api/deployments/subdomain

Trigger a new deployment.

**Request Body:**
```json
{
  "project": "design-standards" | "devops-panel",
  "subdomain": "design" | "preview" | "dev" | "staging"
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Successfully deployed design-standards to design",
  "subdomain": "design",
  "project": "design-standards",
  "deploymentUrl": "https://design-standards-abc123.vercel.app",
  "logs": "... deployment logs ..."
}
```

**Response (Error):**
```json
{
  "error": "Failed to deploy subdomain",
  "message": "Error message here",
  "details": "... error details ..."
}
```

### GET /api/deployments/subdomain

Get deployment history grouped by project.

**Response:**
```json
{
  "success": true,
  "deployments": {
    "devops-panel": [...],
    "design-standards": [...]
  },
  "total": 20
}
```

## Architecture

### Frontend Components

#### DeploymentDialog (`components/devops/deployment-dialog.tsx`)
- Modal interface for deployment configuration
- Real-time status updates (idle → deploying → success/error)
- Project and subdomain selection
- Deployment logs viewer
- External link to deployed site

#### QuickActions (`components/devops/quick-actions.tsx`)
- Integrated "Deploy to Subdomain" button
- Triggers deployment dialog
- Highlighted as primary action

### Backend

#### API Route (`app/api/deployments/subdomain/route.ts`)
- Handles deployment requests
- Executes Vercel CLI commands
- Streams deployment logs
- Returns deployment status and URLs

### Deployment Flow

```
User clicks "Deploy"
    ↓
Opens DeploymentDialog
    ↓
Selects project + subdomain
    ↓
Clicks "Deploy Now"
    ↓
POST /api/deployments/subdomain
    ↓
Backend executes: vercel --prod --token XXX
    ↓
Captures output & deployment URL
    ↓
Returns status to frontend
    ↓
Shows success message + URL
    ↓
User clicks link to view site
```

## Domain Configuration

### Vercel Project Settings

For each project, configure domains in Vercel:

**Design Standards:**
- Production Domain: `design.vln.gg`

**DevOps Panel:**
- Production Domain: `vln.gg`
- Preview Domain: `preview.vln.gg`
- Dev Domain: `dev.vln.gg`
- Staging Domain: `staging.vln.gg`

### DNS Configuration

Add CNAME records to your DNS provider:

```
design.vln.gg   CNAME   cname.vercel-dns.com.
preview.vln.gg  CNAME   cname.vercel-dns.com.
dev.vln.gg      CNAME   cname.vercel-dns.com.
staging.vln.gg  CNAME   cname.vercel-dns.com.
```

## Security

### Authentication

- All deployment endpoints require authentication
- Session validation via iron-session
- Protected routes in middleware

### Environment Variables

- `VERCEL_TOKEN` is server-side only
- Never exposed to client
- Stored in `.env.local` (git-ignored)

### API Security

- Rate limiting (recommended)
- Request validation
- Error handling with sanitized messages
- Deployment timeouts (5 minutes max)

## Troubleshooting

### "Vercel token not configured"

**Solution:** Add `VERCEL_TOKEN` to `.env.local`

```bash
# Get token from https://vercel.com/account/tokens
VERCEL_TOKEN=your_token_here
```

### "Failed to deploy subdomain"

**Check:**
1. Vercel CLI is installed: `npx vercel --version`
2. Token has correct permissions
3. Project exists in Vercel account
4. Network connectivity
5. Deployment logs for specific errors

### "Deployment timeout"

**Causes:**
- Large build size
- Slow network
- Build errors

**Solutions:**
- Check Vercel dashboard for build status
- Review deployment logs
- Optimize build process
- Increase timeout in API route (default: 5 minutes)

### "Unauthorized"

**Solution:** Log in to DevOps Panel first

```
1. Navigate to DevOps Panel
2. Enter credentials
3. Try deployment again
```

## Manual Deployment (Fallback)

If one-click deployment fails, use manual deployment:

### Design Standards

```bash
cd design-standards
npm run build
vercel --prod
```

### DevOps Panel

```bash
cd devops-panel
pnpm build
vercel --prod
```

## Future Enhancements

### Planned Features

- [ ] Deployment queue for multiple concurrent deploys
- [ ] Rollback to previous deployment
- [ ] Environment variable management
- [ ] Build logs streaming (real-time)
- [ ] Deployment scheduling
- [ ] Slack/Discord notifications
- [ ] Deployment history with timestamps
- [ ] Resource usage monitoring

### API Enhancements

- [ ] WebSocket for real-time log streaming
- [ ] Deployment status polling endpoint
- [ ] Cancel deployment endpoint
- [ ] Rollback endpoint
- [ ] Deployment comparison

## Testing

### Local Testing

```bash
# Start DevOps Panel
cd devops-panel
pnpm dev

# Login at http://localhost:3000
# Click "Deploy to Subdomain"
# Select project and subdomain
# Monitor deployment progress
```

### Production Testing

```bash
# Deploy DevOps Panel first
cd devops-panel
vercel --prod

# Access at https://vln.gg (or your domain)
# Test deployment feature with design-standards
```

## Support

For issues or questions:

- **GitHub Issues:** [DevOps Issues](https://github.com/Fused-Gaming/DevOps/issues)
- **Documentation:** `/design-standards/docs/`
- **API Docs:** `/devops-panel/app/api/`

## Related Documentation

- [Subdomain Architecture](/docs/SUBDOMAIN-ARCHITECTURE.md)
- [Design Standards](/design-standards/README.md)
- [DevOps Panel](/devops-panel/README.md)
- [API Documentation](/devops-panel/app/api/README.md)

---

**Last Updated:** 2025-11-21
**Version:** 1.0.0
