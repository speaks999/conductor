#!/bin/bash

# Script to generate package-lock.json and push it to GitHub

set -e

echo "🔧 Generating package-lock.json..."
npm install

echo ""
echo "✅ package-lock.json generated!"
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "❌ Git repository not initialized. Please run git init first."
    exit 1
fi

# Check if there are changes
if git diff --quiet package-lock.json 2>/dev/null && [ -f package-lock.json ]; then
    echo "ℹ️  package-lock.json already exists and is up to date."
    exit 0
fi

echo "📦 Staging package-lock.json..."
git add package-lock.json

echo ""
echo "💾 Committing..."
git commit -m "Add package-lock.json for CI/CD"

echo ""
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Done! Your workflows should now pass."
echo ""
echo "Next steps:"
echo "1. Go to: https://github.com/speaks999/conductor/actions"
echo "2. Re-run the failed workflows"
echo "3. They should now pass! ✅"

