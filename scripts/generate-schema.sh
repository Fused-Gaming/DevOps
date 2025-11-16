#!/bin/bash

# Generate schema.json for structured data / SEO
# Author: User (via git config)
# Version: 1.0.0

set -e

SCHEMA_FILE="schema.json"
CURRENT_DATE=$(date -u '+%Y-%m-%d')

# Get git author info
GIT_AUTHOR=$(git config user.name || echo "Unknown")
GIT_EMAIL=$(git config user.email || echo "unknown@example.com")
GIT_URL=$(git config --get remote.origin.url || echo "")

# Extract repo name
REPO_NAME=$(basename "$(pwd)")

echo "Generating schema.json..."

cat > "$SCHEMA_FILE" << EOF
{
  "\$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "title": "DevOps Repository Schema",
  "description": "Structured data for $REPO_NAME repository",
  "metadata": {
    "author": "$GIT_AUTHOR",
    "email": "$GIT_EMAIL",
    "generated": "$CURRENT_DATE",
    "version": "1.0.0",
    "repository": "$GIT_URL",
    "codeSignedBy": "$GIT_AUTHOR"
  },
  "schemaOrg": {
    "@context": "https://schema.org",
    "@type": "SoftwareSourceCode",
    "name": "$REPO_NAME",
    "description": "DevOps tools, scripts, and automation workflows",
    "author": {
      "@type": "Person",
      "name": "$GIT_AUTHOR",
      "email": "$GIT_EMAIL"
    },
    "dateCreated": "$CURRENT_DATE",
    "dateModified": "$CURRENT_DATE",
    "codeRepository": "$GIT_URL",
    "programmingLanguage": [
      "Bash",
      "JavaScript",
      "YAML",
      "Markdown"
    ],
    "keywords": [
      "devops",
      "automation",
      "ci-cd",
      "github-actions",
      "deployment",
      "testing",
      "security",
      "seo",
      "claude-code"
    ],
    "license": "MIT",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    }
  },
  "openGraph": {
    "og:type": "website",
    "og:title": "$REPO_NAME - DevOps Automation",
    "og:description": "Professional DevOps tools and automation workflows",
    "og:url": "$GIT_URL",
    "og:site_name": "$REPO_NAME",
    "og:locale": "en_US",
    "article:author": "$GIT_AUTHOR"
  },
  "twitter": {
    "twitter:card": "summary_large_image",
    "twitter:title": "$REPO_NAME - DevOps Automation",
    "twitter:description": "Professional DevOps tools and automation workflows",
    "twitter:creator": "@$GIT_AUTHOR"
  },
  "features": [
    {
      "name": "Claude Code Usage Tracking",
      "description": "Automatic tracking of Claude Code usage with cost estimation",
      "author": "$GIT_AUTHOR"
    },
    {
      "name": "Enhanced Testing",
      "description": "Comprehensive test suite with detailed diagnostics",
      "author": "$GIT_AUTHOR"
    },
    {
      "name": "Interactive Makefile",
      "description": "Beautiful progress bars and status updates",
      "author": "$GIT_AUTHOR"
    },
    {
      "name": "SEO Automation",
      "description": "Automatic generation of sitemap, robots.txt, and more",
      "author": "$GIT_AUTHOR"
    }
  ],
  "contributors": [
    {
      "name": "$GIT_AUTHOR",
      "email": "$GIT_EMAIL",
      "role": "Lead Developer",
      "contributions": "All features and workflows"
    }
  ]
}
EOF

echo "✓ schema.json generated successfully!"
echo "  Location: $SCHEMA_FILE"
echo "  Author: $GIT_AUTHOR"
echo "  Generated: $CURRENT_DATE"
