#!/bin/bash

# Connect to a New GitHub Repository (Manual Creation)
# Use this if you created the repo manually on GitHub

set -e

echo "🔗 Connect to New GitHub Repository"
echo "===================================="
echo ""

read -p "Enter your GitHub username: " github_username
read -p "Enter repository name: " repo_name

REPO_URL="https://github.com/${github_username}/${repo_name}.git"

echo ""
echo "Repository URL: $REPO_URL"
read -p "Is this correct? [Y/n]: " confirm

if [ "$confirm" = "n" ] || [ "$confirm" = "N" ]; then
    echo "Cancelled."
    exit 1
fi

# Remove old remote if exists
if git remote get-url origin > /dev/null 2>&1; then
    echo "🔄 Removing old remote..."
    git remote remove origin
fi

# Add new remote
echo "➕ Adding remote repository..."
git remote add origin "$REPO_URL"

# Verify remote
echo "✅ Remote configured:"
git remote -v

echo ""
echo "📤 Ready to push! Run:"
echo "  git push -u origin main"
echo ""
echo "Or run: ./scripts/push-initial.sh"


