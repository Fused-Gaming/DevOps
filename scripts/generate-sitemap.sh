#!/bin/bash

# Generate sitemap.xml for SEO
# Author: User (via git config)
# Version: 1.0.0

set -e

SITEMAP_FILE="sitemap.xml"
CURRENT_DATE=$(date -u '+%Y-%m-%d')
BASE_URL="${BASE_URL:-https://example.com}"

echo "Generating sitemap.xml..."

# Get git author info
GIT_AUTHOR=$(git config user.name || echo "Unknown")
GIT_EMAIL=$(git config user.email || echo "unknown@example.com")

cat > "$SITEMAP_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Sitemap generated automatically
  Author: $GIT_AUTHOR <$GIT_EMAIL>
  Generated: $CURRENT_DATE
  Code sign-off: $GIT_AUTHOR
-->
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
        http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">

  <!-- Homepage -->
  <url>
    <loc>${BASE_URL}/</loc>
    <lastmod>$CURRENT_DATE</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>

  <!-- Documentation -->
  <url>
    <loc>${BASE_URL}/docs</loc>
    <lastmod>$CURRENT_DATE</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <!-- Quick Access -->
  <url>
    <loc>${BASE_URL}/quick-access</loc>
    <lastmod>$CURRENT_DATE</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <!-- Cheat Sheet -->
  <url>
    <loc>${BASE_URL}/cheatsheet</loc>
    <lastmod>$CURRENT_DATE</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>

  <!-- Security Guide -->
  <url>
    <loc>${BASE_URL}/security</loc>
    <lastmod>$CURRENT_DATE</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>

  <!-- GitHub Actions -->
  <url>
    <loc>${BASE_URL}/github-actions</loc>
    <lastmod>$CURRENT_DATE</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>

  <!-- Add more URLs dynamically from markdown files -->
EOF

# Find all markdown files and add them
if [ -d "docs" ]; then
  find docs -name "*.md" -type f | while read -r file; do
    # Convert file path to URL
    URL_PATH=$(echo "$file" | sed 's|docs/||' | sed 's|\.md$||' | sed 's|/README$||')
    LAST_MODIFIED=$(git log -1 --format="%ai" -- "$file" | cut -d' ' -f1 || echo "$CURRENT_DATE")

    cat >> "$SITEMAP_FILE" << EOF

  <!-- $file -->
  <url>
    <loc>${BASE_URL}/${URL_PATH}</loc>
    <lastmod>${LAST_MODIFIED}</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.6</priority>
  </url>
EOF
  done
fi

# Close the sitemap
cat >> "$SITEMAP_FILE" << EOF

</urlset>
EOF

echo "✓ sitemap.xml generated successfully!"
echo "  Location: $SITEMAP_FILE"
echo "  URLs included: $(grep -c "<url>" "$SITEMAP_FILE")"
echo "  Author: $GIT_AUTHOR"
