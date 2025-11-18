#!/bin/bash

# Generate CNAME file for GitHub Pages and custom domains
# Author: User (via git config)
# Version: 1.0.0

set -e

CNAME_FILE="CNAME"
PUBLIC_CNAME="public/CNAME"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get git author info
GIT_AUTHOR=$(git config user.name || echo "Unknown")
GIT_EMAIL=$(git config user.email || echo "unknown@example.com")

echo -e "${BLUE}Generating CNAME files...${NC}"
echo ""

# Get domain from environment or use default
CUSTOM_DOMAIN="${CUSTOM_DOMAIN:-}"

if [ -z "$CUSTOM_DOMAIN" ]; then
    echo -e "${YELLOW}⚠️  No custom domain specified${NC}"
    echo ""
    echo "To set a custom domain, run:"
    echo "  export CUSTOM_DOMAIN=yourdomain.com"
    echo "  bash scripts/generate-cname.sh"
    echo ""
    echo "Or set it in GitHub repository settings:"
    echo "  Settings → Pages → Custom domain"
    echo ""
    echo "Example domains:"
    echo "  - docs.yourcompany.com"
    echo "  - devops.yourproject.io"
    echo "  - www.yourdomain.com"
    echo ""

    # Create template CNAME with instructions
    cat > "$CNAME_FILE" << EOF
# CNAME Configuration for GitHub Pages
#
# Author: $GIT_AUTHOR <$GIT_EMAIL>
# Generated: $(date -u '+%Y-%m-%d %H:%M:%S UTC')
#
# Instructions:
# 1. Uncomment the line below and replace with your domain
# 2. Configure DNS records at your domain provider:
#    - For apex domain (example.com):
#      A record pointing to GitHub Pages IPs:
#        185.199.108.153
#        185.199.109.153
#        185.199.110.153
#        185.199.111.153
#    - For subdomain (www.example.com or docs.example.com):
#      CNAME record pointing to: your-username.github.io
# 3. Commit this file to your repository
# 4. Enable GitHub Pages in repository settings
# 5. Wait for DNS propagation (up to 24-48 hours)
#
# Example (uncomment and modify):
# docs.yourcompany.com

# To generate with a domain, run:
# CUSTOM_DOMAIN=yourdomain.com bash scripts/generate-cname.sh
EOF

    echo -e "${YELLOW}✓ Template CNAME created with instructions${NC}"
    echo -e "  Location: ${BLUE}$CNAME_FILE${NC}"
    echo ""

else
    # Validate domain format (basic check)
    if [[ ! "$CUSTOM_DOMAIN" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
        echo -e "${YELLOW}⚠️  Warning: Domain format may be invalid: $CUSTOM_DOMAIN${NC}"
        echo "  Make sure it's a valid domain name (e.g., docs.example.com)"
        echo ""
    fi

    # Generate root CNAME
    cat > "$CNAME_FILE" << EOF
$CUSTOM_DOMAIN
EOF

    echo -e "${GREEN}✓ CNAME created for domain: ${YELLOW}$CUSTOM_DOMAIN${NC}"
    echo -e "  Location: ${BLUE}$CNAME_FILE${NC}"
    echo ""

    # Generate public/CNAME for build output
    mkdir -p public
    cat > "$PUBLIC_CNAME" << EOF
$CUSTOM_DOMAIN
EOF

    echo -e "${GREEN}✓ Public CNAME created${NC}"
    echo -e "  Location: ${BLUE}$PUBLIC_CNAME${NC}"
    echo ""
fi

# Display DNS configuration guide
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}DNS Configuration Guide${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ -n "$CUSTOM_DOMAIN" ]; then
    # Determine if apex or subdomain
    if [[ "$CUSTOM_DOMAIN" =~ ^[^.]+\.[^.]+$ ]]; then
        # Apex domain (e.g., example.com)
        echo -e "${YELLOW}Apex Domain Detected:${NC} $CUSTOM_DOMAIN"
        echo ""
        echo "Configure these DNS A records at your domain provider:"
        echo ""
        echo "  Type: A"
        echo "  Name: @"
        echo "  Value:"
        echo "    185.199.108.153"
        echo "    185.199.109.153"
        echo "    185.199.110.153"
        echo "    185.199.111.153"
        echo ""
        echo "Optional AAAA records for IPv6:"
        echo "    2606:50c0:8000::153"
        echo "    2606:50c0:8001::153"
        echo "    2606:50c0:8002::153"
        echo "    2606:50c0:8003::153"
        echo ""
    else
        # Subdomain (e.g., www.example.com or docs.example.com)
        SUBDOMAIN=$(echo "$CUSTOM_DOMAIN" | cut -d'.' -f1)
        BASE_DOMAIN=$(echo "$CUSTOM_DOMAIN" | cut -d'.' -f2-)

        echo -e "${YELLOW}Subdomain Detected:${NC} $CUSTOM_DOMAIN"
        echo ""
        echo "Configure this DNS CNAME record at your domain provider:"
        echo ""
        echo "  Type: CNAME"
        echo "  Name: $SUBDOMAIN"
        echo "  Value: <your-github-username>.github.io"
        echo "  (or your organization name if org repo)"
        echo ""
    fi
else
    echo "Set CUSTOM_DOMAIN environment variable to see DNS instructions"
    echo ""
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# GitHub Pages configuration steps
echo -e "${GREEN}GitHub Pages Setup Steps:${NC}"
echo ""
echo "1. Commit and push the CNAME file:"
echo "   git add CNAME"
echo "   git commit -m 'Add custom domain CNAME'"
echo "   git push"
echo ""
echo "2. Go to GitHub repository settings:"
echo "   Settings → Pages"
echo ""
echo "3. Configure GitHub Pages:"
echo "   - Source: Deploy from a branch"
echo "   - Branch: main (or gh-pages)"
echo "   - Folder: / (root) or /docs"
echo ""
if [ -n "$CUSTOM_DOMAIN" ]; then
    echo "4. Add custom domain in GitHub Pages settings:"
    echo "   - Enter: $CUSTOM_DOMAIN"
    echo "   - Save"
    echo ""
    echo "5. Enable 'Enforce HTTPS' (after DNS propagates)"
    echo ""
fi
echo "6. Wait for DNS propagation (up to 24-48 hours)"
echo ""
echo "7. Verify setup:"
echo "   - Check DNS: dig $CUSTOM_DOMAIN"
if [ -n "$CUSTOM_DOMAIN" ]; then
    echo "   - Visit: https://$CUSTOM_DOMAIN"
fi
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}Additional Resources:${NC}"
echo ""
echo "  • GitHub Pages Documentation:"
echo "    https://docs.github.com/pages"
echo ""
echo "  • Custom Domain Guide:"
echo "    https://docs.github.com/pages/configuring-a-custom-domain-for-your-github-pages-site"
echo ""
echo "  • DNS Propagation Checker:"
echo "    https://www.whatsmydns.net/"
echo ""
echo "  • SSL Certificate Issues:"
echo "    https://docs.github.com/pages/getting-started-with-github-pages/securing-your-github-pages-site-with-https"
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✓ CNAME generation complete!${NC}"
echo -e "  Author: ${YELLOW}$GIT_AUTHOR${NC}"
echo ""
