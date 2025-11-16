#!/bin/bash

# Generate robots.txt for SEO
# Author: User (via git config)
# Version: 1.0.0

set -e

ROBOTS_FILE="robots.txt"
BASE_URL="${BASE_URL:-https://example.com}"
CURRENT_DATE=$(date -u '+%Y-%m-%d')

# Get git author info
GIT_AUTHOR=$(git config user.name || echo "Unknown")
GIT_EMAIL=$(git config user.email || echo "unknown@example.com")

echo "Generating robots.txt..."

cat > "$ROBOTS_FILE" << EOF
# robots.txt
# Auto-generated: $CURRENT_DATE
# Author: $GIT_AUTHOR <$GIT_EMAIL>
# Code sign-off: $GIT_AUTHOR

# Allow all bots
User-agent: *
Allow: /

# Sitemap location
Sitemap: ${BASE_URL}/sitemap.xml

# Disallow private/sensitive paths
Disallow: /private/
Disallow: /.git/
Disallow: /node_modules/
Disallow: /backups/
Disallow: /logs/
Disallow: /.env
Disallow: /config/

# Crawl-delay (optional, adjust as needed)
# Crawl-delay: 1

# Specific bot configurations
User-agent: Googlebot
Allow: /
Crawl-delay: 0

User-agent: Bingbot
Allow: /
Crawl-delay: 0

User-agent: Slurp
Allow: /

# Block bad bots (optional)
User-agent: AhrefsBot
Crawl-delay: 10

User-agent: MJ12bot
Crawl-delay: 10

# Additional sitemaps (if any)
# Sitemap: ${BASE_URL}/sitemap-images.xml
# Sitemap: ${BASE_URL}/sitemap-videos.xml
EOF

echo "✓ robots.txt generated successfully!"
echo "  Location: $ROBOTS_FILE"
echo "  Author: $GIT_AUTHOR"
