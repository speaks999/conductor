#!/bin/bash

# Setup Conductor from Scratch
# This script does a complete fresh setup

set -e

echo "🚀 Conductor - Fresh Setup from Scratch"
echo "========================================"
echo ""

# Step 1: Clean up any existing git state
echo "🧹 Step 1: Cleaning up any existing git state..."
if [ -d .git ]; then
    rm -rf .git
    echo "✅ Removed existing git repository"
else
    echo "✅ No existing git repository found"
fi

# Step 2: Initialize fresh git repository
echo ""
echo "📦 Step 2: Initializing fresh git repository..."
git init
git branch -M main
echo "✅ Git repository initialized"

# Step 2.5: Stage and commit files
echo ""
echo "📦 Staging files..."
git add .
echo "💾 Creating initial commit..."
git commit -m "Initial commit: Conductor application

- Set up Next.js project with TypeScript
- Implemented Planner using Vercel AI SDK v6
- Built Orchestrator state machine
- Created Cursor Background Agent adapter
- Implemented GitHub adapter for PR management
- Set up Supabase database schema
- Created API endpoints for job management
- Built dashboard UI with Next.js and Tailwind CSS
- Added GitHub Actions workflows
- Created setup scripts and documentation"
echo "✅ Files committed"

# Step 3: Create GitHub repository
echo ""
echo "🆕 Step 3: Creating GitHub repository..."

# Check if GitHub CLI is installed
if command -v gh &> /dev/null; then
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
    
    # Try to create repository
    if [ "$is_private" = "y" ] || [ "$is_private" = "Y" ]; then
        if gh repo create "$repo_name" \
            --description "$repo_description" \
            --private \
            --source=. \
            --remote=origin \
            --push 2>&1; then
            REPO_URL="https://github.com/$(gh api user --jq .login)/$repo_name"
            echo "✅ Repository created and pushed!"
        else
            echo "⚠️  Repository '$repo_name' might already exist or there was an error."
            echo "🔗 Attempting to connect to existing repository..."
            REPO_URL="https://github.com/$(gh api user --jq .login)/$repo_name"
            git remote add origin "$REPO_URL.git" 2>/dev/null || git remote set-url origin "$REPO_URL.git"
            git push -u origin main
            echo "✅ Connected to existing repository and pushed!"
        fi
    else
        if gh repo create "$repo_name" \
            --description "$repo_description" \
            --public \
            --source=. \
            --remote=origin \
            --push 2>&1; then
            REPO_URL="https://github.com/$(gh api user --jq .login)/$repo_name"
            echo "✅ Repository created and pushed!"
        else
            echo "⚠️  Repository '$repo_name' might already exist or there was an error."
            echo "🔗 Attempting to connect to existing repository..."
            REPO_URL="https://github.com/$(gh api user --jq .login)/$repo_name"
            git remote add origin "$REPO_URL.git" 2>/dev/null || git remote set-url origin "$REPO_URL.git"
            git push -u origin main
            echo "✅ Connected to existing repository and pushed!"
        fi
    fi
    
else
    echo "⚠️  GitHub CLI (gh) is not installed."
    echo ""
    echo "Please create the repository manually:"
    echo "1. Go to: https://github.com/new"
    echo "2. Repository name: conductor"
    echo "3. Description: Conductor — the control plane for AI-native software delivery"
    echo "4. Choose public or private"
    echo "5. DO NOT initialize with README, .gitignore, or license"
    echo "6. Click 'Create repository'"
    echo ""
    read -p "Press Enter when you've created the repository..."
    
    read -p "Enter your GitHub username: " github_username
    read -p "Enter repository name [conductor]: " repo_name
    repo_name=${repo_name:-conductor}
    
    REPO_URL="https://github.com/${github_username}/${repo_name}.git"
    
    echo ""
    echo "🔗 Connecting to repository..."
    git remote add origin "$REPO_URL"
    echo "✅ Remote added"
    
    echo "📤 Pushing to GitHub..."
    git push -u origin main
    
    echo "✅ Successfully pushed!"
fi

echo ""
echo "🎉 Setup Complete!"
echo ""
echo "📋 Repository: $REPO_URL"
echo ""
echo "📝 Next Steps:"
echo ""
echo "1. Set up GitHub Secrets (for CI/CD):"
echo "   Go to: $REPO_URL/settings/secrets/actions"
echo "   Add these secrets:"
echo "   - NEXT_PUBLIC_SUPABASE_URL"
echo "   - NEXT_PUBLIC_SUPABASE_ANON_KEY"
echo "   - SUPABASE_SERVICE_ROLE_KEY"
echo "   - OPENAI_API_KEY"
echo "   - GITHUB_TOKEN (with 'workflow' scope!)"
echo "   - CURSOR_API_KEY (when available)"
echo ""
echo "2. Create Supabase project:"
echo "   - Go to: https://app.supabase.com"
echo "   - Create new project"
echo "   - Run migration: supabase/migrations/001_initial_schema.sql"
echo "   - Get API keys from Settings > API"
echo ""
echo "3. Configure environment:"
echo "   cp .env.local.example .env.local"
echo "   # Edit .env.local with your credentials"
echo ""
echo "4. Start development:"
echo "   npm install"
echo "   npm run dev"
echo ""
echo "📚 Documentation:"
echo "   - Quick Start: QUICKSTART.md"
echo "   - Setup Guide: SETUP.md"
echo "   - Implementation: IMPLEMENTATION.md"

