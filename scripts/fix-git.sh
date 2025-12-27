#!/bin/bash

# Fix Git Repository
# This script removes any corrupted git state and reinitializes

set -e

echo "🔧 Fixing git repository..."
echo ""

# Remove existing .git if it exists but is corrupted
if [ -d .git ] || [ -f .git ]; then
    echo "🗑️  Removing existing git state..."
    rm -rf .git
    echo "✅ Removed old git state"
fi

# Initialize fresh git repository
echo "📦 Initializing fresh git repository..."
git init
git branch -M main

# Add remote
REPO_URL="https://github.com/speaks999/conductor.git"
echo "➕ Adding remote repository..."
git remote add origin "$REPO_URL"

echo ""
echo "✅ Git repository fixed and ready!"
echo ""
echo "📋 Current status:"
git status --short

echo ""
echo "📤 Next: Run ./scripts/push-initial.sh to push your code"


