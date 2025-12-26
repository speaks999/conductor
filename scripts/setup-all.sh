#!/bin/bash

# Complete Setup Script
# This script does everything: git init, connect, and push

set -e

REPO_URL="https://github.com/speaks999/conductor.git"

echo "🚀 Complete Conductor Setup"
echo "=========================="
echo ""

# Step 1: Initialize git if needed
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "📦 Step 1: Initializing git repository..."
    git init
    git branch -M main 2>/dev/null || git checkout -b main 2>/dev/null || true
    echo "✅ Git repository initialized"
else
    echo "✅ Step 1: Git repository already initialized"
fi

# Step 2: Add remote
if git remote get-url origin > /dev/null 2>&1; then
    CURRENT_URL=$(git remote get-url origin)
    if [ "$CURRENT_URL" != "$REPO_URL" ]; then
        echo "🔄 Step 2: Updating remote URL..."
        git remote set-url origin "$REPO_URL"
        echo "✅ Remote URL updated"
    else
        echo "✅ Step 2: Remote already configured"
    fi
else
    echo "➕ Step 2: Adding remote repository..."
    git remote add origin "$REPO_URL"
    echo "✅ Remote added"
fi

# Step 3: Stage files
echo ""
echo "📦 Step 3: Staging files..."
git add .

# Step 4: Check if there are changes
if git diff --staged --quiet 2>/dev/null; then
    echo "⚠️  Step 4: No changes to commit (everything already committed)"
    HAS_COMMITS=true
else
    echo "💾 Step 4: Creating commit..."
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
- Created setup scripts and documentation" || {
        echo "⚠️  Commit failed (might already be committed)"
        HAS_COMMITS=true
    }
    echo "✅ Commit created"
fi

# Step 5: Push
echo ""
echo "📤 Step 5: Pushing to GitHub..."
if git push -u origin main 2>&1; then
    echo ""
    echo "✅ Successfully pushed to $REPO_URL"
else
    echo ""
    echo "⚠️  Push failed. This might be because:"
    echo "   - The repository already has commits"
    echo "   - You need to pull first: git pull origin main --allow-unrelated-histories"
    echo "   - Authentication issues"
    echo ""
    echo "Try running: git push -u origin main --force"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Set up GitHub Secrets: https://github.com/speaks999/conductor/settings/secrets/actions"
echo "   2. Create Supabase project (see SETUP.md)"
echo "   3. Configure .env.local with your credentials"
echo "   4. Run: npm run dev"

