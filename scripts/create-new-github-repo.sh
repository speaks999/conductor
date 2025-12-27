#!/bin/bash

# Create a New GitHub Repository
# This script helps you create a fresh GitHub repository

set -e

echo "🆕 Create New GitHub Repository"
echo "================================"
echo ""

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI (gh) is not installed."
    echo ""
    echo "Option 1: Install GitHub CLI"
    echo "  macOS: brew install gh"
    echo "  Or: https://cli.github.com/"
    echo ""
    echo "Option 2: Create repository manually"
    echo "  1. Go to: https://github.com/new"
    echo "  2. Repository name: conductor (or your choice)"
    echo "  3. Description: Conductor — the control plane for AI-native software delivery"
    echo "  4. Choose public or private"
    echo "  5. DO NOT initialize with README, .gitignore, or license"
    echo "  6. Click 'Create repository'"
    echo "  7. Then run: ./scripts/connect-to-new-repo.sh"
    exit 1
fi

# Check if logged in
if ! gh auth status &> /dev/null; then
    echo "🔐 Please log in to GitHub:"
    gh auth login
fi

echo "Enter repository details:"
read -p "Repository name [conductor]: " repo_name
repo_name=${repo_name:-conductor}

read -p "Description [Conductor — the control plane for AI-native software delivery]: " repo_description
repo_description=${repo_description:-Conductor — the control plane for AI-native software delivery}

read -p "Make it private? [y/N]: " is_private

echo ""
echo "Creating repository: $repo_name"
echo "Description: $repo_description"
echo ""

# Remove old remote if exists
if git remote get-url origin > /dev/null 2>&1; then
    echo "🔄 Removing old remote..."
    git remote remove origin
fi

# Create repository
if [ "$is_private" = "y" ] || [ "$is_private" = "Y" ]; then
    gh repo create "$repo_name" \
        --description "$repo_description" \
        --private \
        --source=. \
        --remote=origin \
        --push
else
    gh repo create "$repo_name" \
        --description "$repo_description" \
        --public \
        --source=. \
        --remote=origin \
        --push
fi

echo ""
echo "✅ Repository created and pushed!"
echo ""
echo "🔗 Repository URL: https://github.com/$(gh api user --jq .login)/$repo_name"
echo ""
echo "📝 Next steps:"
echo "   1. Set up GitHub Secrets (Settings > Secrets and variables > Actions)"
echo "   2. Create Supabase project (see SETUP.md)"
echo "   3. Configure .env.local with your credentials"


