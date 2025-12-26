#!/bin/bash

# Quick Push - If repository already exists, just push
# Use this if you've already created the repo on GitHub

set -e

echo "📤 Quick Push to GitHub"
echo "======================="
echo ""

# Check if git is initialized
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "📦 Initializing git repository..."
    git init
    git branch -M main
fi

# Check if we have commits
if ! git rev-parse HEAD > /dev/null 2>&1; then
    echo "📦 Staging files..."
    git add .
    echo "💾 Creating commit..."
    git commit -m "Initial commit: Conductor application"
fi

# Get repository URL
read -p "Enter your GitHub username: " github_username
read -p "Enter repository name [conductor]: " repo_name
repo_name=${repo_name:-conductor}

REPO_URL="https://github.com/${github_username}/${repo_name}.git"

# Add or update remote
if git remote get-url origin > /dev/null 2>&1; then
    git remote set-url origin "$REPO_URL"
    echo "✅ Remote updated"
else
    git remote add origin "$REPO_URL"
    echo "✅ Remote added"
fi

# Push
echo "📤 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Successfully pushed to $REPO_URL"

