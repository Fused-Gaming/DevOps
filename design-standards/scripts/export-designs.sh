#!/bin/bash
# Export Penpot designs to static assets
# Usage: ./scripts/export-designs.sh

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎨 VLN Design Export Tool${NC}"
echo "================================"
echo ""

# Check if .env.local exists
if [ ! -f ".env.local" ]; then
  echo -e "${RED}❌ Error: .env.local not found${NC}"
  echo "Please create .env.local with your Penpot token"
  echo "See .env.example for template"
  exit 1
fi

# Load environment variables
source .env.local

# Verify token is set
if [ -z "$PENPOT_ACCESS_TOKEN" ]; then
  echo -e "${RED}❌ Error: PENPOT_ACCESS_TOKEN not set${NC}"
  echo "Add your token to .env.local"
  exit 1
fi

# Verify project ID is set
if [ -z "$PENPOT_PROJECT_ID" ]; then
  echo -e "${RED}❌ Error: PENPOT_PROJECT_ID not set${NC}"
  echo "Add your project ID to .env.local"
  exit 1
fi

# Setup directories
EXPORT_DIR=${EXPORT_DIR:-"./static/design-assets"}
mkdir -p "$EXPORT_DIR"

echo -e "${GREEN}✓${NC} Configuration loaded"
echo -e "${GREEN}✓${NC} Export directory: $EXPORT_DIR"
echo ""

# Test authentication
echo "🔐 Testing authentication..."
AUTH_TEST=$(curl -s -w "%{http_code}" -o /dev/null \
  -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  "$PENPOT_API_URL/rpc/command/get-profile")

if [ "$AUTH_TEST" != "200" ]; then
  echo -e "${RED}❌ Authentication failed (HTTP $AUTH_TEST)${NC}"
  echo "Please check your PENPOT_ACCESS_TOKEN"
  exit 1
fi

echo -e "${GREEN}✓${NC} Authentication successful"
echo ""

# Get all files in project
echo "📦 Fetching files from project..."
FILES_JSON=$(curl -s \
  -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
  "$PENPOT_API_URL/rpc/command/get-project-files?project-id=$PENPOT_PROJECT_ID")

# Check if jq is available
if ! command -v jq &> /dev/null; then
  echo -e "${RED}❌ Error: jq is not installed${NC}"
  echo "Install with: sudo apt install jq"
  exit 1
fi

# Extract file IDs and names
FILE_COUNT=$(echo "$FILES_JSON" | jq -r 'length')

if [ "$FILE_COUNT" -eq 0 ]; then
  echo -e "${RED}❌ No files found in project${NC}"
  echo "Please check your PENPOT_PROJECT_ID"
  exit 1
fi

echo -e "${GREEN}✓${NC} Found $FILE_COUNT files"
echo ""

# Export each file
EXPORTED=0
for row in $(echo "$FILES_JSON" | jq -r '.[] | @base64'); do
  _jq() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

  FILE_ID=$(_jq '.id')
  FILE_NAME=$(_jq '.name')

  echo -e "${BLUE}Exporting:${NC} $FILE_NAME"

  # Create directory for this file
  FILE_DIR="$EXPORT_DIR/$FILE_NAME"
  mkdir -p "$FILE_DIR"

  # Export as ZIP
  ZIP_PATH="$FILE_DIR/export.zip"
  HTTP_CODE=$(curl -s -w "%{http_code}" -o "$ZIP_PATH" \
    -H "Authorization: Token $PENPOT_ACCESS_TOKEN" \
    "$PENPOT_API_URL/export/file/$FILE_ID.zip")

  if [ "$HTTP_CODE" != "200" ]; then
    echo -e "${RED}  ❌ Export failed (HTTP $HTTP_CODE)${NC}"
    rm -f "$ZIP_PATH"
    continue
  fi

  # Unzip
  unzip -q "$ZIP_PATH" -d "$FILE_DIR" 2>/dev/null
  rm "$ZIP_PATH"

  echo -e "${GREEN}  ✓${NC} Exported to: $FILE_DIR"
  EXPORTED=$((EXPORTED + 1))
done

echo ""
echo "================================"
echo -e "${GREEN}✅ Export complete!${NC}"
echo -e "   Exported: $EXPORTED/$FILE_COUNT files"
echo -e "   Location: $EXPORT_DIR"
echo ""

# Generate index
echo "📝 Generating index..."
cat > "$EXPORT_DIR/README.md" << EOF
# VLN Design Assets

Exported from Penpot on $(date)

## Files

EOF

for dir in "$EXPORT_DIR"/*/; do
  dirname=$(basename "$dir")
  echo "- [$dirname](./$dirname/)" >> "$EXPORT_DIR/README.md"
done

echo -e "${GREEN}✓${NC} Index generated: $EXPORT_DIR/README.md"
echo ""
echo "🎉 Done! Your designs are ready to use."
