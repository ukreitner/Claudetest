#!/bin/bash

# GitHub Repository Creator (API Version)
# Uses GitHub REST API directly - no gh CLI required
# Usage: ./create-repo-api.sh <repo-name> [description] [visibility]

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration file for GitHub token
CONFIG_FILE="$HOME/.github-repo-creator.conf"

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: curl is not installed.${NC}"
    exit 1
fi

# Check for GitHub token
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}GitHub Personal Access Token not configured.${NC}"
    echo ""
    echo "To set up:"
    echo "1. Go to https://github.com/settings/tokens/new"
    echo "2. Create a token with 'repo' scope"
    echo "3. Run: echo 'GITHUB_TOKEN=your_token_here' > $CONFIG_FILE"
    echo "4. Run: chmod 600 $CONFIG_FILE"
    echo ""
    exit 1
fi

# Load token
source "$CONFIG_FILE"

if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${RED}Error: GITHUB_TOKEN not set in $CONFIG_FILE${NC}"
    exit 1
fi

# Parse arguments
REPO_NAME="$1"
DESCRIPTION="${2:-Created via Claude Code}"
VISIBILITY="${3:-private}"

if [ -z "$REPO_NAME" ]; then
    echo -e "${RED}Error: Repository name is required${NC}"
    echo "Usage: $0 <repo-name> [description] [visibility]"
    echo "Example: $0 my-new-project 'My awesome project' public"
    exit 1
fi

# Convert visibility to boolean for API
PRIVATE="true"
if [ "$VISIBILITY" = "public" ]; then
    PRIVATE="false"
fi

echo -e "${BLUE}Creating GitHub repository via API...${NC}"
echo "Name: $REPO_NAME"
echo "Description: $DESCRIPTION"
echo "Visibility: $VISIBILITY"
echo ""

# Create JSON payload
JSON_PAYLOAD=$(cat <<EOF
{
  "name": "$REPO_NAME",
  "description": "$DESCRIPTION",
  "private": $PRIVATE,
  "auto_init": true
}
EOF
)

# Call GitHub API
RESPONSE=$(curl -s -w "\n%{http_code}" \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD" \
    https://api.github.com/user/repos)

# Split response and status code
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "201" ]; then
    REPO_URL=$(echo "$BODY" | grep -o '"html_url": *"[^"]*"' | head -1 | sed 's/"html_url": *"\([^"]*\)"/\1/')
    CLONE_URL=$(echo "$BODY" | grep -o '"clone_url": *"[^"]*"' | head -1 | sed 's/"clone_url": *"\([^"]*\)"/\1/')

    echo -e "${GREEN}✓ Repository created successfully!${NC}"
    echo -e "${GREEN}URL: $REPO_URL${NC}"
    echo ""

    # Ask if user wants to clone
    if [ -t 0 ]; then
        read -p "Clone repository now? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git clone "$CLONE_URL"
            echo -e "${GREEN}✓ Repository cloned to: ./$REPO_NAME${NC}"
        fi
    else
        echo "To clone: git clone $CLONE_URL"
    fi

    exit 0
else
    echo -e "${RED}Error: Failed to create repository (HTTP $HTTP_CODE)${NC}"
    echo "$BODY" | grep -o '"message": *"[^"]*"' | sed 's/"message": *"\([^"]*\)"/Error: \1/'
    exit 1
fi
