---
id: penpot-integration
title: Penpot API Integration
sidebar_position: 9
---

# Penpot API Integration

Connect your VLN design project to Penpot for automated workflows and design synchronization.

## Overview

This guide shows how to integrate Penpot with design.vln.gg for:
- Automated design asset exports
- Version-controlled design files
- Team collaboration workflows
- Design-to-code pipelines

## Setup

### 1. Get Your Penpot Access Token

1. Visit **https://design.penpot.app/#/settings/access-tokens**
2. Click "Generate new token"
3. Name it: "VLN Design Standards"
4. Copy the token (you'll only see it once!)

### 2. Configure Environment

```bash
cd design-standards

# Copy example env file
cp .env.example .env.local

# Edit .env.local and add your token
# PENPOT_ACCESS_TOKEN=your_token_here
```

**⚠️ Important**: `.env.local` is git-ignored. Never commit tokens!

### 3. Get Project and Team IDs

Visit your Penpot project and check the URL:

```
https://design.penpot.app/#/workspace/TEAM_ID/PROJECT_ID
```

Add these to `.env.local`:

```env
PENPOT_PROJECT_ID=your_project_id
PENPOT_TEAM_ID=your_team_id
```

## Penpot API Usage

### Authentication

All API requests require your access token:

```bash
curl -H "Authorization: Token YOUR_TOKEN" \
  https://design.penpot.app/api/...
```

### Common Endpoints

#### List Projects

```bash
curl -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  https://design.penpot.app/api/rpc/command/get-projects?team-id=YOUR_TEAM_ID
```

#### Get Project Files

```bash
curl -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  https://design.penpot.app/api/rpc/command/get-project-files?project-id=YOUR_PROJECT_ID
```

#### Export File

```bash
curl -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  https://design.penpot.app/api/export/file/YOUR_FILE_ID.zip \
  -o design-export.zip
```

## Automation Scripts

### Export Design Assets

Create `scripts/export-designs.sh`:

```bash
#!/bin/bash
# Export Penpot designs to static assets

set -e

# Load environment variables
source .env.local

EXPORT_DIR=${EXPORT_DIR:-"./static/design-assets"}
mkdir -p "$EXPORT_DIR"

echo "🎨 Exporting Penpot designs..."

# Get all files in project
FILES=$(curl -s -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  "https://design.penpot.app/api/rpc/command/get-project-files?project-id=$PENPOT_PROJECT_ID" \
  | jq -r '.[] | .id')

# Export each file
for FILE_ID in $FILES; do
  echo "📦 Exporting file: $FILE_ID"

  curl -s -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
    "https://design.penpot.app/api/export/file/$FILE_ID.zip" \
    -o "$EXPORT_DIR/$FILE_ID.zip"

  # Unzip
  unzip -q "$EXPORT_DIR/$FILE_ID.zip" -d "$EXPORT_DIR/$FILE_ID"
  rm "$EXPORT_DIR/$FILE_ID.zip"
done

echo "✅ Export complete! Files in: $EXPORT_DIR"
```

Make it executable:

```bash
chmod +x scripts/export-designs.sh
./scripts/export-designs.sh
```

### Sync VLN Color Palette

Create `scripts/sync-colors.js`:

```javascript
#!/usr/bin/env node
// Sync VLN colors to Penpot project

require('dotenv').config({ path: '.env.local' });

const PENPOT_TOKEN = process.env.PENPOT_ACCESS_TOKEN;
const PENPOT_API = process.env.PENPOT_API_URL;
const PROJECT_ID = process.env.PENPOT_PROJECT_ID;

const VLN_COLORS = {
  backgrounds: {
    dark: '#0a0e0f',
    light: '#151a1c',
    lighter: '#1f2527',
  },
  sage: {
    main: '#86d993',
    light: '#a8e9b4',
    dark: '#5fb76f',
  },
  sky: {
    main: '#7dd3fc',
    light: '#bae6fd',
    dark: '#0ea5e9',
  },
  amber: {
    main: '#fbbf24',
    light: '#fcd34d',
    dark: '#f59e0b',
  },
  purple: {
    main: '#c084fc',
    light: '#d8b4fe',
    dark: '#a855f7',
  },
};

async function syncColors() {
  console.log('🎨 Syncing VLN colors to Penpot...');

  // Implementation depends on Penpot API
  // This is a template - adjust based on API docs

  const colors = Object.entries(VLN_COLORS).flatMap(([category, shades]) =>
    Object.entries(shades).map(([name, hex]) => ({
      name: `VLN/${category}/${name}`,
      color: hex,
    }))
  );

  console.log(`📦 ${colors.length} colors ready for sync`);
  console.log('Colors:', colors);

  // TODO: Use Penpot API to create shared color library
}

syncColors();
```

## Design Workflow Integration

### Standard Design Process

```
1. Wireframe in ASCII (5 min)
   ↓
2. Create in Penpot (30 min)
   - Use VLN color palette
   - Apply typography styles
   - Use component library
   ↓
3. Review with Team (10 min)
   - Share Penpot link
   - Collect feedback via comments
   ↓
4. Export Assets (5 min)
   - Run export script
   - Assets saved to static/
   ↓
5. Implement in Code (varies)
   - Reference exported designs
   - Use VLN components
   ↓
6. Deploy to design.vln.gg
   - Changes auto-deploy
   - Documentation updated
```

### Connecting Penpot to Deployment

Add to `.github/workflows/deploy-design.yml`:

```yaml
name: Deploy Design Standards

on:
  push:
    branches: [main]
    paths:
      - 'design-standards/**'

jobs:
  export-penpot:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Export Penpot Designs
        env:
          PENPOT_ACCESS_TOKEN: ${{ secrets.PENPOT_ACCESS_TOKEN }}
          PENPOT_PROJECT_ID: ${{ secrets.PENPOT_PROJECT_ID }}
        run: |
          cd design-standards
          chmod +x scripts/export-designs.sh
          ./scripts/export-designs.sh

      - name: Commit Assets
        run: |
          git config user.name "Penpot Bot"
          git config user.email "bot@vln.gg"
          git add static/design-assets/
          git commit -m "chore: update design assets from Penpot" || true
          git push

  deploy:
    needs: export-penpot
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm install
      - run: npm run build
      - uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
```

## Team Collaboration

### Invite Team Members

1. In Penpot project, click "Share"
2. Enter email addresses
3. Set permissions:
   - **View**: Can see designs
   - **Edit**: Can modify designs
   - **Admin**: Full control

### Design Review Process

1. **Designer** creates mockup in Penpot
2. **Designer** shares Penpot link in PR
3. **Team** reviews and comments directly in Penpot
4. **Designer** addresses feedback
5. **Designer** exports final assets
6. **Engineer** implements design
7. **Team** reviews implementation

### Version Control

```
Penpot (Design Source of Truth)
    ↓
Export to Git (version control)
    ↓
Deploy to design.vln.gg (documentation)
    ↓
Implement in DevOps Panel (production)
```

## Security Best Practices

### ✅ Do

- Store tokens in `.env.local` (git-ignored)
- Use GitHub Secrets for CI/CD
- Rotate tokens periodically
- Limit token permissions to necessary scopes
- Use separate tokens for dev/prod

### ❌ Don't

- Commit `.env.local` to git
- Share tokens in Slack/Discord
- Use same token for multiple projects
- Hard-code tokens in scripts
- Push tokens to public repos

## Troubleshooting

### "Unauthorized" Error

```bash
# Verify token is set
echo $PENPOT_ACCESS_TOKEN

# Test authentication
curl -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  https://design.penpot.app/api/rpc/command/get-profile
```

### "Project not found"

```bash
# Verify project ID
# Should be UUID format: 12345678-1234-5678-1234-567812345678
echo $PENPOT_PROJECT_ID

# List all projects
curl -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  "https://design.penpot.app/api/rpc/command/get-projects?team-id=$PENPOT_TEAM_ID"
```

### Export fails

```bash
# Check file ID exists
curl -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  "https://design.penpot.app/api/rpc/command/get-project-files?project-id=$PENPOT_PROJECT_ID"

# Try manual export
curl -v -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  "https://design.penpot.app/api/export/file/FILE_ID.zip" \
  -o test-export.zip
```

## Advanced Usage

### Webhooks (Future)

Set up webhooks to trigger builds on design changes:

```javascript
// Penpot webhook handler
app.post('/webhooks/penpot', async (req, res) => {
  const { event, file_id } = req.body;

  if (event === 'file.updated') {
    // Trigger export
    await exportPenpotFile(file_id);

    // Trigger deployment
    await deployDesignStandards();
  }

  res.status(200).send('OK');
});
```

### Component Library Sync

Keep Penpot components in sync with React components:

```bash
# scripts/sync-components.sh
#!/bin/bash
# Export Penpot components as React components

# Extract components from Penpot
# Generate React code
# Update component library
```

## Resources

### Penpot API

- **API Docs**: https://design.penpot.app/api-doc
- **RPC Endpoints**: https://design.penpot.app/api/rpc
- **Authentication**: Token-based (Bearer)

### VLN Integration

- [Penpot Setup Guide](/tools/penpot-setup)
- [Design Tools Overview](/tools/design-tools)
- [Component Development](/tools/component-development)

### Community

- **Penpot Community**: https://community.penpot.app
- **GitHub**: https://github.com/penpot/penpot
- **Discord**: https://discord.gg/penpot

---

**Need Help?**

- Check Penpot API docs
- Ask in Penpot Community
- Open issue in DevOps repo
