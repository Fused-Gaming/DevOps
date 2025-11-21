# Penpot Integration - Quick Start

## ✅ Setup Complete!

Your Penpot token has been securely configured in `.env.local` (git-ignored).

## 🚀 Quick Actions

### Export Designs

```bash
cd design-standards
./scripts/export-designs.sh
```

This will:
- Connect to your Penpot project
- Export all design files
- Save to `static/design-assets/`
- Generate an index

### View VLN Color Palette

```bash
node scripts/sync-colors.js
```

Displays all VLN colors with visual preview.

### Update Your Configuration

Edit `.env.local` to add your project details:

```bash
# Get these from your Penpot project URL:
# https://design.penpot.app/#/workspace/TEAM_ID/PROJECT_ID

PENPOT_PROJECT_ID=your_project_id_here
PENPOT_TEAM_ID=your_team_id_here
```

## 📚 Documentation

- **Full API Guide**: `/docs/tools/penpot-integration`
- **Setup Guide**: `/docs/tools/penpot-setup`
- **Security Best Practices**: `SECURITY.md`

## 🔐 Security Notes

✅ Token is stored in `.env.local` (git-ignored)
✅ Never commit `.env.local` to git
✅ Use `.env.example` as template for team members
✅ Rotate token every 90 days

## 🎨 Design Workflow

```
1. Create designs in Penpot
   ↓
2. Run export script
   ↓
3. Designs saved to static/
   ↓
4. Commit exported assets
   ↓
5. Deploy to design.vln.gg
```

## 🤝 Team Collaboration

Share Penpot project:
1. Open project in Penpot
2. Click "Share" button
3. Invite team members
4. Set permissions (View/Edit/Admin)

Each team member needs:
- Their own Penpot account
- Their own access token (in their .env.local)
- Same project ID (shared via .env.example)

## 📦 What's Included

### Scripts
- `scripts/export-designs.sh` - Export all designs
- `scripts/sync-colors.js` - View VLN color palette

### Documentation
- Complete API integration guide
- Security best practices
- Automation examples
- CI/CD templates

### Configuration
- `.env.local` - Your secure token (git-ignored) ✅
- `.env.example` - Template for team (committed) ✅

## 🔧 Troubleshooting

### Token not working?

```bash
# Test authentication
curl -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  https://design.penpot.app/api/rpc/command/get-profile
```

### Can't find project ID?

1. Open Penpot project
2. Look at URL bar
3. Copy UUID after `/workspace/TEAM_ID/`

### Export script fails?

```bash
# Install jq (JSON parser)
sudo apt install jq  # Linux
brew install jq      # macOS

# Then run again
./scripts/export-designs.sh
```

## 🎯 Next Steps

1. ✅ Token configured (done!)
2. ⏳ Add project ID to `.env.local`
3. ⏳ Run export script
4. ⏳ Review exported designs
5. ⏳ Set up CI/CD automation

## 📖 Resources

- [Penpot Docs](https://help.penpot.app)
- [Penpot API](https://design.penpot.app/api-doc)
- [VLN Design Standards](https://design.vln.gg)

---

**Questions?** Check the full documentation in `/docs/tools/penpot-integration`
