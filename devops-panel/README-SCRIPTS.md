# DevOps Panel - Quick Start Scripts

This directory contains convenient shell scripts to quickly set up and deploy the DevOps Control Panel.

## Available Scripts

### 🚀 `quick-start.sh` - Development Setup

Sets up and runs the panel in development mode from scratch.

**Usage:**
```bash
./quick-start.sh
```

**What it does:**
1. ✓ Checks prerequisites (Node.js 18+, package manager)
2. ✓ Installs dependencies (pnpm/npm)
3. ✓ Creates `.env` file with interactive prompts
4. ✓ Generates secure session secret
5. ✓ Configures GitHub & Vercel integrations (optional)
6. ✓ Starts development server on http://localhost:3000

**Interactive Prompts:**
- Admin username (default: `admin`)
- Admin password (default: `changeme`)
- GitHub integration (optional)
  - Personal Access Token
  - Repository name
- Vercel integration (optional)
  - API Token
  - Project ID

### 🌐 `deploy-production.sh` - Production Deployment

Builds and deploys the panel to production using Vercel.

**Usage:**
```bash
./deploy-production.sh
```

**Deployment Options:**
1. **Production deployment** (`vercel --prod`)
   - Deploys to production environment
   - Requires environment variables configured in Vercel dashboard
   - Automatically deploys to custom domain if configured

2. **Preview deployment** (`vercel`)
   - Creates a preview deployment for testing
   - Generates unique preview URL
   - Useful for testing before production

3. **Local build only**
   - Builds the project locally
   - Validates the build process
   - Useful for testing before deployment

## Prerequisites

### Required
- **Node.js 18+** - [Download](https://nodejs.org/)
- **Package Manager** - pnpm (recommended) or npm

### Optional
- **Vercel CLI** - Auto-installed if missing when running `deploy-production.sh`
- **GitHub Personal Access Token** - For GitHub Actions integration
- **Vercel API Token** - For deployment monitoring

## Quick Start Examples

### First Time Setup (Development)

```bash
cd devops-panel
./quick-start.sh
```

Follow the interactive prompts to configure your environment.

### Deploy to Production

```bash
cd devops-panel
./deploy-production.sh
# Choose option 1 for production deployment
```

### Deploy to Preview (Testing)

```bash
./deploy-production.sh
# Choose option 2 for preview deployment
```

### Build Locally

```bash
./deploy-production.sh
# Choose option 3 for local build only
```

## Environment Variables

The scripts will help you configure these automatically:

### Required
| Variable | Description |
|----------|-------------|
| `DEVOPS_USERNAME` | Admin username for authentication |
| `DEVOPS_PASSWORD` | Admin password (development only) |
| `SESSION_SECRET` | 32+ character secret for session encryption |

### Optional
| Variable | Description |
|----------|-------------|
| `DEVOPS_PASSWORD_HASH` | Bcrypt hash (recommended for production) |
| `GITHUB_TOKEN` | GitHub Personal Access Token |
| `GITHUB_REPO` | Repository name (e.g., Fused-Gaming/DevOps) |
| `VERCEL_TOKEN` | Vercel API token |
| `VERCEL_PROJECT_ID` | Vercel project ID |

## Production Deployment Checklist

When deploying to production via Vercel:

- [ ] Run `./deploy-production.sh` and choose option 1
- [ ] Configure environment variables in Vercel dashboard:
  - [ ] `DEVOPS_USERNAME`
  - [ ] `DEVOPS_PASSWORD_HASH` (use bcrypt hash, not plain password)
  - [ ] `SESSION_SECRET` (generate with crypto.randomBytes)
  - [ ] `GITHUB_TOKEN` (optional)
  - [ ] `VERCEL_TOKEN` (optional)
- [ ] Add custom domain: `vercel domains add dev.vln.gg`
- [ ] Configure DNS:
  - Type: `CNAME`
  - Name: `dev`
  - Value: `cname.vercel-dns.com`
- [ ] Test the deployment
- [ ] Verify HTTPS certificate

## Generating Secure Credentials

### Password Hash (for production)
```bash
node -e "const bcrypt = require('bcryptjs'); console.log(bcrypt.hashSync('YOUR_PASSWORD', 10));"
```

### Session Secret
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'));"
```

## Troubleshooting

### Script Permission Denied
```bash
chmod +x quick-start.sh deploy-production.sh
```

### Port 3000 Already in Use
```bash
# Kill the process using port 3000
lsof -ti:3000 | xargs kill -9

# Or use a different port
PORT=3001 pnpm dev
```

### Dependencies Installation Fails
```bash
# Clear cache and reinstall
rm -rf node_modules pnpm-lock.yaml
pnpm install
```

### Vercel Deployment Fails
```bash
# Check Vercel logs
vercel logs --prod

# Verify environment variables
vercel env ls
```

## Manual Setup (Without Scripts)

If you prefer manual setup:

```bash
# Install dependencies
pnpm install

# Copy environment file
cp .env.example .env

# Edit .env with your configuration
nano .env

# Start development server
pnpm dev

# Or build for production
pnpm build
pnpm start
```

## Support

For detailed deployment instructions, see:
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Full deployment guide
- [README.md](./README.md) - Project documentation
- [QUICKSTART.md](./QUICKSTART.md) - Quick start guide

## Script Maintenance

These scripts are part of the DevOps Panel project. If you encounter issues or have suggestions for improvements:

1. Check the latest version in the repository
2. Report issues in the GitHub repository
3. Submit pull requests with improvements

---

**Last Updated:** 2025-11-19
