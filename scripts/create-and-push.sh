#!/bin/bash

# Create Repository and Push
# This script creates the GitHub repo if it doesn't exist, then pushes

set -e

echo "🚀 Create Repository and Push"
echo "=============================="
echo ""

# Check if git is initialized and has commits
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "📦 Initializing git repository..."
    git init
    git branch -M main
fi

if ! git rev-parse HEAD > /dev/null 2>&1; then
    echo "📦 Staging files..."
    git add .
    echo "💾 Creating commit..."
    git commit -m "Initial commit: Conductor application"
fi

# Get repository details
read -p "Enter your GitHub username: " github_username
read -p "Enter repository name [conductor]: " repo_name
repo_name=${repo_name:-conductor}

REPO_URL="https://github.com/${github_username}/${repo_name}.git"

# Create repository using GitHub CLI
if command -v gh &> /dev/null; then
    if ! gh auth status &> /dev/null; then
        echo "🔐 Please log in to GitHub:"
        gh auth login
    fi
    
    # Check if repo exists
    if gh repo view "${github_username}/${repo_name}" > /dev/null 2>&1; then
        echo "✅ Repository already exists"
    else
        echo "🆕 Creating repository..."
        read -p "Description [Conductor — the control plane for AI-native software delivery]: " repo_description
        repo_description=${repo_description:-Conductor — the control plane for AI-native software delivery}
        read -p "Make it private? [y/N]: " is_private
        
        if [ "$is_private" = "y" ] || [ "$is_private" = "Y" ]; then
            gh repo create "$repo_name" --description "$repo_description" --private
        else
            gh repo create "$repo_name" --description "$repo_description" --public
        fi
        echo "✅ Repository created"
    fi
else
    echo "⚠️  GitHub CLI (gh) not installed."
    echo ""
    echo "Please create the repository manually:"
    echo "1. Go to: https://github.com/new"
    echo "2. Repository name: $repo_name"
    echo "3. Description: Conductor — the control plane for AI-native software delivery"
    echo "4. Choose public or private"
    echo "5. DO NOT check any boxes (no README, .gitignore, or license)"
    echo "6. Click 'Create repository'"
    echo ""
    read -p "Press Enter when you've created the repository..."
fi

# Add remote
if git remote get-url origin > /dev/null 2>&1; then
    git remote set-url origin "$REPO_URL"
else
    git remote add origin "$REPO_URL"
fi

# Push
echo "📤 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Successfully pushed to $REPO_URL"
echo ""
echo "🎉 Your repository is ready!"
echo ""
echo "📝 Next steps:"
echo "   1. Set up GitHub Secrets: $REPO_URL/settings/secrets/actions"
echo "   2. Create Supabase project (see SETUP.md)"
echo "   3. Configure .env.local"

