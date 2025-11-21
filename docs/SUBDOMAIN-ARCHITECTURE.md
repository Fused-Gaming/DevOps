# Subdomain Architecture for vln.gg

## Overview

This document defines the standardized subdomain usage rules and architecture for the `vln.gg` domain. It establishes a comprehensive framework for organizing domain segments across various services and applications.

**Last Updated:** 2025-11-21
**Status:** Active
**Issue:** [#47](https://github.com/Fused-Gaming/DevOps/issues/47)

## Table of Contents

- [Subdomain Definitions](#subdomain-definitions)
- [Architecture Diagram](#architecture-diagram)
- [Configuration Standards](#configuration-standards)
- [DNS Configuration](#dns-configuration)
- [Adding New Subdomains](#adding-new-subdomains)
- [Maintenance and Monitoring](#maintenance-and-monitoring)
- [Security Considerations](#security-considerations)
- [Deployment Guidelines](#deployment-guidelines)

## Subdomain Definitions

The following 12 subdomains are officially designated for the vln.gg domain:

### 1. **edu.vln.gg**
**Purpose:** Educational resources and tutorials
**Environment:** Production
**Type:** Static content / Learning management
**Status:** Confirmed
**Hosting:** TBD

Educational platform providing learning materials, tutorials, documentation, and training resources for users.

---

### 2. **design.vln.gg**
**Purpose:** Design system and UI component library
**Environment:** Production
**Type:** Static documentation / Component showcase
**Status:** Confirmed
**Hosting:** TBD

Central repository for design guidelines, brand assets, UI components, style guides, and design documentation.

---

### 3. **dev.vln.gg**
**Purpose:** Development environment
**Environment:** Development
**Type:** Full application stack
**Status:** Confirmed
**Hosting:** VPS (self-hosted)
**Port:** 3001
**PM2 Process:** `devops-panel-dev`
**Authentication:** Required (env variables)

Active development environment for testing features before staging. Used by developers for integration testing and feature validation.

**Security:** Protected by username/password authentication. Credentials configured via environment variables (`DEVOPS_USERNAME`, `DEVOPS_PASSWORD`, and `SESSION_SECRET`).

**See:** [SUBDOMAIN-DEPLOYMENT.md](../devops-panel/SUBDOMAIN-DEPLOYMENT.md) for deployment instructions.

---

### 4. **docs.vln.gg**
**Purpose:** Technical documentation
**Environment:** Production
**Type:** Static documentation site
**Status:** Confirmed
**Hosting:** GitHub Pages / Vercel

Comprehensive technical documentation including API references, user guides, system architecture, and developer documentation.

---

### 5. **preview.vln.gg**
**Purpose:** Preview/demo environment
**Environment:** Staging/Preview
**Type:** Full application stack
**Status:** Confirmed
**Hosting:** VPS (self-hosted)
**Port:** 3000
**PM2 Process:** `devops-panel-preview`
**Authentication:** Required (env variables)

Preview environment for stakeholder reviews and pre-release testing. Features are deployed here before production release.

**Security:** Protected by username/password authentication. Credentials configured via environment variables (`DEVOPS_USERNAME`, `DEVOPS_PASSWORD`, and `SESSION_SECRET`).

**See:** [SUBDOMAIN-DEPLOYMENT.md](../devops-panel/SUBDOMAIN-DEPLOYMENT.md) for deployment instructions.

---

### 6. **app.vln.gg**
**Purpose:** Main application
**Environment:** Production
**Type:** Full application stack
**Status:** Confirmed
**Hosting:** Vercel / VPS

Primary production application serving end users. This is the main customer-facing application.

---

### 7. **api.vln.gg**
**Purpose:** API endpoints
**Environment:** Production
**Type:** REST/GraphQL API
**Status:** Confirmed
**Hosting:** Vercel / VPS

Backend API services providing data and functionality to client applications. Includes RESTful endpoints and potentially GraphQL interfaces.

---

### 8. **help.vln.gg**
**Purpose:** Help center and support
**Environment:** Production
**Type:** Static content / Knowledge base
**Status:** Confirmed
**Hosting:** TBD

Customer support portal including FAQs, knowledge base articles, troubleshooting guides, and help resources.

---

### 9. **mail.vln.gg**
**Purpose:** Email services
**Environment:** Production
**Type:** Email infrastructure
**Status:** Confirmed
**Hosting:** Email service provider

Email infrastructure for transactional emails, newsletters, and communication services. May include webmail interface.

---

### 10. **auth.vln.gg**
**Purpose:** Authentication service
**Environment:** Production
**Type:** Authentication API
**Status:** Confirmed
**Hosting:** VPS / Auth0 / Supabase

Centralized authentication and authorization service. Handles user login, registration, session management, and OAuth flows.

---

### 11. **pay.vln.gg**
**Purpose:** Payment processing
**Environment:** Production
**Type:** Payment gateway integration
**Status:** Confirmed
**Hosting:** Secure VPS / Stripe

Secure payment processing infrastructure. Handles transactions, payment method management, and billing operations.

**Security:** PCI-DSS compliance required.

---

### 12. **wallet.vln.gg**
**Purpose:** Wallet and financial management
**Environment:** Production
**Type:** Financial application
**Status:** Confirmed
**Hosting:** Secure VPS

User wallet interface for managing funds, transactions, balances, and financial operations.

**Security:** Enhanced security measures required.

---

### Under Consideration

#### **proposals.vln.gg**
**Purpose:** Proposal submission and management
**Status:** Under consideration
**Type:** Application
**Hosting:** TBD

Platform for submitting, reviewing, and managing proposals. Pending approval for implementation.

## Architecture Diagram

```
vln.gg Domain Structure
│
├── app.vln.gg          [Production] Main Application
├── api.vln.gg          [Production] Backend API
├── auth.vln.gg         [Production] Authentication Service
├── pay.vln.gg          [Production] Payment Processing
├── wallet.vln.gg       [Production] Wallet Management
│
├── docs.vln.gg         [Production] Documentation
├── help.vln.gg         [Production] Help Center
├── edu.vln.gg          [Production] Educational Resources
├── design.vln.gg       [Production] Design System
│
├── dev.vln.gg          [Development] Development Environment
├── preview.vln.gg      [Staging] Preview Environment
│
├── mail.vln.gg         [Production] Email Services
│
└── proposals.vln.gg    [Proposed] Proposal Management (Under Consideration)
```

## Configuration Standards

### Environment Variable Structure

When configuring subdomains in deployment scripts and configuration files, follow this pattern:

```bash
# Domain Configuration
TLD=vln.gg

# Development/Staging Subdomains
SUB_DOMAIN_DEV=dev
SUB_DOMAIN_PREVIEW=preview

# Production Subdomains
SUB_DOMAIN_APP=app
SUB_DOMAIN_API=api
SUB_DOMAIN_AUTH=auth
SUB_DOMAIN_PAY=pay
SUB_DOMAIN_WALLET=wallet
SUB_DOMAIN_DOCS=docs
SUB_DOMAIN_HELP=help
SUB_DOMAIN_EDU=edu
SUB_DOMAIN_DESIGN=design
SUB_DOMAIN_MAIL=mail
```

### Port Allocation (Self-Hosted Services)

For services deployed on VPS with PM2:

| Subdomain | Port | PM2 Process Name |
|-----------|------|------------------|
| preview.vln.gg | 3000 | devops-panel-preview |
| dev.vln.gg | 3001 | devops-panel-dev |
| (future subdomains) | 3002+ | devops-panel-{subdomain} |

**Port Range:** 3000-3099 reserved for subdomain deployments

### PM2 Naming Convention

```
{app-name}-{subdomain}
```

Examples:
- `devops-panel-preview`
- `devops-panel-dev`
- `api-service-preview`
- `auth-service-dev`

## DNS Configuration

### A Records (Apex Domain)

```dns
@     IN  A     [SERVER_IP]
```

### CNAME Records (Subdomains)

For Vercel-hosted services:
```dns
app      IN  CNAME  cname.vercel-dns.com.
api      IN  CNAME  cname.vercel-dns.com.
docs     IN  CNAME  cname.vercel-dns.com.
```

For self-hosted services (VPS):
```dns
dev      IN  A      [VPS_IP_ADDRESS]
preview  IN  A      [VPS_IP_ADDRESS]
```

### MX Records (Email)

```dns
mail     IN  MX  10  [EMAIL_PROVIDER_MX]
```

### SSL/TLS Certificates

**Option 1: Wildcard Certificate**
```bash
# Covers *.vln.gg
certbot certonly --dns-cloudflare \
  -d vln.gg -d *.vln.gg
```

**Option 2: Individual Certificates**
```bash
# Per subdomain
certbot certonly --nginx \
  -d preview.vln.gg \
  -d dev.vln.gg
```

**Recommendation:** Use wildcard certificate for easier management across all subdomains.

## Adding New Subdomains

### Workflow for Adding a New Subdomain

1. **Proposal Phase**
   - Document purpose and requirements
   - Create issue in GitHub (use label: `subdomain-request`)
   - Get approval from DevOps lead

2. **Documentation Update**
   - Update this file (`SUBDOMAIN-ARCHITECTURE.md`)
   - Add entry to configuration files
   - Update DNS documentation

3. **Infrastructure Setup**
   - Configure DNS records
   - Set up SSL/TLS certificates
   - Configure reverse proxy (Nginx)

4. **Deployment Configuration**
   - Update `.env.deploy` with new subdomain
   - Add to deployment scripts
   - Configure monitoring

5. **Testing**
   - Verify DNS propagation
   - Test SSL/TLS certificate
   - Perform smoke tests

6. **Documentation**
   - Update README.md
   - Update deployment guides
   - Add to CHANGELOG.md

### Configuration File Updates

When adding a new subdomain, update the following files:

```bash
# 1. Update environment configuration
vim devops-panel/.env.deploy.example

# 2. Add DNS records (document here)
# Add to DNS Configuration section

# 3. Update Nginx configuration if self-hosted
vim devops-panel/nginx-{subdomain}.conf

# 4. Update deployment scripts
vim devops-panel/deploy-to-subdomain.sh
```

## Maintenance and Monitoring

### Health Checks

Each subdomain should have health check endpoints:

```
https://{subdomain}.vln.gg/health
https://{subdomain}.vln.gg/api/health
```

### Monitoring Services

- **Uptime Monitoring:** UptimeRobot / Pingdom
- **Performance:** Vercel Analytics / New Relic
- **Error Tracking:** Sentry
- **Logs:** PM2 logs for self-hosted, Vercel logs for Vercel-hosted

### SSL Certificate Renewal

Automated renewal via certbot:
```bash
# Auto-renewal is configured via cron
0 0 * * * certbot renew --quiet
```

### Backup Strategy

- **Configuration Files:** Daily git commits
- **Databases:** Daily automated backups
- **SSL Certificates:** Backed up to secure storage

## Security Considerations

### Authentication Setup

The DevOps Panel includes built-in password protection for all deployed instances. Authentication is configured via environment variables:

#### Environment Variables

```bash
# Required for all deployments
DEVOPS_USERNAME=admin                    # Login username
DEVOPS_PASSWORD=your_strong_password     # Plain text password (dev only)
SESSION_SECRET=your_32_char_secret       # Session encryption key

# Recommended for production (instead of DEVOPS_PASSWORD)
DEVOPS_PASSWORD_HASH=$2a$10$...          # Bcrypt hash of password
```

#### Generating Secure Credentials

**1. Generate Session Secret:**
```bash
openssl rand -base64 32
```

**2. Generate Password Hash (for production):**
```bash
node -e "console.log(require('bcryptjs').hashSync('your_password', 10))"
```

#### Deployment Configuration

When deploying to subdomains (dev.vln.gg, preview.vln.gg), authentication credentials are:

1. **Set in `.env.deploy` file** for deployment scripts
2. **Passed to server** as environment variables during deployment
3. **Read by application** from environment at runtime

**Example `.env.deploy` configuration:**
```bash
DEVOPS_USERNAME=admin
DEVOPS_PASSWORD=strong_unique_password_per_subdomain
SESSION_SECRET=$(openssl rand -base64 32)
```

#### Security Best Practices

- ✅ Use different passwords for each subdomain (dev, preview, staging)
- ✅ Use `DEVOPS_PASSWORD_HASH` instead of `DEVOPS_PASSWORD` in production
- ✅ Generate unique `SESSION_SECRET` for each deployment
- ✅ Never commit `.env` or `.env.deploy` files to version control
- ✅ Rotate passwords regularly
- ✅ Consider IP whitelisting for additional security

#### Middleware Protection

The application includes middleware protection (`middleware.ts`) that:
- Enforces authentication on all routes except `/login` and public assets
- Redirects unauthenticated users to login page
- Protects API endpoints with session validation
- Uses secure session cookies with iron-session

### Access Control

| Subdomain | Public Access | Authentication Required |
|-----------|---------------|-------------------------|
| app.vln.gg | ✓ | User login |
| api.vln.gg | ✓ | API key/token |
| auth.vln.gg | ✓ | N/A (auth service) |
| pay.vln.gg | ✗ | Strict authentication |
| wallet.vln.gg | ✗ | Strict authentication |
| docs.vln.gg | ✓ | No |
| help.vln.gg | ✓ | No |
| edu.vln.gg | ✓ | Optional |
| design.vln.gg | ✓ | No |
| dev.vln.gg | ✗ | Developer access only |
| preview.vln.gg | ✗ | Stakeholder access only |
| mail.vln.gg | ✗ | Email authentication |

### Security Headers

All subdomains should implement:
```nginx
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
```

### Rate Limiting

Implement rate limiting on public-facing subdomains:
- API endpoints: 100 requests/minute per IP
- Authentication: 5 login attempts per minute per IP
- Payment processing: Strict rate limiting

## Deployment Guidelines

### Deployment Environments

| Environment | Subdomains | Purpose |
|-------------|------------|---------|
| **Production** | app, api, auth, pay, wallet, docs, help, edu, design, mail | Live services |
| **Staging** | preview | Pre-production testing |
| **Development** | dev | Active development |

### Deployment Workflow

1. **Development:** Code changes → `dev.vln.gg`
2. **Staging:** Tested features → `preview.vln.gg`
3. **Production:** Approved features → `app.vln.gg`, `api.vln.gg`, etc.

### CI/CD Integration

Each subdomain can have dedicated deployment workflows:

```yaml
# .github/workflows/deploy-{subdomain}.yml
name: Deploy to {subdomain}.vln.gg
on:
  push:
    branches: [main, staging, dev]
```

### Rollback Procedures

For self-hosted services:
```bash
# List PM2 processes
pm2 list

# Restart specific service
pm2 restart devops-panel-preview

# View logs
pm2 logs devops-panel-preview
```

For Vercel-hosted services:
- Use Vercel dashboard to revert to previous deployment
- Or use Vercel CLI: `vercel rollback`

## Related Documentation

- **[SUBDOMAIN-DEPLOYMENT.md](../devops-panel/SUBDOMAIN-DEPLOYMENT.md)** - Complete subdomain deployment guide
- **[DEPLOYMENT.md](../devops-panel/DEPLOYMENT.md)** - Vercel deployment guide
- **[CNAME](../CNAME)** - GitHub Pages custom domain configuration

## Change History

| Date | Change | Author | Issue |
|------|--------|--------|-------|
| 2025-11-21 | Initial subdomain architecture documentation | Claude | [#47](https://github.com/Fused-Gaming/DevOps/issues/47) |

## Support

For questions or issues related to subdomain configuration:

1. Check existing documentation in `/docs` and `/devops-panel`
2. Review deployment guides for specific subdomain types
3. Create an issue with label `subdomain` for new requests
4. Contact DevOps team for infrastructure access

---

**Status:** This architecture is actively maintained and should be updated whenever new subdomains are added or existing ones are modified.
