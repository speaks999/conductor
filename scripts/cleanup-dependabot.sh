#!/bin/bash

# Script to delete all Dependabot branches and close PRs

set -e

echo "🧹 Cleaning up Dependabot branches and PRs..."
echo ""

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "Install it with: brew install gh"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI."
    echo "Run: gh auth login"
    exit 1
fi

echo "📋 Finding Dependabot PRs..."
PRS=$(gh pr list --author "app/dependabot" --json number,title,headRefName --jq '.[] | "\(.number)|\(.headRefName)"')

if [ -z "$PRS" ]; then
    echo "✅ No Dependabot PRs found!"
    exit 0
fi

echo "Found Dependabot PRs:"
echo "$PRS" | while IFS='|' read -r number branch; do
    echo "  PR #$number: $branch"
done

echo ""
read -p "Do you want to close all Dependabot PRs and delete their branches? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled."
    exit 0
fi

echo ""
echo "🗑️  Closing PRs and deleting branches..."

echo "$PRS" | while IFS='|' read -r number branch; do
    echo "  Closing PR #$number ($branch)..."
    gh pr close "$number" --delete-branch --comment "Closing Dependabot PR - only maintaining main branch"
done

echo ""
echo "✅ All Dependabot PRs closed and branches deleted!"
echo ""
echo "💡 To prevent future Dependabot PRs, you can:"
echo "   1. Disable Dependabot in repository settings"
echo "   2. Or configure it to only update specific dependencies"
echo ""
echo "   Go to: https://github.com/speaks999/conductor/settings/security"

