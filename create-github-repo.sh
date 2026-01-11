#!/bin/bash

# GitHub Repository Creator Script
# Usage: ./create-github-repo.sh <repo-name> [description] [visibility]

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed.${NC}"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: Not authenticated with GitHub CLI${NC}"
    echo "Run: gh auth login"
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

echo -e "${BLUE}Creating GitHub repository...${NC}"
echo "Name: $REPO_NAME"
echo "Description: $DESCRIPTION"
echo "Visibility: $VISIBILITY"
echo ""

# Create the repository
REPO_URL=$(gh repo create "$REPO_NAME" \
    --description "$DESCRIPTION" \
    --"$VISIBILITY" \
    --clone \
    2>&1 | grep -oP 'https://github\.com/[^\s]+' | head -1)

if [ -z "$REPO_URL" ]; then
    # Try alternative method to get repo URL
    USERNAME=$(gh api user -q .login)
    REPO_URL="https://github.com/$USERNAME/$REPO_NAME"
fi

echo -e "${GREEN}✓ Repository created successfully!${NC}"
echo -e "${GREEN}URL: $REPO_URL${NC}"
echo ""
echo "Repository has been cloned to: ./$REPO_NAME"
echo ""
echo "Next steps:"
echo "  cd $REPO_NAME"
echo "  # Start coding!"

exit 0
