#!/bin/bash

# Connect to GitHub Repository
# Run this script to initialize git and connect to the remote repository

set -e

REPO_URL="https://github.com/speaks999/conductor.git"

echo "🔗 Connecting to GitHub repository..."
echo "Repository: $REPO_URL"
echo ""

# Check if git is initialized
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "📦 Initializing git repository..."
    git init
    git branch -M main 2>/dev/null || true
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already initialized"
fi

# Check if remote exists
if git remote get-url origin > /dev/null 2>&1; then
    CURRENT_URL=$(git remote get-url origin)
    if [ "$CURRENT_URL" != "$REPO_URL" ]; then
        echo "🔄 Updating remote URL..."
        git remote set-url origin "$REPO_URL"
        echo "✅ Remote URL updated"
    else
        echo "✅ Remote already configured correctly"
    fi
else
    echo "➕ Adding remote repository..."
    git remote add origin "$REPO_URL"
    echo "✅ Remote added"
fi

echo ""
echo "📋 Current git status:"
git status --short

echo ""
echo "📤 Ready to push! Run these commands:"
echo ""
echo "  git add ."
echo "  git commit -m 'Initial commit: Conductor application'"
echo "  git push -u origin main"
echo ""
echo "Or run: ./scripts/push-initial.sh"

