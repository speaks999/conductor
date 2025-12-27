#!/bin/bash

# Script to update package-lock.json after package.json changes

set -e

echo "🔄 Updating package-lock.json..."
npm install

echo ""
echo "✅ package-lock.json updated!"
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "❌ Git repository not initialized."
    exit 1
fi

# Check if there are changes
if git diff --quiet package-lock.json 2>/dev/null; then
    echo "ℹ️  package-lock.json is already up to date."
    exit 0
fi

echo "📦 Staging package-lock.json..."
git add package-lock.json

echo ""
echo "💾 Committing..."
git commit -m "Update package-lock.json for AI SDK v6"

echo ""
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Done! Your workflows should now pass."

