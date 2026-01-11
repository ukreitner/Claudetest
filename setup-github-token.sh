#!/bin/bash

# GitHub Token Setup Script
# This script helps you configure your GitHub Personal Access Token

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

CONFIG_FILE="$HOME/.github-repo-creator.conf"

echo -e "${BLUE}GitHub Repository Creator - Token Setup${NC}"
echo ""
echo "This script will help you configure your GitHub Personal Access Token."
echo ""

# Check if already configured
if [ -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}Warning: Configuration file already exists at $CONFIG_FILE${NC}"
    read -p "Overwrite? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

echo -e "${BLUE}Step 1: Create a GitHub Personal Access Token${NC}"
echo ""
echo "1. Visit: https://github.com/settings/tokens/new"
echo "2. Give it a name like 'Claude Code Repo Creator'"
echo "3. Set expiration (recommend: No expiration or 1 year)"
echo "4. Select scopes: Check 'repo' (Full control of private repositories)"
echo "5. Click 'Generate token'"
echo "6. Copy the token (you won't see it again!)"
echo ""

read -p "Press Enter when you have your token ready..."
echo ""

echo -e "${BLUE}Step 2: Enter Your Token${NC}"
echo ""
read -p "Paste your GitHub token here: " GITHUB_TOKEN

if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${RED}Error: Token cannot be empty${NC}"
    exit 1
fi

# Validate token format (basic check)
if [[ ! $GITHUB_TOKEN =~ ^(ghp_|github_pat_)[a-zA-Z0-9_]+ ]]; then
    echo -e "${YELLOW}Warning: Token doesn't match expected format (should start with ghp_ or github_pat_)${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

# Save token
echo "GITHUB_TOKEN=$GITHUB_TOKEN" > "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

echo ""
echo -e "${GREEN}✓ Token saved successfully!${NC}"
echo ""

# Test the token
echo -e "${BLUE}Step 3: Testing token...${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" \
    -H "Authorization: token $GITHUB_TOKEN" \
    https://api.github.com/user)

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ]; then
    USERNAME=$(echo "$BODY" | grep -o '"login": *"[^"]*"' | head -1 | sed 's/"login": *"\([^"]*\)"/\1/')
    echo -e "${GREEN}✓ Token is valid!${NC}"
    echo -e "Authenticated as: ${GREEN}$USERNAME${NC}"
    echo ""
    echo -e "${GREEN}Setup complete!${NC}"
    echo ""
    echo "You can now use ./create-repo-api.sh to create repositories."
    echo "Or just ask Claude Code: 'Create a new repo called my-project'"
else
    echo -e "${RED}✗ Token validation failed (HTTP $HTTP_CODE)${NC}"
    echo "Please check your token and try again."
    rm -f "$CONFIG_FILE"
    exit 1
fi
