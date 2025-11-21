# Security Best Practices

## Environment Variables & Secrets

### ⚠️ NEVER Commit Secrets

**Protected files (git-ignored):**
- `.env`
- `.env.local`
- `.env.*.local`
- `.penpot`
- `penpot.token`

### ✅ Storing Secrets Safely

**For Local Development:**
```bash
# Copy template
cp .env.example .env.local

# Edit .env.local with your secrets
# This file is git-ignored and safe
```

**For Production/CI:**
```bash
# Use GitHub Secrets
# Settings → Secrets and variables → Actions → New repository secret

# Required secrets:
# - PENPOT_ACCESS_TOKEN
# - VERCEL_TOKEN
# - DEVOPS_PASSWORD_HASH
```

### 🔑 Access Tokens

**Penpot Token:**
- Get from: https://design.penpot.app/#/settings/access-tokens
- Store in: `.env.local` (local) or GitHub Secrets (CI/CD)
- Rotate: Every 90 days
- Permissions: Minimum required for task

**Vercel Token:**
- Get from: https://vercel.com/account/tokens
- Store in: `.env.local` (local) or GitHub Secrets (CI/CD)
- Rotate: Every 90 days
- Scope: Specific projects only

## What to Commit

### ✅ Safe to Commit

- `.env.example` - Template with placeholders
- `.env.deploy.example` - Deployment template
- `README.md` - Documentation
- Scripts without hardcoded secrets
- Configuration with variable references

### ❌ NEVER Commit

- `.env.local` - Contains real secrets
- `.env` - May contain secrets
- API tokens or passwords
- SSH private keys
- Database credentials
- Any file with `PENPOT_ACCESS_TOKEN`

## Emergency: Secret Exposed

If you accidentally commit a secret:

### 1. Immediately Revoke

```bash
# Penpot: Delete token at https://design.penpot.app/#/settings/access-tokens
# Vercel: Delete token at https://vercel.com/account/tokens
# GitHub: Revoke at https://github.com/settings/tokens
```

### 2. Remove from Git History

```bash
# Remove file from history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env.local" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (⚠️ coordinate with team first!)
git push origin --force --all
```

### 3. Generate New Secret

```bash
# Generate new token
# Update .env.local
# Update GitHub Secrets
# Update production environment
```

## Git Hooks (Recommended)

Prevent accidental commits:

```bash
# .git/hooks/pre-commit
#!/bin/bash

# Check for secrets in staged files
if git diff --cached --name-only | grep -E '\.env$|\.env\.local$'; then
  echo "❌ Error: Attempting to commit .env file!"
  echo "This file contains secrets and should never be committed."
  exit 1
fi

# Check for token patterns
if git diff --cached | grep -iE 'PENPOT_ACCESS_TOKEN|VERCEL_TOKEN|password|secret'; then
  echo "⚠️  Warning: Potential secret detected in commit"
  echo "Please review carefully before proceeding."
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Auditing

### Check for Exposed Secrets

```bash
# Search for potential secrets in repo
git log -p | grep -iE 'token|password|secret|api[_-]?key'

# Check current files
grep -r "PENPOT_ACCESS_TOKEN" . --exclude-dir=node_modules --exclude=.git

# Use git-secrets tool
git secrets --scan
```

### Regular Security Checks

- [ ] Review `.gitignore` monthly
- [ ] Rotate tokens every 90 days
- [ ] Audit repository access quarterly
- [ ] Check GitHub security alerts
- [ ] Update dependencies for security patches

## CI/CD Security

### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      # ✅ Use secrets (not hardcoded)
      - name: Export Designs
        env:
          PENPOT_ACCESS_TOKEN: ${{ secrets.PENPOT_ACCESS_TOKEN }}
          PENPOT_PROJECT_ID: ${{ secrets.PENPOT_PROJECT_ID }}
        run: |
          npm run export-designs

      # ❌ Never echo secrets
      # Don't do: echo $PENPOT_ACCESS_TOKEN
```

### Environment Isolation

```bash
# Separate tokens for each environment
PENPOT_ACCESS_TOKEN_DEV=dev_token_here
PENPOT_ACCESS_TOKEN_STAGING=staging_token_here
PENPOT_ACCESS_TOKEN_PROD=prod_token_here
```

## Team Access

### Principle of Least Privilege

- Only give access to what's needed
- Review permissions quarterly
- Remove access when team members leave
- Use role-based access control

### Sharing Credentials

**❌ Never share via:**
- Email
- Slack/Discord
- Git commits
- Screenshots
- Plain text files

**✅ Share via:**
- Password managers (1Password, LastPass)
- GitHub Secrets (for CI/CD)
- Secure key management systems
- In-person/video call (for initial setup)

## Compliance

### Data Protection

- GDPR compliance for EU users
- Store minimal personal data
- Document data processing
- Provide data export/deletion

### Access Logs

```bash
# Log access to sensitive operations
echo "$(date) - $USER accessed Penpot API" >> access.log
```

## Reporting Security Issues

If you discover a security vulnerability:

1. **DO NOT** open a public issue
2. Email: security@vln.gg (if available)
3. Or: Create a private security advisory on GitHub
4. Include:
   - Description of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if known)

## Resources

- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [git-secrets Tool](https://github.com/awslabs/git-secrets)
- [Vercel Security](https://vercel.com/docs/security)

---

**Remember**: Security is everyone's responsibility! 🔐
