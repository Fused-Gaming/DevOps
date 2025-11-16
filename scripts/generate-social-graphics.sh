#!/bin/bash

# Generate social media graphics and meta files
# Author: User (via git config)
# Version: 1.0.0

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

PUBLIC_DIR="public"
CURRENT_DATE=$(date -u '+%Y-%m-%d')

# Get git author info
GIT_AUTHOR=$(git config user.name || echo "Unknown")
GIT_EMAIL=$(git config user.email || echo "unknown@example.com")

echo -e "${BLUE}Generating social media graphics and meta files...${NC}"
echo ""

# Create public directory if it doesn't exist
mkdir -p "$PUBLIC_DIR"

# ============================================================================
# Generate HTML meta tags file
# ============================================================================
echo -e "${BLUE}→ Generating meta tags...${NC}"

cat > "$PUBLIC_DIR/meta-tags.html" << EOF
<!--
  Social Media Meta Tags
  Auto-generated: $CURRENT_DATE
  Author: $GIT_AUTHOR <$GIT_EMAIL>
  Code sign-off: $GIT_AUTHOR
-->

<!-- Primary Meta Tags -->
<meta name="title" content="DevOps Automation - Professional Tools & Workflows">
<meta name="description" content="Comprehensive DevOps automation with Claude Code integration, testing, CI/CD, and SEO optimization.">
<meta name="keywords" content="devops, automation, ci-cd, github-actions, testing, security, seo, claude-code">
<meta name="author" content="$GIT_AUTHOR">
<meta name="robots" content="index, follow">
<meta name="language" content="English">
<meta name="revisit-after" content="7 days">

<!-- Open Graph / Facebook -->
<meta property="og:type" content="website">
<meta property="og:url" content="https://github.com/Fused-Gaming/DevOps">
<meta property="og:title" content="DevOps Automation - Professional Tools & Workflows">
<meta property="og:description" content="Comprehensive DevOps automation with Claude Code integration, testing, CI/CD, and SEO optimization.">
<meta property="og:image" content="https://github.com/Fused-Gaming/DevOps/raw/main/public/og-image.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:locale" content="en_US">
<meta property="og:site_name" content="DevOps Automation">
<meta property="article:author" content="$GIT_AUTHOR">
<meta property="article:published_time" content="$CURRENT_DATE">

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:url" content="https://github.com/Fused-Gaming/DevOps">
<meta name="twitter:title" content="DevOps Automation - Professional Tools & Workflows">
<meta name="twitter:description" content="Comprehensive DevOps automation with Claude Code integration, testing, CI/CD, and SEO optimization.">
<meta name="twitter:image" content="https://github.com/Fused-Gaming/DevOps/raw/main/public/twitter-card.png">
<meta name="twitter:creator" content="@$GIT_AUTHOR">

<!-- LinkedIn -->
<meta property="og:image:secure_url" content="https://github.com/Fused-Gaming/DevOps/raw/main/public/linkedin-banner.png">

<!-- Additional SEO -->
<link rel="canonical" href="https://github.com/Fused-Gaming/DevOps">
<link rel="icon" type="image/png" sizes="32x32" href="/public/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/public/favicon-16x16.png">
<link rel="apple-touch-icon" sizes="180x180" href="/public/apple-touch-icon.png">
<link rel="manifest" href="/public/site.webmanifest">

<!-- JSON-LD Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "SoftwareSourceCode",
  "name": "DevOps Automation",
  "description": "Comprehensive DevOps automation with Claude Code integration",
  "author": {
    "@type": "Person",
    "name": "$GIT_AUTHOR",
    "email": "$GIT_EMAIL"
  },
  "datePublished": "$CURRENT_DATE",
  "keywords": "devops, automation, ci-cd, github-actions, claude-code",
  "programmingLanguage": ["Bash", "JavaScript", "YAML"],
  "codeRepository": "https://github.com/Fused-Gaming/DevOps"
}
</script>
EOF

echo -e "${GREEN}✓ Meta tags generated${NC}"

# ============================================================================
# Generate placeholder graphics (text-based for now)
# ============================================================================
echo -e "${BLUE}→ Creating placeholder graphics...${NC}"

# Create README for graphics
cat > "$PUBLIC_DIR/README.md" << EOF
# Social Media Graphics

Auto-generated: $CURRENT_DATE
Author: $GIT_AUTHOR <$GIT_EMAIL>
Code sign-off: $GIT_AUTHOR

## Files

- **og-image.png** (1200x630) - Open Graph image for Facebook, LinkedIn
- **twitter-card.png** (1200x675) - Twitter card image
- **favicon.ico** - Website favicon
- **logo.png** (512x512) - Main logo
- **apple-touch-icon.png** (180x180) - iOS home screen icon

## Recommended Sizes

### Open Graph (Facebook, LinkedIn)
- 1200 x 630 pixels
- Aspect ratio: 1.91:1
- Format: PNG or JPG

### Twitter Card
- 1200 x 675 pixels
- Aspect ratio: 16:9
- Format: PNG or JPG

### Favicon
- 32x32, 16x16 pixels
- Format: ICO or PNG

### Logo
- 512 x 512 pixels (square)
- Format: PNG with transparency

## Tools for Generation

- **Canva**: https://www.canva.com/
- **Figma**: https://www.figma.com/
- **Adobe Express**: https://www.adobe.com/express/
- **GIMP**: https://www.gimp.org/ (free)

## Testing

- **Facebook Debugger**: https://developers.facebook.com/tools/debug/
- **Twitter Card Validator**: https://cards-dev.twitter.com/validator
- **LinkedIn Post Inspector**: https://www.linkedin.com/post-inspector/

---
Generated: $CURRENT_DATE
EOF

echo -e "${GREEN}✓ Graphics README created${NC}"

# ============================================================================
# Generate site.webmanifest
# ============================================================================
echo -e "${BLUE}→ Generating site.webmanifest...${NC}"

cat > "$PUBLIC_DIR/site.webmanifest" << EOF
{
  "name": "DevOps Automation",
  "short_name": "DevOps",
  "description": "Professional DevOps tools and automation workflows",
  "start_url": "/",
  "display": "standalone",
  "theme_color": "#0066cc",
  "background_color": "#ffffff",
  "icons": [
    {
      "src": "/public/favicon-32x32.png",
      "sizes": "32x32",
      "type": "image/png"
    },
    {
      "src": "/public/favicon-16x16.png",
      "sizes": "16x16",
      "type": "image/png"
    },
    {
      "src": "/public/logo.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any maskable"
    }
  ],
  "author": "$GIT_AUTHOR",
  "generated": "$CURRENT_DATE"
}
EOF

echo -e "${GREEN}✓ site.webmanifest generated${NC}"

# ============================================================================
# Summary
# ============================================================================
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Social media files generated successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Files created:${NC}"
echo -e "  • $PUBLIC_DIR/meta-tags.html"
echo -e "  • $PUBLIC_DIR/site.webmanifest"
echo -e "  • $PUBLIC_DIR/README.md"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Create actual graphics using tools listed in $PUBLIC_DIR/README.md"
echo -e "  2. Add the graphics to the $PUBLIC_DIR directory"
echo -e "  3. Include meta-tags.html in your HTML pages"
echo -e "  4. Test social media previews using the validators"
echo ""
echo -e "${BLUE}Author: $GIT_AUTHOR${NC}"
echo ""
